Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYIQAMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYIQAMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYIQAML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 20:12:11 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:35110 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYIQAMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 20:12:10 -0400
Message-ID: <48D04B19.9060502@cs.columbia.edu>
Date: Tue, 16 Sep 2008 20:11:05 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 9/9] Restore open file descriprtors
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <1221347167-9956-10-git-send-email-orenl@cs.columbia.edu> <20080916230850.GB25445@us.ibm.com>
In-Reply-To: <20080916230850.GB25445@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> Restore open file descriptors: for each FD read 'struct cr_hdr_fd_ent'
>> and lookup objref in the hash table; if not found (first occurence), read
>> in 'struct cr_hdr_fd_data', create a new FD and register in the hash.
>> Otherwise attach the file pointer from the hash as an FD.
>>
>> This patch only handles basic FDs - regular files, directories and also
>> symbolic links.
>>
>> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
>> ---
>>  checkpoint/Makefile        |    2 +-
>>  checkpoint/restart.c       |    4 +
>>  checkpoint/rstr_file.c     |  202 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/checkpoint.h |    1 +
>>  4 files changed, 208 insertions(+), 1 deletions(-)
>>  create mode 100644 checkpoint/rstr_file.c
>>
>> diff --git a/checkpoint/Makefile b/checkpoint/Makefile
>> index 7496695..88bbc10 100644
>> --- a/checkpoint/Makefile
>> +++ b/checkpoint/Makefile
>> @@ -3,4 +3,4 @@
>>  #
>>
>>  obj-$(CONFIG_CHECKPOINT_RESTART) += sys.o checkpoint.o restart.o objhash.o \
>> -		ckpt_mem.o rstr_mem.o ckpt_file.o
>> +		ckpt_mem.o rstr_mem.o ckpt_file.o rstr_file.o
>> diff --git a/checkpoint/restart.c b/checkpoint/restart.c
>> index a0d5e60..956e274 100644
>> --- a/checkpoint/restart.c
>> +++ b/checkpoint/restart.c
>> @@ -212,6 +212,10 @@ static int cr_read_task(struct cr_ctx *ctx)
>>  	cr_debug("memory: ret %d\n", ret);
>>  	if (ret < 0)
>>  		goto out;
>> +	ret = cr_read_files(ctx);
>> +	cr_debug("files: ret %d\n", ret);
>> +	if (ret < 0)
>> +		goto out;
>>  	ret = cr_read_thread(ctx);
>>  	cr_debug("thread: ret %d\n", ret);
>>  	if (ret < 0)
>> diff --git a/checkpoint/rstr_file.c b/checkpoint/rstr_file.c
>> new file mode 100644
>> index 0000000..780c0fc
>> --- /dev/null
>> +++ b/checkpoint/rstr_file.c
>> @@ -0,0 +1,202 @@
>> +/*
>> + *  Checkpoint file descriptors
>> + *
>> + *  Copyright (C) 2008 Oren Laadan
>> + *
>> + *  This file is subject to the terms and conditions of the GNU General Public
>> + *  License.  See the file COPYING in the main directory of the Linux
>> + *  distribution for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/sched.h>
>> +#include <linux/fs.h>
>> +#include <linux/file.h>
>> +#include <linux/fdtable.h>
>> +#include <linux/fsnotify.h>
>> +#include <linux/syscalls.h>
>> +#include <linux/checkpoint.h>
>> +#include <linux/checkpoint_hdr.h>
>> +
>> +#include "checkpoint_file.h"
>> +
>> +static int cr_close_all_fds(struct files_struct *files)
>> +{
>> +	int *fdtable;
>> +	int nfds;
>> +
>> +	nfds = cr_scan_fds(files, &fdtable);
>> +	if (nfds < 0)
>> +		return nfds;
>> +	while (nfds--)
>> +		sys_close(fdtable[nfds]);
>> +	kfree(fdtable);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * cr_attach_file - attach a lonely file ptr to a file descriptor
>> + * @file: lonely file pointer
>> + */
>> +static int cr_attach_file(struct file *file)
>> +{
>> +	int fd = get_unused_fd_flags(0);
>> +
>> +	if (fd >= 0) {
>> +		fsnotify_open(file->f_path.dentry);
>> +		fd_install(fd, file);
>> +	}
>> +	return fd;
>> +}
>> +
>> +#define CR_SETFL_MASK (O_APPEND|O_NONBLOCK|O_NDELAY|FASYNC|O_DIRECT|O_NOATIME)
>> +
>> +/* cr_read_fd_data - restore the state of a given file pointer */
>> +static int
>> +cr_read_fd_data(struct cr_ctx *ctx, struct files_struct *files, int parent)
>> +{
>> +	struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
> 
> You're leaking hh in a whole slew of error paths.

No. (this was discussed earlier already).

cr_hbuf_get() "allocates" space inside a dedicated buffer for headers
in the checkpoint context (ctx->hbuf). It does not allocate new kernel
memory. Instead, it returns the current position in that buffer
ctx->hbuf[ctx->hpos], and advances ctx->hpos appropriately. On the
other side, cr_hbuf_put() reverses that effect, reducing ctx->hpos
accordingly.

If an error occurs, the checkpoint (or restart) operation is aborted,
and eventually the context (ctx) will be cleaned up; at that point the
special purpose buffer will be freed.

[...]

Oren.


