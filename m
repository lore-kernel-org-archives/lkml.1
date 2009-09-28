Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZI1Um0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZI1Um0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZI1UmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:42:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZI1UmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:42:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after resume from suspend
Date: Mon, 28 Sep 2009 22:43:44 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Xiaotian Feng <dfeng@redhat.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <20090928173819.GA2441@ldl.fc.hp.com>
In-Reply-To: <20090928173819.GA2441@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909282243.44226.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, Alex Chiang wrote:
> Hi Xiaotian,
> 
> Thanks for the bug report.
> 
> * Xiaotian Feng <dfeng@redhat.com>:
> > commit 275582 introduces acpi_get_pci_dev(), but pdev->subordinate
> > can be NULL, then a NULL was passed to pci_get_slot, this results
> > the kernel oops when resume from suspend.
> > 
> > This patch resolves following kernel oops:
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> > IP: [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
> > 
> > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > ---
> >  drivers/acpi/pci_root.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> > index 3112221..3c35144 100644
> > --- a/drivers/acpi/pci_root.c
> > +++ b/drivers/acpi/pci_root.c
> > @@ -387,7 +387,11 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
> >  		if (!pdev || hnd == handle)
> >  			break;
> >  
> > -		pbus = pdev->subordinate;
> > +		if (pdev->subordinate)
> > +			pbus = pdev->subordinate;
> > +		else
> > +			pbus = pdev->bus;
> > +
> 
> I'm a little confused by this. If we start from the PCI root
> bridge and walk back down the hierarchy, shouldn't everything
> between the root and the device be a P2P bridge?

Well, if my reading of the code is correct, there's no guarantee that
pci_get_slot() will always return either the right device or a bridge.  If it
returns anything that's not a bridge or the device we're looking for, we'll hit
the NULL pointer deref.

In fact it looks like we should also clear pdev if no device was found.

Thanks,
Rafael
