Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbYJIEVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbYJIEVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbYJIEJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:09:19 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26545 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbYJIEJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:09:16 -0400
Date: Wed, 8 Oct 2008 22:09:14 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v4 02/15] PCI Hotplug: serialize
	pci_hp_register/deregister
Message-ID: <20081009040914.GC4668@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, kaneshige.kenji@jp.fujitsu.com
References: <20081003230125.9989.31145.stgit@bob.kio> <20081003231737.9989.94126.stgit@bob.kio> <20081006144534.GD25780@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006144534.GD25780@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Fri, Oct 03, 2008 at 05:17:37PM -0600, Alex Chiang wrote:
> > Add explicit locking to pci_hp_register/deregister. For a given pci_slot,
> > we want to make sure that the pci_slot->hotplug pointer isn't being
> > changed from underneath us.
> 
> I'm torn between saying this goes too far and this doesn't go far
> enough.  If pci_hp_register() and pci_hp_deregister() can race against
> each other,

I think Kenji-san was more worried about the race for multiple
callers of pci_create_slot() and all the horrible crap I was
introducing to account for slot renaming.

I've figured out a different approach which I'll be sending out
shortly. I didn't change any of the locking semantics in
pci_hp_register/deregister, so I disclaim responsibility for any
existing races that exist today. ;) (note, I don't think there
are any).

> > diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> > index 0c6db03..1fffb27 100644
> > --- a/drivers/pci/slot.c
> > +++ b/drivers/pci/slot.c
> > @@ -164,10 +164,10 @@ placeholder:
> >  	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
> >  		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
> >  
> > - out:
> > +out:
> >  	up_write(&pci_bus_sem);
> >  	return slot;
> > - err:
> > +err:
> >  	kfree(slot);
> >  	slot = ERR_PTR(err);
> >  	goto out;
> 
> Gratuitous whitespace change?

Maybe... I'm gonna keep this same hunk, but fold it into a bigger
patch so it won't be as noticable. ;)

/ac

