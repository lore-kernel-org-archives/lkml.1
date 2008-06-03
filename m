Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYFCXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYFCXEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYFCXD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:03:59 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:6716 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYFCXD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:03:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked list
Date: Tue, 3 Jun 2008 17:03:47 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.357694359@ldl.fc.hp.com> <4845A217.3030701@keyaccess.nl>
In-Reply-To: <4845A217.3030701@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031703.48648.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 01:57:11 pm Rene Herman wrote:
> On 31-05-08 00:49, Bjorn Helgaas wrote:

> Just for the record -- due to an ISAPnP bug, ISAPnP doesn't actually at 
> the moment deal with independents following dependents at all (it does 
> not reset the option to independent upon seeing an _STAG_ENDDEP tag) and 
> the rework actually fixes this bug. The ISAPnP spec does recommend that 
> independents precede dependents, but does not guarantee.
> 
> Might be good to mention this in the log though? In the unlikely event 
> that some piece of ISAPnP hardware out there actually changes behaviour 
> (to "fixed" ...) that might be a hint in looking at it.

I split that bugfix into a separate patch; thanks for
pointing this out.

> > +#define PNP_OPTION_DEPENDENT		0x80000000
> > +#define PNP_OPTION_SET_MASK		0xff
> > +#define PNP_OPTION_SET_SHIFT		16
> > +#define PNP_OPTION_PRIORITY_MASK	0xffff
> > +#define PNP_OPTION_PRIORITY_SHIFT	0
> 
> I checked, and ISAPnP and PnPBIOS definitely limit the priority to 8-bit 
> and ACPI seems to as well meaning the (only) reason for using 16 would 
> be the RES_PRIORITY_INVALID value.
> 
> I have on the other hand not encountered text limiting the number of 
> dependents sets to 255 nor do I believe the old code enforced this?
> 
> Yes, I suppose this is exceedingly unlikely to be a practical issue.

That's definitely backwards.  I reversed the sizes, so we'll have
8 bits for the priority byte (including compatibility/performance/
robustness) and 16 bits for the dependent set number.  Actually,
I made the priority field 12 bits so we'd have space to keep
PNP_RES_PRIORITY_INVALID as a truly out-of-band value.

