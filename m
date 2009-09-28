Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbZI1W3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbZI1W3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZI1W3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:29:10 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:31107 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZI1W3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:29:09 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2009 18:29:09 EDT
Date: Mon, 28 Sep 2009 16:20:02 -0600
From: Alex Chiang <achiang@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Xiaotian Feng <dfeng@redhat.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after resume
	from suspend
Message-ID: <20090928222002.GC19406@ldl.fc.hp.com>
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <20090928173819.GA2441@ldl.fc.hp.com> <200909282243.44226.rjw@sisk.pl> <200909282305.56102.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909282305.56102.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 28 September 2009, Rafael J. Wysocki wrote:
> > On Monday 28 September 2009, Alex Chiang wrote:
> > > * Xiaotian Feng <dfeng@redhat.com>:
> > > > --- a/drivers/acpi/pci_root.c
> > > > +++ b/drivers/acpi/pci_root.c
> > > > @@ -387,7 +387,11 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
> > > >  		if (!pdev || hnd == handle)
> > > >  			break;
> > > >  
> > > > -		pbus = pdev->subordinate;
> > > > +		if (pdev->subordinate)
> > > > +			pbus = pdev->subordinate;
> > > > +		else
> > > > +			pbus = pdev->bus;
> > > > +
> > > 
> > > I'm a little confused by this. If we start from the PCI root
> > > bridge and walk back down the hierarchy, shouldn't everything
> > > between the root and the device be a P2P bridge?
> > 
> > Well, if my reading of the code is correct, there's no guarantee that
> > pci_get_slot() will always return either the right device or a bridge.
> 
> I should have been more precise.
> 
> If devfn of node happens to be the same as devfn of a non-bridge device on
> pbus, the pci_get_slot() will return a valid pointer to it, but
> pdev->subordinate will be NULL.  Is it impossible for some reason?

Hm, that's a good thought, but I'm still confused. Here's the
first part of the full function (acpi_get_pci_dev):

        phandle = handle;
        while (!acpi_is_root_bridge(phandle)) {
                node = kzalloc(sizeof(struct acpi_handle_node), GFP_KERNEL);
                if (!node)
                        goto out;

                INIT_LIST_HEAD(&node->node);
                node->handle = phandle;
                list_add(&node->node, &device_list);

                status = acpi_get_parent(phandle, &phandle);
                if (ACPI_FAILURE(status))
                        goto out;
        }

phandle starts off as the input parameter, and we make successive
calls to acpi_get_parent() to walk up the ACPI device tree until
we get to a root bridge.

My assumption here is that all those ACPI devices must be P2P
bridges.

        root = acpi_pci_find_root(phandle);
        if (!root)
                goto out;

        pbus = root->bus;

Now we've got an acpi_pci_root() which has a struct pci_bus, and
we can start walking back down the PCI tree. Except what we're
really doing is iterating across the device_list which we created
above.

device_list should only contain P2P bridges, based on my
assumption above.

        list_for_each_entry(node, &device_list, node) {
                acpi_handle hnd = node->handle;
                status = acpi_evaluate_integer(hnd, "_ADR", NULL, &adr);
                if (ACPI_FAILURE(status))
                        goto out;
                dev = (adr >> 16) & 0xffff;
                fn  = adr & 0xffff;

                pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
                if (!pdev || hnd == handle)
                        break;

                pbus = pdev->subordinate;
                pci_dev_put(pdev);
        }

The point you raise about collision between the devfn of 'node'
and some non-bridge device returned by pci_get_slot() seems like
it really shouldn't happen, because we evaluate _ADR for each
node on device_list, in the reverse order that we found them, and
based on my assumption, all those nodes should be bridges.

I'm not saying that Xiaotian's patch is wrong. I'm saying I'd
like to be educated as to why my basic assumption was wrong,
because now you're making me think that this code is pretty
fragile. :-/

Thanks.

/ac


