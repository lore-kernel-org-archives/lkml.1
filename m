Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXKQSPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXKQSPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbXKQSPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:15:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:51708 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXKQSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=olFywh3HLK2zweEsgFK0AHoVMfUKJAyKPRa+w1C3pFvL8MdVp+gVNN/IffZNJ2Fk9wQKY0WU9ISGzq55x1Y4HXFacsW3EkyxDGxh3lZdx/Yl8JtKqQGTZhVGzsfGB+NiZpTDI44lQ3HQM99cguVLJf3PV3gEkqF7bRWUryyjlgw=
Message-ID: <863e9df20711171015r48c45661sf27661ddc3a19274@mail.gmail.com>
Date: Sat, 17 Nov 2007 23:45:29 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195260891.8520.104.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com> <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150516w6ee27172j159deaad06d0e5e8@mail.gmail.com>
	 <1195161370.3804.96.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711160950u5a84ddb9wff683d6b405ec94e@mail.gmail.com>
	 <1195260891.8520.104.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 6:24 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> It'd be helpful to see others (especially kprobes maintainers) chime in
> on this.  In particular, if doing kmalloc/kfree of GFP_ATOMIC data at
> kretprobe-hit time is OK, as in Abhishek's approach, then we could also
> use GFP_ATOMIC (or at least GFP_NOWAIT) allocations to make up the
> difference when we run low on kretprobe_instances.

It might cause a problem with return instances having a large value of
entry_info_sz, being allocated in the page frame reclamation code
path.

> > > entry_info is, by default, a zero-length array, which adds nothing to
> > > the size of a uretprobe_instance -- at least on the 3 architectures I've
> > > tested on (i386, x86_64, powerpc).
> >
> > Strange, because from what I could gather, the data pouch patch had
> > the following in the kretprobe registration routine:
> >
> >
> > for (i = 0; i < rp->maxactive; i++) {
> > -             inst = kmalloc(sizeof(struct kretprobe_instance), GFP_KERNEL);
> > +             inst = kmalloc((sizeof(struct kretprobe_instance)
> > +                             + rp->entry_info_sz), GFP_KERNEL);
> >
> >
> > rp->entry_info_sz is presumably the size of the private data structure
> > of the registering module.
>
> ... which is zero for kretprobes that don't use the data pouch.
>
> > This is the bloat I was referring to. But
> > this difference should've showed up in your tests...?
>
> What bloat?  On my 32-bit system, the pouch to hold struct prof_data in
> your test_module example would be 20 bytes.  (For comparison,
> sizeof(struct kretprobe_instance) = 28, btw.)  Except for functions like
> schedule(), where a lot of tasks can be sleeping at the same time, an
> rp->maxactive value of 5 or 10 is typically plenty.  That's 100-200
> bytes of "bloat" spent at registration time (GFP_KERNEL), at least some
> of which will be saved at probe-hit time (GFP_ATOMIC).  (And if somebody
> says, "I always use a much higher value of rp->maxactive," then he/she's
> probably not really worried about bloat.)

Ok. Will make the necessary transition to registration time allocation
of private data.

> Yes.  If the pouch idea is too weird, then the data pointer is a good
> compromise.
>
> With the above reservations, your enclosed patch looks OK.
>
> You should provide a patch #2 that updates Documentation/kprobes.txt.
> Maybe that will yield a little more review from other folks.

Will incorporate changes to kprobes.txt as well.

- Abhishek
