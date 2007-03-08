Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXCHHFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXCHHFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbXCHHFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:05:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53530 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbXCHHFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:05:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>
	<20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>
	<20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>
	<20070305084257.GA4464@mellanox.co.il>
	<20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>
	<45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>
	<45ED8A12.5040803@intel.com>
	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>
	<45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com>
	<m1649cdfas.fsf@ebiederm.dsl.xmission.com>
	<20070307185317.5601d452.akpm@linux-foundation.org>
Date: Wed, 07 Mar 2007 23:58:22 -0700
In-Reply-To: <20070307185317.5601d452.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 7 Mar 2007 18:53:17 -0800")
Message-ID: <m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>
> That's:
>
>         pci_restore_pcix_state(dev);
>         pci_restore_msi_state(dev);
>         WARN_ON(!hlist_empty(&dev->saved_cap_space));
>
>         return 0;

Hmm.  Either I am confused of I just found an unanticipated leak.

pci_restore_msi_state should be out of the picture as we don't yet
have ppc msi support and I don't think the g5 generation hardware
supported it either.

The only case I can see which might trigger this is if we saved
pci-X state and then didn't restore it because we could not find
the capability on restore.

Any chance you could walk that list and find the cap_nr of the remaining
element?  

Something like:
{
	struct pci_cap_saved_state *tmp;
	struct hlist_node *pos;

	hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next)
        	printk(KERN_INFO "saved_cap: 0x%02x\n", tmp->cap_nr);
}

Until I get the best scenario I can come up with is a tg3 hardware bug
that doesn't renable the pci-X capability after a restore of power state.

Getting that cap_nr will at least allow me to be certain if I am dealing
with msi, pci-X or pci-e.

Unanticipated bugs aren't supposed to be this easy to find!

Eric

