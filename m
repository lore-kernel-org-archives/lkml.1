Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYHUF16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYHUF16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYHUF1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:27:49 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:43413 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYHUF1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:27:48 -0400
Date: Thu, 21 Aug 2008 01:26:33 -0400 (EDT)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: dave@linux.vnet.ibm.com
cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v2][PATCH 9/9] File descriprtors (restore)
In-Reply-To: <Pine.LNX.4.64.0808202307270.17436@takamine.ncl.cs.columbia.edu>
Message-ID: <Pine.LNX.4.64.0808210122510.4445@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
 <Pine.LNX.4.64.0808202307270.17436@takamine.ncl.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Restore open file descriptors: for each FD read 'struct cr_hdr_fd_ent'
> and lookup tag in the hash table; if not found (first occurence), read
> in 'struct cr_hdr_fd_data', create a new FD and register in the hash.
> Otherwise attach the file pointer from the hash as an FD.
>
> This patch only handles basic FDs - regular files, directories and also
> symbolic links.
>
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
> ---
>  checkpoint/Makefile     |    2 +-
>  checkpoint/checkpoint.c |    3 +
>  checkpoint/ckpt.h       |    6 +-
>  checkpoint/restart.c    |    3 +
>  checkpoint/rstr_file.c  |  202 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 213 insertions(+), 3 deletions(-)
>  create mode 100644 checkpoint/rstr_file.c
>

To restore the open files, cr_read_files() first closes all the
existing FDs of the current process. This breaks the assumption
underlying the use of fget_light/fput_light in sys_restart(), so
use fget/fput instead.


diff --git a/checkpoint/sys.c b/checkpoint/sys.c
index 7b2670a..ec1609b 100644
--- a/checkpoint/sys.c
+++ b/checkpoint/sys.c
@@ -210,10 +210,9 @@ asmlinkage long sys_restart(int crid, int fd, unsigned long flags)
  {
  	struct cr_ctx *ctx;
  	struct file *file;
-	int fput_needed;
  	int ret;

-	file = fget_light(fd, &fput_needed);
+	file = fget(fd);
  	if (!file)
  		return -EBADF;

@@ -223,14 +222,14 @@ asmlinkage long sys_restart(int crid, int fd, unsigned long flags)

  	ctx = cr_ctx_alloc(crid, file, flags | CR_CTX_RSTR);
  	if (!ctx) {
-		fput_light(file, fput_needed);
+		fput(file);
  		return -ENOMEM;
  	}

  	ret = do_restart(ctx);

  	cr_ctx_free(ctx);
-	fput_light(file, fput_needed);
+	fput(file);

  	return ret;
  }
