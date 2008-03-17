Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYCQTfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYCQTfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYCQTe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:34:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42027 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYCQTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:34:58 -0400
Date: Mon, 17 Mar 2008 15:34:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nix <nix@esperi.org.uk>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly (was
	Re: [uml-devel] g_timeout_add)
Message-ID: <20080317193415.GA12234@c2.user-mode-linux.org>
References: <47B34BA0.30006@club-internet.fr> <20080214003853.GA15952@c2.user-mode-linux.org> <47B4BDCD.4080605@club-internet.fr> <20080215160205.GA6082@c2.user-mode-linux.org> <47B5CE40.9000005@club-internet.fr> <20080215184650.GA8810@c2.user-mode-linux.org> <87y78kx640.fsf_-_@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y78kx640.fsf_-_@hades.wkstn.nix>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the same patch with another kluge, which cuts down the
requested sleep by 10% in hopes of getting the actual sleep closer to
what's wanted.

This is unusable in anything resembling mainline, but I'd like to see
how your various systems react to it.  I'm getting very close to the
sleeps I asked for (with slight undersleeping, which is a bug).

       	       	   Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2008-02-18 11:53:51.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/time.c	2008-03-17 15:11:51.000000000 -0400
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
@@ -126,6 +131,8 @@ void idle_sleep(unsigned long long nsecs
 	 */
 	if (nsecs == 0)
 		nsecs = UM_NSEC_PER_SEC / UM_HZ;
+
+	nsecs = nsecs * 9 / 10;
 	ts = ((struct timespec) { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
 				  .tv_nsec	= nsecs % UM_NSEC_PER_SEC });
 
