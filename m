Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbXGQOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbXGQOtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXGQOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:49:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:34557 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXGQOtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:49:45 -0400
Date: Tue, 17 Jul 2007 18:51:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH, RESEND] sys_time: use barrier() instead of smp_rmb()
Message-ID: <20070717145118.GA286@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From the recent 4e44f3497d41db4c3b9051c61410dee8ae4fb49c commit,

>  asmlinkage long sys_time(time_t __user * tloc)
>  {
> -	time_t i;
> -	struct timeval tv;
> +	/*
> +	 * We read xtime.tv_sec atomically - it's updated
> +	 * atomically by update_wall_time(), so no need to
> +	 * even read-lock the xtime seqlock:
> +	 */
> +	time_t i = xtime.tv_sec;
>  
> -	do_gettimeofday(&tv);
> -	i = tv.tv_sec;
> +	smp_rmb(); /* sys_time() results are coherent */

The is no reason to use rmb(), we don't do any LOADs which could be reordered.
What we need is a simple compiler barrier, to prevent the reading of the
"volatile" xtime.tv_sec twice.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/time.c~	2007-06-26 16:28:59.000000000 +0400
+++ t/kernel/time.c	2007-06-26 16:32:09.000000000 +0400
@@ -64,7 +64,7 @@ asmlinkage long sys_time(time_t __user *
 	 */
 	time_t i = xtime.tv_sec;
 
-	smp_rmb(); /* sys_time() results are coherent */
+	barrier(); /* sys_time() results are coherent */
 
 	if (tloc) {
 		if (put_user(i, tloc))


