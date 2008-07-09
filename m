Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYGIUen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYGIUen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYGIUef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:34:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYGIUee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:34:34 -0400
Date: Wed, 9 Jul 2008 22:34:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] tip/x86_64: fix e820 merge issue which broke
	max_pfn_mapped
Message-ID: <20080709203419.GA23790@elte.hu>
References: <20080708230837.GD1678@linux-os.sc.intel.com> <86802c440807081759i3baafa9bj7e8ff544a1a78fb9@mail.gmail.com> <86802c440807081856y17eb1f1cs5647b2c2a765f429@mail.gmail.com> <20080709175621.GG1678@linux-os.sc.intel.com> <86802c440807091105g1dd8f8a0sa8220a1bfc65a79@mail.gmail.com> <4874FF58.5030800@goop.org> <20080709184405.GH1678@linux-os.sc.intel.com> <48750B87.70405@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48750B87.70405@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>>> level1_fixmap_pgt" be a problem in itself?  It seems sound to me, 
>>> but
>>>     
>>
>> Yep. Reverting it made my system with 2GB memory boot fine again.
>
> Great.  Ingo, would you do the honours of shooting that patch?

done, i've applied the revert below.

	Ingo

----------->
commit 8e48d49043b716d2331facba9ecf0b34936ee8ea
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 22:32:33 2008 +0200

    Revert "x86_64: there's no need to preallocate level1_fixmap_pgt"
    
    This reverts commit 033786969d1d1b5af12a32a19d3a760314d05329.
    
    Suresh Siddha reported that this broke booting on his 2GB testbox.
    
    Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2240f82..db3280a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -362,6 +362,12 @@ NEXT_PAGE(level3_kernel_pgt)
 	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
 
 NEXT_PAGE(level2_fixmap_pgt)
+	.fill	506,8,0
+	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
+	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
+	.fill	5,8,0
+
+NEXT_PAGE(level1_fixmap_pgt)
 	.fill	512,8,0
 
 NEXT_PAGE(level2_ident_pgt)
