Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZLCIjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZLCIjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZLCIjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:39:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42742 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZLCIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:39:47 -0500
Date: Thu, 3 Dec 2009 00:39:45 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Jon Mason <jdmason@kudzu.us>, discuss@x86-64.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Corinna Schultz <coschult@us.ibm.com>
Subject: Re: [PATCH] Calgary: Find nearest matching Calgary while walking
	up the PCI tree
Message-ID: <20091203083944.GH10295@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091202014733.GD10295@tux1.beaverton.ibm.com> <61b968730912021551m23c9859doda2d414529c59ac6@mail.gmail.com> <20091203064948.GB2444@tyrion.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091203064948.GB2444@tyrion.haifa.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 08:49:48AM +0200, Muli Ben-Yehuda wrote:
> On Wed, Dec 02, 2009 at 05:51:19PM -0600, Jon Mason wrote:
> 
> > > diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> > > index 971a3be..e6ec8a2 100644
> > > --- a/arch/x86/kernel/pci-calgary_64.c
> > > +++ b/arch/x86/kernel/pci-calgary_64.c
> > > @@ -318,13 +318,15 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
> > >
> > >        pdev = to_pci_dev(dev);
> > >
> > > +       /* search up the device tree for an iommu */
> > >        pbus = pdev->bus;
> > > -
> > > -       /* is the device behind a bridge? Look for the root bus */
> > > -       while (pbus->parent)
> > > +       do {
> > > +               tbl = pci_iommu(pbus);
> > > +               if (tbl && tbl->it_busno == pbus->number)
> > > +                       break;
> > > +               tbl = NULL;
> > 
> > I believe the NULL assignment is unnecessary.  If not, then the if
> > check and BUG_ON are busted.
> 
> I think the NULL assignment is needed for the case where the loop ends
> (pbus is NULL) and we did not find the right tbl. You don't want to
> leave the tbl pointing to the last tbl we saw while walking the bus.

Correct.  I suspect that you'd only hit this situation in a fairly pathological
corner case, but configuring the wrong Calgary for IO could (in theory) be used
to breach the Calgary protections, whereas failing to set up the necessary
permissions will simply crash the system.  In any case it seems cleaner to me to
throw away the tbl pointer once we've decided that we're done with it.

--D
