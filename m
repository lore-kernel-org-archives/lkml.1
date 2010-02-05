Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab0BEWCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:02:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933863Ab0BEWCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:02:14 -0500
Date: Fri, 5 Feb 2010 14:01:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Patch] compat ioctl: fix some build warnings
Message-Id: <20100205140150.7f5df97b.akpm@linux-foundation.org>
In-Reply-To: <20100205070921.4179.39579.sendpatchset@localhost.localdomain>
References: <20100205070921.4179.39579.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 02:05:56 -0500
Amerigo Wang <amwang@redhat.com> wrote:

> I got these warnings:
> 
> fs/compat_ioctl.c: In function ___compat_sys_ioctl':
> fs/compat_ioctl.c:534: warning: ___karg' may be used uninitialized in this function
> fs/compat_ioctl.c:533: warning: ___kcmd' may be used uninitialized in this function
> fs/compat_ioctl.c:656: warning: ___ret' may be used uninitialized in this function
> 
> These warnings are harmless, so just shut gcc up.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index c5c45de..2468f80 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -543,6 +543,8 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, void __user *argp)
>  		kcmd = MTIOCGET;
>  		karg = &get;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  	set_fs (KERNEL_DS);
>  	err = sys_ioctl (fd, kcmd, (unsigned long)karg);
> @@ -653,7 +655,7 @@ static int set_raw32_request(struct raw_config_request *req, struct raw32_config
>  static int raw_ioctl(unsigned fd, unsigned cmd,
>  		struct raw32_config_request __user *user_req)
>  {
> -        int ret;
> +        int ret = -EINVAL;
>  
>          switch (cmd) {
>          case RAW_SETBIND:

Unfortunately that adds more code for something which cannot happen at
runtime.

I guess we could do this trick:

--- a/fs/compat_ioctl.c~a
+++ a/fs/compat_ioctl.c
@@ -539,7 +539,7 @@ static int mt_ioctl_trans(unsigned int f
 		kcmd = MTIOCPOS;
 		karg = &pos;
 		break;
-	case MTIOCGET32:
+	default:	/* MTIOCGET32 */
 		kcmd = MTIOCGET;
 		karg = &get;
 		break;
@@ -657,7 +657,7 @@ static int raw_ioctl(unsigned fd, unsign
 
         switch (cmd) {
         case RAW_SETBIND:
-        case RAW_GETBIND: {
+        default: {	/* RAW_GETBIND */
                 struct raw_config_request req;
                 mm_segment_t oldfs = get_fs();
 
_


Which actually reduces code:

akpm:/usr/src/25> size fs/compat_ioctl.o
   text    data     bss     dec     hex filename
   9012    2232    2864   14108    371c fs/compat_ioctl.o

   8968    2232    2848   14048    36e0 fs/compat_ioctl.o

