Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYFPPmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYFPPmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYFPPmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:42:16 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:35855 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYFPPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:42:15 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 15/18] PNP: support optional IRQ resources
Date: Mon, 16 Jun 2008 09:41:48 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221129.758385014@ldl.fc.hp.com> <4853814D.4010309@keyaccess.nl>
In-Reply-To: <4853814D.4010309@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806160941.49959.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 June 2008 02:29:01 am Rene Herman wrote:
> On 05-06-08 00:09, Bjorn Helgaas wrote:
> 
> > This patch adds an IORESOURCE_IRQ_OPTIONAL flag for use when
> > assigning resources to a device.  If the flag is set and we are
> > unable to assign an IRQ to the device, we can leave the IRQ
> > disabled but allow the overall resource allocation to succeed.
> > 
> > Some devices request an IRQ, but can run without an IRQ
> > (possibly with degraded performance).  This flag lets us run
> > the device without the IRQ instead of just leaving the
> > device disabled.
> > 
> > This is a reimplementation of this previous change by Rene
> > Herman <rene.herman@gmail.com>:
> >     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3b73a223661ed137c5d3d2635f954382e94f5a43
> > 
> > I reimplemented this for two reasons:
> >     - to prepare for converting all resource options into a single linked
> >       list, as opposed to the per-resource-type lists we have now, and
> >     - to preserve the order and number of resource options.
> > 
> > In PNPBIOS and ACPI, we configure a device by giving firmware a
> > list of resource assignments.  It is important that this list
> > has exactly the same number of resources, in the same order,
> > as the "template" list we got from the firmware in the first
> > place.
> > 
> > The problem of a sound card MPU401 being left disabled for want of
> > an IRQ was reported by Uwe Bugla <uwe.bugla@gmx.de>.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> You rework this again in the later patch doing the final switch over 
> after which things end up right but also already at this point:
> 
> > @@ -176,33 +184,10 @@ static void quirk_ad1815_mpu_resources(s
> >  	if (!irq || irq->next)
> >  		return;
> >  
> > -	res = dev->dependent;
> > -	if (!res)
> > -		return;
> > -
> > -	while (1) {
> > -		struct pnp_irq *copy;
> > -
> > -		copy = pnp_alloc(sizeof *copy);
> > -		if (!copy)
> > -			break;
> > -
> > -		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
> > -		copy->flags = irq->flags;
> > -
> > -		copy->next = res->irq; /* Yes, this is NULL */
> > -		res->irq = copy;
> > -
> > -		if (!res->next)
> > -			break;
> > -		res = res->next;
> > -	}
> > -	kfree(irq);
> > +	irq->flags |= IORESOURCE_IRQ_OPTIONAL;
> > +	dev_info(&dev->dev, "made independent IRQ optional\n");
> >  
> >  	res->next = quirk_isapnp_mpu_options(dev);
> 
> ... this line should just go.

You mean I should delete the "res->next = quirk_isapnp_mpu_options(dev)"
line?

> Previously "res" ended up as the last dependent set through the while 
> loop but now it's the independendent set which in this previous setup of 
> things shouldn't even have a ->next. Just deleting this line makes this 
> patch fine and
> 
> Acked-by: Rene Herman <rene.herman@gmail.com>

OK.  This will mean replacing patches 15 and 18 in this series.  If
I repost those two, is that easy for you to deal with, Andrew?

If I replace these, I'll also update patch 18 to fix the
pnp_independent_option() comment Rene made.

Bjorn
