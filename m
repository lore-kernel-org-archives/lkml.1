Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYA1PmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYA1PmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYA1PmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:42:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbYA1PmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:42:04 -0500
Date: Mon, 28 Jan 2008 16:41:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 00 of 11] x86: separate pmd lifetime from pgd
Message-ID: <20080128154140.GA17017@elte.hu>
References: <patchbomb.1201296189@localhost> <20080128151753.GA14451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128151753.GA14451@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, i tried this, and got an early crash:
> 
> [   29.389844] VFS: Mounted root (ext3 filesystem) readonly.
> [   29.389872] debug: unmapping init memory c0b03000..c0b6f000
> [   29.440139] PM: Adding info for No Bus:vcs1
> [   29.463676] khelper used greatest stack depth: 2404 bytes left
> [   29.467238] PM: Adding info for No Bus:vcsa1
> [   29.541785] PANIC: double fault, gdt at c1d16000 [255 bytes]
> [   29.541785] double fault, tss at c1d19100
> [   29.541785] eip = c011fa95, esp = c3bf6000
> [   29.541785] eax = c3bf6010, ebx = c0b6fc08, ecx = 0000007b, edx = 00000000
> [   29.541785] esi = f76a7df4, edi = c011fa90
> 
> i think it's one of your patches :) Bisecting it down to the right one 
> now. Config attached.

and after a session of bisection, the winner patch is:

  Subject: x86: unify PAE/non-PAE pgd_ctor

which is a tad unexpected, given the relatively harmless nature of the 
patch. (but then again, nothing is really harmless in PAE land.)

btw., this is not fair i think: your patch was apparently caught by the 
new debugging helper that tells about itself here:

> [   29.389872] debug: unmapping init memory c0b03000..c0b6f000

note the close proximity of c0b6f000 and ebx = c0b6fc08. [ I regularly 
come up with such nasty tricks and debugging helpers like that to catch 
bad patches off-guard. You have been warned! ;-) ]

	Ingo
