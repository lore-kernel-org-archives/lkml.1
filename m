Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZFYS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZFYS7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFYS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:59:30 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39227 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZFYS7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:59:30 -0400
Date: Thu, 25 Jun 2009 12:59:32 -0600
From: Alex Chiang <achiang@hp.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Troy Moure <twmoure@szypr.net>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, lenb@kernel.org
Subject: Re: [2.6.31-rc1] oops in acpi_get_pci_dev
Message-ID: <20090625185932.GF27102@ldl.fc.hp.com>
References: <alpine.LFD.2.00.0906251548300.2760@troy-laptop> <b6a2187b0906250902xede3041p599e538099340a04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6a2187b0906250902xede3041p599e538099340a04@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff, Alessandro,

First, thanks for reporting this bug, and apologies for the
inconvenience.

* Jeff Chua <jeff.chua.linux@gmail.com>:
> On Thu, Jun 25, 2009 at 11:13 PM, Troy Moure<twmoure@szypr.net> wrote:
> > (I don't know if it's the "right" fix or not, not being familiar with the
> > system.  If it is, I can send it in as a proper patch.)
> >
> > diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> > index 8a5bf3b..55b5b90 100644
> > --- a/drivers/acpi/pci_root.c
> > +++ b/drivers/acpi/pci_root.c
> > @@ -395,7 +395,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
> >                fn  = adr & 0xffff;
> >
> >                pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
> > -               if (hnd == handle)
> > +               if (!pdev || hnd == handle)
> >                        break;
> >
> >                pbus = pdev->subordinate;

I'm a little hesitant to do this (yet), because it means one of
my assumptions was wrong.

Can you please try this debug patch and send me the dmesg output?
Please boot with 'debug'. I did add the same NULL check so you
shouldn't crash, and can send me the output after you're done
booting up.

Also, if you could include the output of 'lspci -v', that would
be great too.

Thanks.

/ac

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 8a5bf3b..7674987 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -355,12 +355,20 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 	struct pci_dev *pdev = NULL;
 	struct acpi_handle_node *node, *tmp;
 	struct acpi_pci_root *root;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	LIST_HEAD(device_list);
 
 	/*
 	 * Walk up the ACPI CA namespace until we reach a PCI root bridge.
 	 */
 	phandle = handle;
+
+	acpi_get_name(phandle, ACPI_FULL_PATHNAME, &buffer);
+	printk("Starting root bridge search from %s\n", (char *)buffer.pointer);
+	kfree(buffer.pointer);
+	buffer.pointer = NULL;
+	buffer.length = 0;
+
 	while (!acpi_is_root_bridge(phandle)) {
 		node = kzalloc(sizeof(struct acpi_handle_node), GFP_KERNEL);
 		if (!node)
@@ -370,6 +378,12 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 		node->handle = phandle;
 		list_add(&node->node, &device_list);
 
+		acpi_get_name(phandle, ACPI_FULL_PATHNAME, &buffer);
+		printk("+ Adding %s\n", (char *)buffer.pointer);
+		kfree(buffer.pointer);
+		buffer.pointer = NULL;
+		buffer.length = 0;
+
 		status = acpi_get_parent(phandle, &phandle);
 		if (ACPI_FAILURE(status))
 			goto out;
@@ -380,6 +394,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 		goto out;
 
 	pbus = root->bus;
+	dev_info(&pbus->dev, "I'm a little pci_bus, short and stout...\n");
 
 	/*
 	 * Now, walk back down the PCI device tree until we return to our
@@ -394,7 +409,16 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 		dev = (adr >> 16) & 0xffff;
 		fn  = adr & 0xffff;
 
+		printk("Searching for %04x:%02x:%02x.%d\n",
+			pci_domain_nr(pbus), pbus->number,
+			PCI_SLOT(PCI_DEVFN(dev, fn)),
+			PCI_FUNC(PCI_DEVFN(dev, fn)));
+
 		pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
+		if (!pdev) {
+			printk("Ouch.\n");
+			break;
+		}
 		if (hnd == handle)
 			break;
 
