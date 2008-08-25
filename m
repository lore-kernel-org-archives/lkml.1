Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYHYVtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYHYVtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYHYVtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:49:25 -0400
Received: from flusers.ccur.com ([12.192.68.2]:41199 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752028AbYHYVtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:49:24 -0400
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 17:49:22 EDT
Date: Mon, 25 Aug 2008 17:15:33 -0400
From: Joe Korty <joe.korty@ccur.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lockstat - fix numerical output rounding error
Message-ID: <20080825211533.GA27943@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix rounding error in /proc/lock_stat numerical output.

On occasion the two digit fractional part contains the three
digit value '100'.  This is due to a bug in the rounding algorithm
which pushes values in the range '95..99' to '100' rather than
to '00' + an increment to the integer part.  For example,

	- 123456.100      old display
	+ 123457.00	  new display

Index: 2.6.26/kernel/lockdep_proc.c
===================================================================
--- 2.6.26.orig/kernel/lockdep_proc.c	2008-07-13 17:51:29.000000000 -0400
+++ 2.6.26/kernel/lockdep_proc.c	2008-08-25 16:58:04.000000000 -0400
@@ -406,8 +406,9 @@
 {
 	unsigned long rem;
 
+	nr += 5; /* for display rounding */
 	rem = do_div(nr, 1000); /* XXX: do_div_signed */
-	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, ((int)rem+5)/10);
+	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, (int)rem/10);
 }
 
 static void seq_time(struct seq_file *m, s64 time)
