Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbYHEVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbYHEVXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763260AbYHEVWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:22:46 -0400
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:39207 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763352AbYHEVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:22:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=tbPCVqJP3MQLV09+LYIYv1sprf8eqjV69YoTzQv6/Ul2Ful3OsFAX/OVQ291tEUiq8hiy9S5QhkLIrarX9tBPru33Z/vdzfZPefY75jsTOmjDFdjC43YVeSoOHTPKMYZ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 5 Aug 2008 14:15:59 -0700
User-Agent: KMail/1.9.9
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain> <200808051353.52323.jbarnes@virtuousgeek.org> <1217969794.9923.70.camel@localhost.localdomain>
In-Reply-To: <1217969794.9923.70.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051415.59993.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 05, 2008 1:56 pm James Bottomley wrote:
> On Tue, 2008-08-05 at 13:53 -0700, Jesse Barnes wrote:
> > On Tuesday, August 05, 2008 1:44 pm James Bottomley wrote:
> > > On Tue, 2008-08-05 at 10:03 -0700, Jesse Barnes wrote:
> > > > This seems to be a function that just returns what type of IRQ you're
> > > > using or how it's routed and it isn't necessarily "lost interrupt"
> > > > specific.
> > >
> > > So perhaps this routine should only note but not advise?  The drivers
> > > can then just call pci_interrupt_type to see if they can do anything.
> >
> > If it's just a pci_irq_type function then it probably shouldn't print
> > anything, and leave that to the caller, since it might be used for other
> > purposes too (e.g. a driver load printk or something).  In the lost
> > interrupt case you already have to disable MSI or MSIX in the Fusion
> > driver, so you may as well put the printk there, right?  I guess I'm
> > saying it should neither note nor advise, just return the IRQ type.
>
> Well, no; the object was to have the layer that knew (PCI) print
> information which could be used to identify the problem.  Likely what
> the driver will say is something like "MSI isn't working and it's not my
> fault".  What I want is for PCI to print something that may be helpful
> to people trying to diagnose the problem.  Driver writers aren't going
> to get that right.

Yeah, I understand what you're trying to do, and given that there's only one 
user of this function (your fusion patch), I don't have a strong preference.

However, the function is really just telling the driver what type of IRQ a 
given PCI device currently has; it's not really a "lost interrupt" function 
at all.  So to me, it makes sense to just generalize it into a pci_irq_type 
function and let drivers do what they will with it.  It looks like this is 
the real lost interrupt detection:

+               /* May fail becuase of IRQ misrouting */
+               rc = mpt_get_manufacturing_pg_0(ioc);
+               if (rc) {
+			...
+                       printk(MYIOC_s_ERR_FMT "Cannot recover IRQ routing\n",
+                              ioc->name);
+                       return -1;
+               }

not the pci_lost_interrupt() function.  So it could just as easily be written 
as such:

+               /* May fail becuase of IRQ misrouting */
+               rc = mpt_get_manufacturing_pg_0(ioc);
+               if (rc) {
+			/* Lost an IRQ, see what type... */
+			int irq_type = pci_irq_type(dev);
+
+                       if (type == PCI_IRQ_MSI) {
+				/* Lost an MSI interrupt, try re-config w/o MSI */
+                               free_irq(ioc->pci_irq, ioc);
+                               ioc->msi_enable = 0;
+                               pci_disable_msi(ioc->pcidev);
+                               goto retry;
+                       }
+			/* This platform is just broken... */
+                       printk(MYIOC_s_ERR_FMT "Cannot recover from %s IRQ
+			       routing error\n", pci_irq_type_name(type), ioc->name);
+                       return -1;
+               }

or somesuch.  That seems just as simple for driver writers as your initial 
patch, and the function is named in accordance with what it actually does, 
rather than what it's used for...

Jesse