> >  static void pnp_print_option(pnp_info_buffer_t * buffer, char *space,
> > -			     struct pnp_option *option, int dep)
> > +			     struct pnp_option *option)
> 
> > +	switch (option->type) {
> > +	case IORESOURCE_IO:
> > +		pnp_print_port(buffer, space, &option->u.port);
> > +		break;
> > +	case IORESOURCE_MEM:
> > +		pnp_print_mem(buffer, space, &option->u.mem);
> > +		break;
> > +	case IORESOURCE_IRQ:
> > +		pnp_print_irq(buffer, space, &option->u.irq);
> > +		break;
> 
> I believe it would be good if pnp_print_irq() now also displayed 
> "(optional)" if the flag is set.

I agree; I added this to the patch that added IORESOURCE_IRQ_OPTIONAL.

> > @@ -659,26 +654,24 @@ static int __init isapnp_create_device(s
> >  				priority = 0x100 | tmp[0];
> >  				size = 0;
> >  			}
> > -			option = pnp_register_dependent_option(dev, priority);
> > -			if (!option)
> > -				return 1;
> > +			option_flags = pnp_dependent_option(dev, priority);
> >  			break;
> >  		case _STAG_ENDDEP:
> >  			if (size != 0)
> >  				goto __skip;
> > -			priority = 0;
> > -			dev_dbg(&dev->dev, "end dependent options\n");
> > +			option_flags = pnp_independent_option();
> 
> (here is the bugfix)

Yep, I split into a separate patch as mentioned above.

> > -static int pnp_assign_resources(struct pnp_dev *dev, int depnum)
> > +static int pnp_assign_resources(struct pnp_dev *dev, int set)
> >  {
> > ...
> Mmm. Previously when it failed halfway through it re-cleared the 
> resources (at label fail). Does it want to do so now also?

Yes, I suppose so.  I can't remember why I removed that, but it
shouldn't hurt, so I added it back.

> >  	mutex_unlock(&pnp_res_mutex);
> > -	dbg_pnp_show_resources(dev, "after pnp_assign_resources");
> > -	return 1;
> > -
> > -fail:
> > -	pnp_clean_resource_table(dev);
> > -	mutex_unlock(&pnp_res_mutex);
> > -	dbg_pnp_show_resources(dev, "after pnp_assign_resources (failed)");
> > -	return 0;
> > +	if (ret == 0)
> > +		dbg_pnp_show_resources(dev, "pnp_assign_resources succeeded");
> > +	else
> > +		dev_dbg(&dev->dev, "pnp_assign_resources failed (%d)\n", ret);
> > +	return ret;
> >  }
> >  
> >  /**
> > @@ -332,29 +282,21 @@ fail:
> >   */
> >  int pnp_auto_config_dev(struct pnp_dev *dev)
> >  {
> > -	struct pnp_option *dep;
> > -	int i = 1;
> > +	int i, ret = 0;
> >  
> >  	if (!pnp_can_configure(dev)) {
> >  		dev_dbg(&dev->dev, "configuration not supported\n");
> >  		return -ENODEV;
> >  	}
> >  
> > -	if (!dev->dependent) {
> > -		if (pnp_assign_resources(dev, 0))
> > +	for (i = 0; i == 0 || i < dev->num_dependent_sets; i++) {
> > +		ret = pnp_assign_resources(dev, i);
> > +		if (ret == 0)
> >  			return 0;
> 
> Eeeew. Perhaps:
> 
> i = 0;
> do {
> 	ret = pnp_assign_resources(dev, i);
> 	if (ret == 0)
> 		return 0;
> } while (++i < dev->num_dependent_sets);

Heh :-)  I vacillated on that one because I have a personal aversion
to "do { ... } while ()", especially with a pre-increment.  How would
you feel about this alternative?

        ret = pnp_assign_resources(dev, 0);
        if (ret == 0)
                return 0;

        for (i = 1; i < dev->num_dependent_sets; i++) {
                ret = pnp_assign_resources(dev, i);
                if (ret == 0)
                        return 0;
        }

> > -		port2->min += 0x400;
> > -		port2->max += 0x400;
> > -		port3->min += 0x800;
> > -		port3->max += 0x800;
> 
> Why do you do 0x800, 0x400 in that order? Shouldn't it just be 0x400, 
> 0x800 to mimick the old order?

I think they do end up in the correct order because I'm passing the
same list_head to both list_add() calls, e.g., we'll have something
like this:

    io -> ...
    io -> (io + 0x800) -> ...
    io -> (io + 0x400) -> (io + 0x800) -> ...

> > +		} else if (option->type == IORESOURCE_DMA) {
> > +			dma = &option->u.dma;
> >  			if ((dma->flags & IORESOURCE_DMA_TYPE_MASK) ==
> > -			    IORESOURCE_DMA_8BIT)
> > +						IORESOURCE_DMA_8BIT &&
> > +			    dma->map != 0x000A) {
> 
> It's a char, so 0x0A? 0x000A makes it looks like it's 16-bit.
> 
> > +				dev_info(&dev->dev, "changing possible "
> > +					 "DMA channel mask in option set %d "
> > +					 "from %#x to 0xA (1, 3)\n",
> > +					 pnp_option_set(option), dma->map);
> >  				dma->map = 0x000A;
> 
> And here...

Makes sense; I changed this as well as the dev_info() formats.

> >  	/*
> >  	 * The default range on the mpu port for these devices is 0x388-0x388.
> >  	 * Here we increase that range so that two such cards can be
> >  	 * auto-configured.
> >  	 */
> 
> While you're there -- s/mpu/OPL/.

Done.

> > +static void quirk_ad1815_mpu_resources(struct pnp_dev *dev)
> >  {
> > -	struct pnp_option *res;
> > +	struct pnp_option *option, *irq_option = NULL;
> > +	unsigned int independent_irqs = 0;
> > +
> > +	list_for_each_entry(option, &dev->options, list) {
> > +		if (option->type == IORESOURCE_IRQ &&
> > +		    !pnp_option_is_dependent(option)) {
> > +			independent_irqs++;
> > +			irq_option = option;
> > +		}
> > +	}
> >  
> > -	res = dev->dependent;
> > -	if (!res)
> > +	if (independent_irqs != 1)
> >  		return;
> >  
> > -	while (res->next)
> > -		res = res->next;
> > +	irq_option->flags |= IORESOURCE_IRQ_OPTIONAL;
> 
> You're in maze of unsigned variables, all named flags...
> 
> irq_option->u.irq.flags |= IORESOURCE_IRQ_OPTIONAL;
> 
> This was the thing that made things not work when I tested -- on an 
> AD1815...

Ah, of course, thanks.  I changed "irq_option" to a "struct pnp_irq *irq"
like I should have done to begin with.

> > +	dev_info(&dev->dev, "made independent IRQ optional\n");
> >  
> > -	res->next = quirk_isapnp_mpu_options(dev);
> > +	quirk_add_irq_optional_dependent_sets(dev);
> 
> And as before, this one be gone.

OK, great.  I wasn't sure I had understood those quirks correctly,
so thanks for pointing this out.

> > -struct pnp_option *pnp_build_option(int priority)
> > +struct pnp_option *pnp_build_option(struct pnp_dev *dev,
> > +					   unsigned long type,
> > +					   unsigned int option_flags)
> >  {
> > -	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));
> > +	struct pnp_option *option;
> >  
> > +	option = kzalloc(sizeof(struct pnp_option), GFP_KERNEL);
> >  	if (!option)
> >  		return NULL;
> >  
> > -	option->priority = priority & 0xff;
> > -	/* make sure the priority is valid */
> > -	if (option->priority > PNP_RES_PRIORITY_FUNCTIONAL)
> > -		option->priority = PNP_RES_PRIORITY_INVALID;
> 
> Dropping this made the 0x100 | prio ISAPnP/PnPBIOS bug appear. That 
> 0x100 should go anyway but perhaps this limiting is still a good idea?

Yes; I added the check back to pnp_dependent_option().

PNP_RES_PRIORITY_INVALID was previously 65536, which requires a 16-bit
field.  I changed it to 0xfff to fit in the 12-bit field I mentioned
earlier.

I need to go back over all your comments and make sure I've addressed
them all, then I'll post the revised patches, hopefully tomorrow.

Thanks again for all your work reviewing and testing these.  It's
been incredibly useful.

Bjorn
