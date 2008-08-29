Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYH2GqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYH2GqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYH2GqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:46:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYH2Gp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:45:59 -0400
Date: Fri, 29 Aug 2008 08:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
	corruption
Message-ID: <20080829064540.GA26619@elte.hu>
References: <48B701FB.2020905@goop.org> <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com>
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


* Rafał Miłecki <zajec5@gmail.com> wrote:

> 2008/8/28 Jeremy Fitzhardinge <jeremy@goop.org>:
> > Some BIOSes have been observed to corrupt memory in the low 64k.  This
> > patch does two things:
> >  - Reserves all memory which does not have to be in that area, to
> >   prevent it from being used as general memory by the kernel.  Things
> >   like the SMP trampoline are still in the memory, however.
> >  - Clears the reserved memory so we can observe changes to it.
> >  - Adds a function check_for_bios_corruption() which checks and reports on
> >   memory becoming unexpectedly non-zero.  Currently it's called in the
> >   x86 fault handler, and the powermanagement debug output.
> >
> > RFC: What other places should we check for corruption in?
> >
> > [ Alan, Rafał: could you check you see:
> >   1: corruption messages
> >   2: no crashes
> >  Thanks -J
> > ]
> 
> I was trying my best to crash system with this patch applied and failed :)
> 
> Works great.
> 
> Just wonder if I should expect any printk from
> check_for_bios_corruption? I do not see any:
> 
> zajec@sony:~> dmesg | grep -i corr
> scanning 2 areas for BIOS corruption

that's _very_ weird.

maybe the BIOS expects _zeroes_ somewhere? Do you suddenly see crashes 
if you change this line in Jeremy's patch:

+               memset(__va(addr), 0, size);

to something like:

+               memset(__va(addr), 0x55, size);

If this does not tickle any messages either, then maybe the problem is 
in the identity of the entities we allocate in the first 64K. Is there a 
list of allocations that go there when Jeremy's patch is not applied?

but ... i think with an earlier patch you saw corruption, right? 
Far-fetched idea: maybe it's some CPU erratum during suspend/resume that 
corrupts pagetables if the pagetables are allocated in the first 64K of 
RAM? In that case we should use a bootmem allocation for pagetables that 
give a minimum address of 64K.

	Ingo
