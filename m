Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYAQUgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYAQUgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYAQUgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:36:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYAQUgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:36:41 -0500
Date: Thu, 17 Jan 2008 21:36:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080117203600.GB27778@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117191211.GA12631@alberich.amd.com>
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


* Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:

> For the failed devices I get:
> 
>   sata_sil 0000:00:12.0: version 2.3
>   ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
>   ioremap_nocache: addr c0403000, size 200
>   swapper:1 conflicting cache attribute c0403000-c0404000 uncached<->default
>   ACPI: PCI interrupt for device 0000:00:12.0 disabled

hm, is the problem that the two devices share the same physical page, 
and thus get an overlapping area?

as an intermediate fix, how about following the attribute of the already 
existing mapping, instead of rejecting the ioremap due to the conflict? 
I.e. something like below?

	Ingo

---
 arch/x86/mm/pat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mm/pat.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pat.c
+++ linux-x86.q/arch/x86/mm/pat.c
@@ -174,7 +174,12 @@ int reserve_mattr(u64 start, u64 end, un
 					current->comm, current->pid,
 					start, end,
 					cattr_name(attr), cattr_name(ml->attr));
-				err = -EBUSY;
+				/*
+				 * Force the already existing attribute:
+				 */
+				ma->attr = ml->attr;
+				if (*fattr)
+					*fatt = ml->attr;
 				break;
 			}
 		} else if (ml->start >= end) {
