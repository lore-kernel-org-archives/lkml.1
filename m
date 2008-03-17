Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYCQRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYCQRER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYCQREF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:04:05 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:40638 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYCQRED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:04:03 -0400
Date: Mon, 17 Mar 2008 13:03:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nix <nix@esperi.org.uk>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly (was
	Re: [uml-devel] g_timeout_add)
Message-ID: <20080317170328.GB9536@c2.user-mode-linux.org>
References: <47B34BA0.30006@club-internet.fr> <20080214003853.GA15952@c2.user-mode-linux.org> <47B4BDCD.4080605@club-internet.fr> <20080215160205.GA6082@c2.user-mode-linux.org> <47B5CE40.9000005@club-internet.fr> <20080215184650.GA8810@c2.user-mode-linux.org> <87y78kx640.fsf_-_@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y78kx640.fsf_-_@hades.wkstn.nix>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 11:01:35PM +0000, Nix wrote:
> bash-3.2# ./select-sleep 10
> Slept for 13 seconds.

See what kind of difference the patch below makes - it reduces the 30%
oversleeping down to 10% for me.  That's still way too much, but it's
better.

The problem being fixed here is that setitimer consistently returns a
remaining time greater than what was originally requested, by ~20%:

1205773032.413780 setitimer(ITIMER_VIRTUAL, {it_interval={0, 10000}, it_value={0, 10000}}, NULL) = 0
1205773032.413814 setitimer(ITIMER_VIRTUAL, {it_interval={0, 0},
it_value={0, 0}}, {it_interval={0, 10998}, it_value={0, 11998}}) = 0

This is setting a 100 HZ timer, immediately followed by a cancellation
which also requests the amount left on the timer.  The interval is
rounded up by 10%, and the first tick by 20%.

	       	       	    Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2008-02-18 11:53:51.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/time.c	2008-03-17 12:55:41.000000000 -0400
@@ -58,12 +58,17 @@ static inline long long timeval_to_ns(co
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
+	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
-	return timeval_to_ns(&time.it_value);
+	remain = timeval_to_ns(&time.it_value);
+	if (remain > max)
+		remain = max;
+
+	return remain;
 }
 
 long long os_nsecs(void)
