Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXKBBW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXKBBW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXKBBWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:22:20 -0400
Received: from gw.goop.org ([64.81.55.164]:55417 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbXKBBWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:22:19 -0400
Message-ID: <472A7B95.2030001@goop.org>
Date: Thu, 01 Nov 2007 18:21:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, lguest@ozlabs.org,
       akpm@linux-foundation.org, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, ak@suse.de,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, anthony@codemonkey.ws,
       mingo@elte.hu, Glauber de Oliveira Costa <gcosta@redhat.com>,
       virtualization@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [Lguest] [PATCH 3/16] read/write_crX, clts and wbinvd for	64-bit
 paravirt
References: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>	<472A0FBF.6040907@goop.org> <1193936113.29447.56.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1193936113.29447.56.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I understood it as reordering was permitted, but no re-ordering across
> another volatile load, store, or asm was permitted.

It doesn't say that, so I wouldn't assume it.  Certainly we had problems
with the pda code; until I added the _proxy_pda dependency variable, the
only fix Andi could find was adding both "volatile" and a memory clobber.

>   And of course, as
> long as input and output constraints are written properly, the
> re-ordering should not be vulnerable to pathological movement causing
> the code to malfunction.
>   

Yes.  I think constraints are the only way to control ordering (even if
it's as heavy-handed as a memory clobber).  It would be nice if gcc had
a constraint which was only used for ordering, and never generated a
reference.  Then you could make up pseudo-variables in order to express
dependencies without having the risk that the compiler would generate
references.

> It seems that CPU state side effects which can't be expressed in C need
> special care - FPU is certainly one example.
>   

Not an immediate problem, fortunately.

> Also, memory clobber on a volatile asm should stop invalid movement
> across TLB flushes and other problems areas.

Yes.  Any asm which has global effects on how addresses are interpreted
(like tlbflush, reloading the pagetable base, changing modes, etc) needs
to have a memory clobber.

>   Even memory fences should
> have memory clobber in order to stop movement of loads and stores across
> the fence by the compiler.
>   

Pretty sure they do.  A normal compiler barrier is *just* a memory clobber.

    J
