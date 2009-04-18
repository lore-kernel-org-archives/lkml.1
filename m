Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbZDRTPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbZDRTPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZDRTPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:15:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39512 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbZDRTP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:15:29 -0400
Date: Sat, 18 Apr 2009 21:14:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090418191425.GA19565@elte.hu>
References: <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <20090418092216.GP7678@elte.hu> <alpine.LFD.2.00.0904181151230.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904181151230.4042@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 18 Apr 2009, Ingo Molnar wrote:
> > 
> > Am i missing something?
> 
> We also try to avoid random motherboard resources etc that aren't 
> reserved or documented by the BIOS. It's better to go into big 
> holes. It's also better to try to keep as close to the old 
> (tested) behavior.

Yeah - i'm not suggesting any change in behavior, nor am i 
suggesting any risky behavior. The current code seems to work quite 
well.

I'm just suggesting (maybe foolishly) that instead of having any 
gap-rounding logic at all, add artificial entries to the e820 map to 
'extend' and round up any odd ending entries.

I.e. explicitly manage all the 'hole' space to be nicely rounded and 
to be far away from any T-Seg or other sekrit motherboard resource 
danger area.

We'd do this after PCI static allocations (so we dont ever stomp on 
real, known resources) but before PCI dynamic allocations.

The e820 printout would look literally like this:

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)       0.639 MB RAM
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)     0.001 MB
                                                [ hole ]       0.250 MB
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)     0.125 MB
 BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)    1004.5   MB RAM
 BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)     0.7   MB
 BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)      16.3   MB RAM
 BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)     0.3   MB
 BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)       0.15  MB RAM
 BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data     0.07  MB
 BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)       0.004 MB RAM
 BIOS-e820: 000000003ff00000 - 0000000040000000 (guard)        1.0   MB
                                               	[ hole ]    3072.0   MB

The '(guard)' entry at the end i added above.

This way we intentionally create a 'free physical address space' 
hole space that is the same as the rounding logic. No rounding 
needed anywhere - as all the remaining address space is well-rounded 
already. Plus we'd also _see_ all our rounding logic by looking at 
the '(guard)' entries.

Or maybe there's some aspect of gap-rounding that cannot be 
expressed in such a static way?

	Ingo
