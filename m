Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbZATX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbZATX6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbZATX5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:57:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZATX5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:57:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH PCI PCIe portdrv: Fix allocation of interrupts (rev. 5)
Date: Wed, 21 Jan 2009 00:57:11 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200901131457.58164.rjw@sisk.pl> <200901171440.42840.rjw@sisk.pl> <4973F60E.5000706@jp.fujitsu.com>
In-Reply-To: <4973F60E.5000706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901210057.12103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Hidetoshi Seto wrote:
> Rafael J. Wysocki wrote:
> > On Saturday 17 January 2009, Rafael J. Wysocki wrote:
> (snip)
> >> If MSI-X are supported, it allocates as many vectors as there are entries
> >> in the port's MSI-X table, but no more than 32, and figures out which of them
> >> will be used for the port services.
> > 
> > The patch didn't check which services are available during the MSI-X set up
> > which was wrong.
> > 
> > Also, in the meantime, i thought it might be a good idea to free the interrupt
> > routing table entries that aren't going to be used after all.
> > 
> > The patch below adds this to the previous version and checks for the
> > availability of port services in the MSI-X setup resume.  I hope it will
> > be acceptable to everyone.
> > 
[--snip--]
> > +	/*
> > +	 * Allocate as many entries as the device wants temporarily, so that we
> > +	 * can check which of them will be useful.
> > +	 */
> > +	for (i = 0; i < nr_entries; i++)
> > +		msix_entries[i].entry = i;
> 
> 	/*
> 	 * So, if msix_entries is correctly equal to the number of entries this
> 	 * port actually uses, we'll happily go through without using trick.
> 	 */

Good point!

> > +
> > +	status = pci_enable_msix(dev, msix_entries, nr_entries);
> > +	if (status)
> > +		goto Exit;
[--snip--]
> > +
> 
> /* Are there any unused entries? */
> if (nr_allocated > nvec) {
> 	/* this port have extra entries not for services we know... */
> 
> > +	/* Drop the temporary MSI-X setup */
> > +	pci_disable_msix(dev);

Yes, I'm going to do that.

> > +	/* Now allocate the MSI-X vectors for real */
> > +	status = pci_enable_msix(dev, msix_entries, nvec);
> > +	if (status)
> > +		goto Error;
> 
> 	/*
> 	 * World have broken hardwares, so even spec says numbers are constant,
> 	 * it would be better to re-check registers after 2nd pci_enable_msix.
> 	 * Or we just skip this.  (However this was what your concern, Rafael?)
> 	 */
> 	if (func_foo_do_paranoia_check(dev, msix_entries, nvec))
> 		goto Error;	

Well, I think let's not do it for now.  If there's a system that actually
breaks here, then we can introduce the extra checking.

Thanks,
Rafael
