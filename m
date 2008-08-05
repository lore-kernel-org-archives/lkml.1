Return-Path: <linux-kernel-owner+w=401wt.eu-S1765069AbYHEUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765069AbYHEUyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763480AbYHEUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:53:58 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:42284 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754334AbYHEUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:53:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=c8M1ASvCJ0ePHNod+bGEcAx8tr4NVHFeurz8VGnWtY11oGR0ZkBxHx050tP9bwBzn5fsvCaDtzpJAtDomd5p1/p6+Ic8AtZtVkf1OMooDzIyNKy75xO0xNxiV9ok1kb5;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 5 Aug 2008 13:53:52 -0700
User-Agent: KMail/1.9.9
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain> <200808051003.10400.jbarnes@virtuousgeek.org> <1217969041.9923.64.camel@localhost.localdomain>
In-Reply-To: <1217969041.9923.64.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051353.52323.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 05, 2008 1:44 pm James Bottomley wrote:
> On Tue, 2008-08-05 at 10:03 -0700, Jesse Barnes wrote:
> > This seems to be a function that just returns what type of IRQ you're
> > using or how it's routed and it isn't necessarily "lost interrupt"
> > specific.
>
> So perhaps this routine should only note but not advise?  The drivers
> can then just call pci_interrupt_type to see if they can do anything.

If it's just a pci_irq_type function then it probably shouldn't print 
anything, and leave that to the caller, since it might be used for other 
purposes too (e.g. a driver load printk or something).  In the lost interrupt 
case you already have to disable MSI or MSIX in the Fusion driver, so you may 
as well put the printk there, right?  I guess I'm saying it should neither 
note nor advise, just return the IRQ type.

> > This information is clearly useful to drivers both for informational
> > purposes and for debugging problems, so on that front it looks good. 
> > However, I think it should probably be called pci_interrupt_type(struct
> > pci_dev *dev) or something instead, and just return an enum of either
> > MSIX, MSI, or LINE (though I'm open to better names).  From that, the
> > driver can infer what might be going wrong, though in the case of a LINE
> > interrupt, all you can really do is report that there's probably a
> > platform IRQ routing problem.
>
> The only thing that this can't do is ACPI ... but on the other hand once
> the IRQ routing is set by ACPI I'm not sure the driver can do anything
> to fix it.

Yeah, ACPI may or may not be the problem, all you'll really know is that 
you've got a line interrupt that you failed to get...  The driver won't be 
able to do much in that case aside from complain loudly.

Thanks,
Jesse
