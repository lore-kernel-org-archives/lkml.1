Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbXHZRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbXHZRhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXHZRhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:37:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2305 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXHZRhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:37:10 -0400
Subject: Re: [PATCH] Prefix each line of multiline printk(KERN_<level>
	"foo\nbar") with KERN_<level>
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708261028120.31149@anakin>
References: <1187999098.32738.179.camel@localhost>
	 <Pine.LNX.4.64.0708261028120.31149@anakin>
Content-Type: text/plain
Date: Sun, 26 Aug 2007 10:36:30 -0700
Message-Id: <1188149790.18004.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-26 at 10:30 +0200, Geert Uytterhoeven wrote: 
> On Fri, 24 Aug 2007, Joe Perches wrote:
> > Corrected printk calls with multiple output lines which
> > did not correctly preface each line with KERN_<level>
> > Fixed uses of some single lines with too many KERN_<level>
> > --- a/arch/arm/kernel/ecard.c
> > +++ b/arch/arm/kernel/ecard.c
> > @@ -547,7 +547,8 @@ static void ecard_check_lockup(struct irq_desc *desc)
> >  	if (last == jiffies) {
> >  		lockup += 1;
> >  		if (lockup > 1000000) {
> > -			printk(KERN_ERR "\nInterrupt lockup detected - "
> > +			printk(KERN_ERR "\n"
> > +			       KERN_ERR "Interrupt lockup detected - "
> >  			       "disabling all expansion card interrupts\n");
> >  
> >  			desc->chip->mask(IRQ_EXPANSIONCARD);
> 
> What's the purpose of having lines printed with e.g. `KERN_ERR "\n"' only?
> Shouldn't these just be removed?

My preference too.  There could be a separate effort for that.

egrep -r --include=*.[ch] "KERN_[A-Z]*[[:space:]]+\"\\\n" * | wc -l
104

These are either errors or a desire to prettify logs with
vertical whitespace.  I think vertical whitespace doesn't help.

> Usually lines starting with `\n' are continuations, but given some other
> module may call printk() in between, there's no guarantee continuations
> appear on the same line.

printk KERN_<level>s were sometimes bolted on after code was written.

etherfoo_card_init()
{
	printk(KERN_INFO "etherfoo card");
	slot = foo_getslot();
	if (slot < 0) {
		printk("\n" KERN_ERR "etherfoo card slot not found\n");
		return -1;
	}
	printk(" found in slot %d", slot);
	irq = foo_getirq();
	if (irq < 0) {
		printk("\n" KERN_ERR "etherfoo card irq not found\n");
		return -1;
	}
	printk(" with irq %d\n", irq);
}

Sometimes, a KERN_ERR is misplaced, or the "\n" is missing.

	printk(KERN_ERR "\n" msg);
or
	printk(KERN_ERR msg);

To me, the card announcement printk should move to the
end of the card_init routine and just be a single printk.

etherfoo_card_init()
{
	slot = foo_getslot();
	if (slot < 0) {
		printk(KERN_ERR "etherfoo card slot not found\n");
		return -1;
	}
	irq = foo_getirq();
	if (irq < 0) {
		printk(KERN_ERR "etherfoo card irq not found\n");
		return -1;
	}
	printk(KERN_INFO "etherfoo card in slot %d with irq %d\n",
	       slot, irq);
}


