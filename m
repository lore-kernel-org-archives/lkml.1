Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYAQVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYAQVNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYAQVNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:13:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYAQVNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:13:41 -0500
Date: Thu, 17 Jan 2008 22:13:08 +0100
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
Message-ID: <20080117211308.GA7858@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117210301.GC12631@alberich.amd.com>
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

> Yes.
> 
> Meanwhile I have figured out that it is some ACPI stuff that maps the 
> page cached. I've changed the ioremap's in drivers/acpi/osl.c to 
> ioremap_nocache. See attached patch.
> 
> Now the machine boots without conflicts.

ah, nice!

but in general we must be robust enough in this case and just degrade 
any overlapping page to UC (and emit a warning perhaps) - instead of 
failing the ioremap and thus failing the driver (and the bootup).

Does my third patch (which falls back to UC in case of attribute 
conflicts, also attached below) instead of your ioremap_nocache() patch 
solve your bootup problem too?

while ACPI should not hurt too much from using UC mappings, we should 
still solve this intelligently and only use UC when needed. (Sane system 
makers with a sane layout of IO areas and BIOS areas should not be 
punished with UC overhead.)

> > as an intermediate fix, how about following the attribute of the 
> > already existing mapping, instead of rejecting the ioremap due to 
> > the conflict? I.e. something like below?
> 
> I guess it is not a good idea to use an existing cachable attribute if 
> the IO-region is non-prefetchable. And in this example there are 3 
> devices which are potentially affected:
> 
>   00:12.0 IDE interface: ATI Technologies Inc 4379 Serial ATA Controller (rev 80) (
>      ...
>         Memory at c0403000 (32-bit, non-prefetchable) [size=512]
>      ...
> 
>   00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 82)
>      ...
>           Memory at c0403400 (32-bit, non-prefetchable) [size=1K]
>      ...
> 
>   00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400 AC'97 Audio Controller (rev 80)
>      ...
>           Memory at c0403800 (32-bit, non-prefetchable) [size=256]
>      ...
> 
> BTW, is there a need for osl.c to map all regions as cached?

no, there should be no such need. There can be "mapping leaks", in that 
the mapped object is not unmapped. There's detection code in today's 
x86.git that should report something like this if it occurs:

  Debug warning: early ioremap leak of 1 areas detected.
  please boot with early_ioremap_debug and report the dmesg.
  ------------[ cut here ]------------
  WARNING: at arch/x86/mm/ioremap_32.c:346 ()

but i have not seen this message in your boot log. Could you boot with 
early_ioremap_debug and send us the dmesg - i'm curious which ACPI 
tables are actively mapped while those devices are initialized.

	Ingo

-------------->
Subject: x86: patches/pat-conflict-fixup.patch
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
+				 * Force UC on a conflict:
+				 */
+				ma->attr = _PAGE_UC;
+				if (*fattr)
+					*fattr = _PAGE_UC;
 				break;
 			}
 		} else if (ml->start >= end) {
