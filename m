Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYKDUof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYKDUof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYKDUo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:44:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYKDUo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:44:27 -0500
Date: Tue, 4 Nov 2008 21:44:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104204400.GC10825@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225822006.21441.1282961299@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Tue, 4 Nov 2008 18:05:01 +0100, "Andi Kleen" <andi@firstfloor.org>
> said:
> > > not taking into account the cost of cs reading (which I
> > > don't suspect to be that expensive apart from writting,
> > 
> > GDT accesses have an implied LOCK prefix. Especially
> > on some older CPUs that could be slow.
> > 
> > I don't know if it's a problem or not but it would need
> > some careful benchmarking on different systems to make sure interrupt 
> > latencies are not impacted.

That's not a real issue on anything produced in this decade as we have 
had per CPU GDTs in Linux for about a decade as well.

It's only an issue on ancient CPUs that export all their LOCKed cycles 
to the bus. Pentium and older or so. The PPro got it right already.

What matters is what i said before: the actual raw cycle count before 
and after the patch, on the two main classes of CPUs, and the amount 
of icache we can save.

> That's good to know. I assume this LOCKed bus cycle only occurs if 
> the (hidden) segment information is not cached in some way? How many 
> segments are typically cached? In particular, does it optimize 
> switching between two segments?
> 
> > Another reason I would be also careful with this patch is that it 
> > will likely trigger slow paths in JITs like qemu/vmware/etc.
> 
> Software can be fixed ;).

Yes, and things like vmware were never a reason to hinder Linux.

> > Also code segment switching is likely not something that current 
> > and future micro architectures will spend a lot of time 
> > optimizing.
> >
> > I'm not sure that risk is worth the small improvement in code 
> > size.
> 
> I think it is worth exploring a bit more. I feel it should be a 
> neutral change worst-case performance-wise, but I really think the 
> new code is more readable/understandable.

It's all measurable, so the vague "risk" mentioned above can be 
dispelled via hard numbers.

> > An alternative BTW to having all the stubs in the executable would 
> > be to just dynamically generate them when the interrupt is set up. 
> > Then you would only have the stubs around for the interrupts which 
> > are actually used.
> 
> I was trying to simplify things, not make it even less transparent 
> ;).

yep, the complexity of dynamic stubs is the last thing we need here.

And as hpa's comments point it out, compressing the rather stupid irq 
stubs might be a third option that looks promising as well.

	Ingo
