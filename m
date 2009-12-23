Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZLWXBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZLWXBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 18:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZLWXBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 18:01:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZLWXBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:01:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression, 2.6.32->33-rc1] Commit 9f15226e755 breaks resume on Toshiba Portege R500
Date: Thu, 24 Dec 2009 00:01:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200912230158.42161.rjw@sisk.pl>
In-Reply-To: <200912230158.42161.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912240001.26764.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 December 2009, Rafael J. Wysocki wrote:
> Hi Andreas,
> 
> Unfortunately your commit 9f15226e75583547aaf542c6be4bdac1060dd425
> (x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online
> cycle) breaks resume from suspend to RAM on my Toshiba Portege R500 (an attempt
> to resume causes a hard hang with 100% CPU load, reproducible 100% of the
> time).  This has been found by bisection and confirmed by reverting this commit
> on top of 2.6.33-rc1.
> 
> Strangely enough, the box doesn't even have an AMD CPU, there's an Intel Core2
> Duo in it, so I suspect some missing check somewhere.
> 
> If I have the time, I'll look deeper into this tomorrow.

I think commit 9f15226e755 is wrong, since it causes microcode_init_cpu()
to be called during resume even for CPUs for which there's no microcode to
apply.  That, in turn, results in executing request_firmware() (on Intel CPUs
at least) which doesn't work at this stage of resume (we have device interrupts
disabled, I/O devices are still suspended and so on).

If I'm not mistaken, the "if (uci->valid)" logic means "if that CPU is known
to us" , so before commit 9f15226e755 microcode_resume_cpu() was called for
all CPUs already in the system during suspend, which was the right thing to do.
The commit changed it so that the CPUs without microcode to apply are now
treated as "unknown", which is not quite right.

The problem this commit attempted to solve has to be handled differently.

Linus, please revert commit 9f15226e755.

Rafael
