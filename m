Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYHSVks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYHSVks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYHSVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:40:23 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:38645 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754625AbYHSVkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:40:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hdv1B/urs6jZXlkxKLkQhBrzcabZRmTEIw5OVBQ3k+Zzt5R7pmTDwnkx2Inyfn7835g/GiMvJPhRlH6+956oIGTFTpGAx4Er5HBGjoXMvBkzWkJnPAQBfvknKdVKHZri;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 04/13] PCI: acpiphp: remove 'name' parameter
Date: Tue, 19 Aug 2008 14:40:05 -0700
User-Agent: KMail/1.9.9
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
References: <20080816235504.5461.20733.stgit@blender.achiang> <200808171059.50802.eike-kernel@sf-tec.de> <20080819183908.GD18842@ldl.fc.hp.com>
In-Reply-To: <20080819183908.GD18842@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191440.05930.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 19, 2008 11:39 am Alex Chiang wrote:
> * Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > Alex Chiang wrote:
> > > +static inline const char *slot_name(struct slot *slot)
> > > +{
> > > +	return hotplug_slot_name(slot->hotplug_slot);
> > > +}
> > > +
> > >  /*
> > >   * struct acpiphp_bridge - PCI bridge information
> > >   *
> >
> > I don't see a point in this function. Why not call hotplug_slot_name()
> > directly?
>
> You're correct that we don't exactly need it in acpiphp. However,
> it is a useful helper function for some of the other drivers, and
> I thought it would be better to keep consistency if possible.
>
> Also, it helps later on, when trying to stay below the 80 column
> limit. :)

If they're all identical, maybe we should pull this up into a common function 
(with a short name :).  That can be a subsequent cleanup though.

> > > @@ -84,7 +87,6 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops
> > > = { .get_adapter_status	= get_adapter_status,
> > >  };
> > >
> > > -
> > >  /**
> > >   * acpiphp_register_attention - set attention LED callback
> > >   * @info: must be completely filled with LED callbacks
> >
> > Fuzz.
>
> Yes, it's fuzz, but my practice has been to clean up* source files
> during the course of making actual, functional changes. Better
> than sending a mostly-useless whitespace patchbomb, IMO.
>
> * Note that "clean up" here means "reasonable cleanup" that
>   doesn't detract from reading the rest of the patch.

Yeah the main reason for separating whitespace changes from real ones is to 
avoid making the patch hard to read in case a problem crops up.  Killing an 
extra newline doesn't make things harder to read, imo, so it's fine with me 
if you keep it (though if you *do* end up doing a cleanup patch later you 
could save it for that).

> > > @@ -92,7 +94,7 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops
> > > = { * Description: This is used to register a hardware specific ACPI *
> > > driver that manipulates the attention LED.  All the fields in * info
> > > must be set.
> > > - */
> > > + **/
> > >  int acpiphp_register_attention(struct acpiphp_attention_info *info)
> > >  {
> > >  	int retval = -EINVAL;
> >
> > Fuzz. Make the patch look bigger than it actually is. But that's just a
> > note, Jesse will have to judge if this is acceptable.
>
> See above. Fixing incorrect kerneldoc doesn't seem so bad, IMO.

kerneldoc is ok with either */ or **/ as a closing comment, so you can drop 
these bits.

> > >  	acpiphp_slot->slot = slot;
> > > -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
> > > +	memset(name, 0, SLOT_NAME_SIZE);
> > > +	snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
> >
> > The memset() is not needed at all. And the sizeof is IMHO a good idea
> > anyway as it allows to get rid of the define.
>
> Hm, don't need a memset? I won't have garbage on the stack?
> </n00b>

Yeah, but you'll overwrite it with snprintf anyway, so the memset is 
redundant.

> On the other hand, keeping the #define is important, because
> again, that's the established convention of the PCI hotplug
> drivers.
>
> Thanks for the review.

Going from the define to sizeof() everywhere could be another cleanup, but I 
don't have strong feelings about that.

Jesse
