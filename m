Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYIABRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYIABRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 21:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYIABRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 21:17:12 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56750 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYIABRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 21:17:11 -0400
Date: Sun, 31 Aug 2008 21:17:09 -0400
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Ingo Oeser <ioe-lkml@rameria.de>, neilb@suse.de
Subject: Re: [PATCH] sunrpc - fixup userspace buffer possible overrun v3
Message-ID: <20080901011709.GA19834@fieldses.org>
References: <20080831152549.GD2884@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831152549.GD2884@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 07:25:49PM +0400, Cyrill Gorcunov wrote:
> David Wagner added (among other things) that copy_to_user could be
> probably used here.
> 
> Ingo Oeser suggested to use simple_read_from_buffer() here.
> 
> The conclusion is that proc_do_xprt doesn't check for userside buffer
> size indeed so fix this by using Ingo's suggestion.

Thanks for fixing this!  And apologies for not looking closer when this
first went in....

It looks like we could cut out a little more code while we're there:

> +++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 19:15:57.000000000 +0400
> @@ -60,23 +60,27 @@ static int proc_do_xprt(ctl_table *table
>  			void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
>  	char tmpbuf[256];
> -	int len;
> +	size_t len;
> +	ssize_t ret;
> +
>  	if ((*ppos && !write) || !*lenp) {
>  		*lenp = 0;
>  		return 0;
>  	}
> +
>  	if (write)
>  		return -EINVAL;

The only caller of .proc_handler appears to be
fs/proc/proc_sysctl.c:proc_sys_call_handler(), which checks permissions
before calling us, so we'll never hit this case (since "transports" is
given mode 0444, and root isn't allowed to bypass this).


>  	else {

The previous return makes the "else" redundant.

>  		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
> -		if (!access_ok(VERIFY_WRITE, buffer, len))
> -			return -EFAULT;
> -
> -		if (__copy_to_user(buffer, tmpbuf, len))
> -			return -EFAULT;
> +		ret = simple_read_from_buffer(buffer, *lenp, ppos,
> +						tmpbuf, len);
> +		if (ret >= 0) {
> +			*lenp = ret;
> +			ret = 0;
> +		}

And it looks to me like the proc_sys_call_handler doesn't use *lenp when
ret is nonzero, so this "if" is unnecessary.

> +		return ret;
>  	}
> -	*lenp -= len;
> -	*ppos += len;
> +
>  	return 0;
>  }
>  

That gives the following:

--b.


commit 20d0daba667a355e7c76362633423ab569d2193d
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Sun Aug 31 19:25:49 2008 +0400

    sunrpc - fixup userspace buffer possible overrun v3
    
    Vegard Nossum reported
    ----------------------
    > I noticed that something weird is going on with /proc/sys/sunrpc/transports.
    > This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
    > I "cat" this file, I get the expected output:
    >    $ cat /proc/sys/sunrpc/transports
    >    tcp 1048576
    >    udp 32768
    
    > But I think that it does not check the length of the buffer supplied by
    > userspace to read(). With my original program, I found that the stack was
    > being overwritten by the characters above, even when the length given to
    > read() was just 1.
    
    David Wagner added (among other things) that copy_to_user could be
    probably used here.
    
    Ingo Oeser suggested to use simple_read_from_buffer() here.
    
    The conclusion is that proc_do_xprt doesn't check for userside buffer
    size indeed so fix this by using Ingo's suggestion.
    
    Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
    Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
    CC: Ingo Oeser <ioe-lkml@rameria.de>
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index 0f8c439..5231f7a 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -60,24 +60,14 @@ static int proc_do_xprt(ctl_table *table, int write, struct file *file,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char tmpbuf[256];
-	int len;
+	size_t len;
+
 	if ((*ppos && !write) || !*lenp) {
 		*lenp = 0;
 		return 0;
 	}
-	if (write)
-		return -EINVAL;
-	else {
-		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
-		if (!access_ok(VERIFY_WRITE, buffer, len))
-			return -EFAULT;
-
-		if (__copy_to_user(buffer, tmpbuf, len))
-			return -EFAULT;
-	}
-	*lenp -= len;
-	*ppos += len;
-	return 0;
+	len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
+	return simple_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
 }
 
 static int
