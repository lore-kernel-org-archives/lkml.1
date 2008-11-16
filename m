Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYKPVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYKPVA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYKPVAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:00:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:48263 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbYKPVAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:00:18 -0500
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, travis@sgi.com
In-Reply-To: <20081113131850.d94fb229.akpm@linux-foundation.org>
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>
	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>
	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	 <20081110094033.GL22392@elte.hu>
	 <20081110015511.453a801e.akpm@linux-foundation.org>
	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>
	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>
	 <491C8B38.9060901@kernel.org>
	 <20081113131850.d94fb229.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 07:58:57 +1100
Message-Id: <1226869137.7178.175.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Other architectures want (or have) sparse interrupts.  Are those guys
> paying attention here?
> 
> I don't have a clue what all this does.  I hope those who will work on
> this code are sufficiently familiar with it all to be able to maintain
> it when there are close to zero comments in some of our most tricky and
> problem-prone code.

Indeed, I'm a bit scared by the patch as it is ...

On powerpc, we have a nice an simple virtual irq layer that also
probably better fits the need of architecture that can have multiple
PICs with different number space cascaded in various ways in a single
machine too.

We provide a basic construct that defines an HW IRQ domain (we call it
irq_host, it can have a 1:1 relationship to a HW irq_chip but not
always), and when HW IRQs are discovered and made available to linux,
they are "mapped" to virtual irq numbers by mapping them to a tuple
(irq_hose, hw_number).

The HW numbering can be arbitrarily anything for that controller
unrelated to the "linux" virtual number, so all the problems of making
IRQ 0 invalid and reserving 1...15 for legacy 8259 etc... are taken care
of.

For fast mapping of HW->Linux numbers, we provide various schemes that a
given IRQ host implementation can choose (from no translation, some HW
PICs or hypervisor can be directly given the linux number and pass it
back to us) to linear mapping to a lockless radix tree for large sparse
irq domains.

At this stage, I don't feel like changing to this sparse_irq which I
haven't fully understood, is complicated, and doesn't seem to provide
the features I need anyway.

The only thing that I see possibly of interest is getting rid of the
irq_desc array itself, toward something more dynamically resizeable, in
which case our powerpc remapping scheme could probably also benefit by
also getting rid in a similar way of our equivalent array used for
mapping the virq's to host,hw_number tuples.

The irq_desc per-cpu also seem to be an interesting idea.

In any case, the patch is too big and unless I missed something, totally
under-documented in what it does, why it does it, how it does it, etc...
with a bit more of that, I might take more time to look closely and find
out that indeed it's something I can make use of, maybe with a few
tweaks.

Cheers,
Ben.

