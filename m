Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZKEHPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZKEHPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZKEHPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:15:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZKEHPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:15:19 -0500
Date: Thu, 5 Nov 2009 08:14:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
       Greg KH <greg@kroah.com>
Subject: Re: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
Message-ID: <20091105071431.GA14055@elte.hu>
References: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com> <alpine.LFD.2.01.0911041551220.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911041551220.31845@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 4 Nov 2009, Luis R. Rodriguez wrote:
> > 
> > Can you please consider reviewing this issue and help determine if 
> > this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.
> > 
> > I am curious if other devices would work by reverting this as well.
> > [ ... ] For details please feel free to check:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=14402
> 
> That same commit was the cause for
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=13940
> 
> and we just increased the rounding to make it go away (see commit 
> 15b812f1). But that was a hack.
> 
> And if that didn't help the ath9k case, then we should just revert 
> entirely.

Agreed - below is the combo 15b812f1 + 5d423ccd revert. (Would be nice 
to get the boot log of the latest post-15b812f1 kernel that Yinghai 
asked for before we revert, in the hope of better understanding the 
problem.)

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d17d482..b322e30 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -617,7 +617,7 @@ __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
  */
 __init void e820_setup_gap(void)
 {
-	unsigned long gapstart, gapsize;
+	unsigned long gapstart, gapsize, round;
 	int found;
 
 	gapstart = 0x10000000;
@@ -634,9 +634,14 @@ __init void e820_setup_gap(void)
 #endif
 
 	/*
-	 * e820_reserve_resources_late protect stolen RAM already
+	 * See how much we want to round up: start off with
+	 * rounding to the next 1MB area.
 	 */
-	pci_mem_start = gapstart;
+	round = 0x100000;
+	while ((gapsize >> 4) > round)
+		round += round;
+	/* Fun with two's complement */
+	pci_mem_start = (gapstart + round) & -round;
 
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
@@ -1378,8 +1383,8 @@ static unsigned long ram_alignment(resource_size_t pos)
 	if (mb < 16)
 		return 1024*1024;
 
-	/* To 64MB for anything above that */
-	return 64*1024*1024;
+	/* To 32MB for anything above that */
+	return 32*1024*1024;
 }
 
 #define MAX_RESOURCE_SIZE ((resource_size_t)-1)
