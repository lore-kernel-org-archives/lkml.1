Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYCHIXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYCHIXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 03:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYCHIXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 03:23:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34379 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYCHIXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 03:23:15 -0500
Date: Sat, 8 Mar 2008 09:22:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frank Sorenson <frank@tuxrocks.com>
Cc: kay.sievers@vrfy.org, Matt_Domsch@dell.com,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] revert "dcdbas: add DMI-based module autloading"
Message-ID: <20080308082243.GA18123@elte.hu>
References: <47D02940.1030707@tuxrocks.com> <20080306184954.GA15492@elte.hu> <47D1971A.7070500@tuxrocks.com> <47D23B7E.3020505@tuxrocks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D23B7E.3020505@tuxrocks.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Sorenson <frank@tuxrocks.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Frank Sorenson wrote:
> > I did some additional debugging, and I believe you're correct about it
> > being specific to my system.  The system seems to run fine until some
> > time during the boot.  I booted with "init=/bin/sh" (that's how the
> > system stayed up for 9 minutes), then it died when I tried starting
> > things up.  I've further narrowed the OOM down to udev (though it's not
> > entirely udev's fault, since 2.6.24 runs fine).
> > 
> > I ran your debug info tool before killing the box by running
> > /sbin/start_udev.  The output of the tool is at
> > http://tuxrocks.com/tmp/cfs-debug-info-2008.03.06-14.11.24
> > 
> > Something is apparently happening between 2.6.24 and 2.6.25-rc[34] which
> > causes udev (or something it calls) to behave very badly.
> 
> Found it.  The culprit is 8f47f0b688bba7642dac4e979896e4692177670b
>     dcdbas: add DMI-based module autloading
> 
>     DMI autoload dcdbas on all Dell systems.
> 
>     This looks for BIOS Vendor or System Vendor == Dell, so this should
>     work for systems both Dell-branded and those Dell builds but brands
>     for others.  It causes udev to load the dcdbas module at startup,
>     which is used by tools called by HAL for wireless control and
>     backlight control, among other uses.
> 
> What actually happens is that when udev loads the dcdbas module at 
> startup, modprobe apparently calls "modprobe dcdbas" itself, repeating 
> until the system runs out of resources (in this case, it OOMs).

nice work! I've attached the revert below against latest -git - just in 
case no-one can think of an obvious fix to this bug.

	Ingo

--------------------->
Subject: revert "dcdbas: add DMI-based module autloading"
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Mar 08 09:09:16 CET 2008

Frank Sorenson reported that 2.6.25-rc OOMs on his box and
tracked it down to commit 8f47f0b688bba7642dac4e979896e4692177670b,
"dcdbas: add DMI-based module autloading". Frank says:

> What actually happens is that when udev loads the dcdbas module at
> startup, modprobe apparently calls "modprobe dcdbas" itself, repeating
> until the system runs out of resources (in this case, it OOMs).

revert the commit.

Bisected-by: Frank Sorenson <frank@tuxrocks.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/firmware/dcdbas.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/firmware/dcdbas.c
===================================================================
--- linux.orig/drivers/firmware/dcdbas.c
+++ linux/drivers/firmware/dcdbas.c
@@ -658,5 +658,4 @@ MODULE_DESCRIPTION(DRIVER_DESCRIPTION " 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_AUTHOR("Dell Inc.");
 MODULE_LICENSE("GPL");
-/* Any System or BIOS claiming to be by Dell */
-MODULE_ALIAS("dmi:*:[bs]vnD[Ee][Ll][Ll]*:*");
+
