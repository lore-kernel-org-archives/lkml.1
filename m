Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYIUTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYIUTGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYIUTGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:06:06 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43164 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYIUTGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:06:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18646.39701.819497.337394@harpo.it.uu.se>
Date: Sun, 21 Sep 2008 21:05:57 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [patch] log fatal signals like SIGSEGV
In-Reply-To: <200809201912.40381.thomas.jarosch@intra2net.com>
References: <200809121502.15264.thomas.jarosch@intra2net.com>
	<200809181210.40336.thomas.jarosch@intra2net.com>
	<20080918202010.GA5656@joi>
	<200809201912.40381.thomas.jarosch@intra2net.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Jarosch writes:
 > Hello together,
 > 
 > here's the reworked version of the signal logging patch.
 > Many thanks to Marcin Slusarz for reviewing it. 
 > 
 > The idea is to briefly log "fatal" signals by default, the output
 > should be close to zero during normal system operation.
 > Faulty hardware gets detected much quicker
 > if you see crashing apps in the logs.
 > 
 > The patch applies to 2.6.26 and git HEAD.
 > scripts/checkpatch.pl is happy, too.
 > 
 > I'm off for a vacation, so expect a delay of some days
 > if there should be additional questions or comments.
 > 
 > Hope the new feature is as useful to others as it has been to me.
 > 
 > Enjoy,
 > Thomas
 > 
 > ------------------------------------------------------
 > From: Thomas Jarosch <thomas.jarosch@intra2net.com>
 > 
 > Log signals like SIGSEGV, SIGILL, SIGBUS or SIGFPE to aid tracing
 > of obscure problems. Also logs the sender of the signal.

I believe the approach taken in this patch is broken:

1. The signal logging decision is taken before signal delivery,
   which causes *handled* signals in the above list to be logged.
   So your printk_ratelimit() can be swamped by handled signals
   causing it to not log unhandled fatal signals.

   Applications that handle SEGV/BUS/ILL/FPE aren't that uncommon.

2. Fatal signals are only interesting if they are self-generated.
   Signals sent from other processes or threads are uninteresting,
   if the purpose is to detect program errors or faulty hardware.

3. Similar functionality already exists in the kernel, except
   it correctly runs much later in the signal delivery path.
   Grep for print_fatal_signals and show_unhandled_signals.

   There's also some trace hooks in the signal delivery path
   that look like they could log actual fatal signals.

/Mikael
