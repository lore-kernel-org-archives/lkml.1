Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYIDOq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYIDOq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYIDOqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:46:19 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:52599 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYIDOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:46:19 -0400
Message-ID: <48BFF427.7040305@cs.columbia.edu>
Date: Thu, 04 Sep 2008 10:43:51 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v3][PATCH 8/9] File descriprtors (dump)
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu> <20080904094740.GY14473@hawkmoon.kerlabs.com>
In-Reply-To: <20080904094740.GY14473@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Louis Rilling wrote:
> On Thu, Sep 04, 2008 at 04:05:50AM -0400, Oren Laadan wrote:
>> Dump the files_struct of a task with 'struct cr_hdr_files', followed by
>> all open file descriptors. Since FDs can be shared, they are assigned a
>> tag and registered in the object hash.
>>
>> For each open FD there is a 'struct cr_hdr_fd_ent' with the FD, its tag
>> and its close-on-exec property. If the FD is to be saved (first time)
>> then this is followed by a 'struct cr_hdr_fd_data' with the FD state.
>> Then will come the next FD and so on.
>>
>> This patch only handles basic FDs - regular files, directories and also
>> symbolic links.
>>
> 
> [...]
> 
>> diff --git a/checkpoint/ckpt_file.c b/checkpoint/ckpt_file.c
>> new file mode 100644
>> index 0000000..34df371
>> --- /dev/null
>> +++ b/checkpoint/ckpt_file.c
>> @@ -0,0 +1,224 @@
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
>> +#include <linux/file.h>
>> +#include <linux/fdtable.h>
>> +#include <linux/ckpt.h>
>> +#include <linux/ckpt_hdr.h>
>> +
>> +#include "ckpt_file.h"
>> +
>> +#define CR_DEFAULT_FDTABLE  256
>> +
>> +/**
>> + * cr_scan_fds - scan file table and construct array of open fds
>> + * @files: files_struct pointer
>> + * @fdtable: (output) array of open fds
>> + * @return: the number of open fds found
>> + *
>> + * Allocates the file descriptors array (*fdtable), caller should free
>> + */
>> +int cr_scan_fds(struct files_struct *files, int **fdtable)
>> +{
>> +	struct fdtable *fdt;
>> +	int *fdlist;
>> +	int i, n, max;
>> +
>> +	max = CR_DEFAULT_FDTABLE;
>> +
>> + repeat:
>> +	n = 0;
>> +	fdlist = kmalloc(max * sizeof(*fdlist), GFP_KERNEL);
>> +	if (!fdlist)
>> +		return -ENOMEM;
>> +
>> +	spin_lock(&files->file_lock);
>> +	fdt = files_fdtable(files);
>> +	for (i = 0; i < fdt->max_fds; i++) {
>> +		if (fcheck_files(files, i)) {
>> +			if (n == max) {
>> +				spin_unlock(&files->file_lock);
>> +				kfree(fdlist);
>> +				max *= 2;
>> +				if (max < 0) {	/* overflow ? */
>> +					n = -EMFILE;
>> +					break;
>> +				}
>> +				goto repeat;
> 
> 				fdlist = krealloc(fdlist, max, GFP_KERNEL)?
> 
> Sorry, I should have suggested this in my first review.

That's a good point; I did it this way to be paranoid, even though the
the checkpointee is supposed to be frozen (e.g., if the checkpointee is
forcefully killed by, say, OOM, and it's fdt->max_fds goes to zero. But
now I notice that check_files() already tests for this. I'm not sure it
makes the code simpler, but I'll fix that.

Oren.

> 
> Louis
> 
>> +			}
>> +			fdlist[n++] = i;
>> +		}
>> +	}
>> +	spin_unlock(&files->file_lock);
>> +
>> +	*fdtable = fdlist;
>> +	return n;
>> +}
>> +
> 
