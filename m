Return-Path: <linux-kernel-owner+w=401wt.eu-S1423133AbXBHJ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423133AbXBHJ4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423169AbXBHJ4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:56:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423133AbXBHJ4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:56:52 -0500
Date: Thu, 8 Feb 2007 10:56:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lukasz Trabinski <lukasz@wsisiz.edu.pl>, linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
Message-ID: <20070208095612.GA9977@elte.hu>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl> <20070207204745.a2640c43.akpm@linux-foundation.org> <20070208080644.GA14579@elte.hu> <200702081016.21124.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702081016.21124.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4399]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> This reminds me the current problem in close_files()
>  code, where we trigger soft lockup quite regularly.
> 
> Is there any chance/interest we can solve the issue Andrew had with 
> this patch ?
> 
> http://lkml.org/lkml/2006/5/2/273

yes - the -rt patch included the patch below for more than 2 years. 
(note that this one is even more finegrained)

	Ingo

Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c
+++ linux/kernel/exit.c
@@ -431,8 +433,10 @@ static void close_files(struct files_str
 		while (set) {
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
-				if (file)
+				if (file) {
 					filp_close(file, files);
+					cond_resched();
+				}
 			}
 			i++;
 			set >>= 1;
