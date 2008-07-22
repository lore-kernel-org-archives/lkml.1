Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYGVIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYGVIV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYGVIVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:21:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:64710 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYGVIVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gCbW3m+YkOYDWkIWW+YgEHz3oANca9WpkFWtkEBs8n5Subw24EIH0qGCEh9fTfB0ac
         ij8i+ay8GHvU/ux7pOUvlP3XhVa958tLT5EvjWvYNg5lE78RFD8bAXShIDZXnmZNOd4q
         Dl/FAR0UFv7Y4dv5cw9J5VS+/1SHsQ4GM1AWU=
Message-ID: <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com>
Date: Tue, 22 Jul 2008 11:21:06 +0300
From: "eran liberty" <eran.liberty@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
Cc: "Eran Liberty" <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20080721194957.GH24246@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com>
	 <20080721194957.GH24246@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this is your real problem, that you're rescanning the entire
> bus.  I don't think that's the route we'd recommend taking.
>

My stating point was that I have loaded a new design into a
programmable device which sits on the pci device. The new design can
implement numerous pci devices or non at all. I can think of an easy
way (or clean one) to scan only the programmable device. Scanning the
whole bus seemed reasonable.

> Why don't you call pci_scan_slot() instead?  You won't get the benefit of
> pcibios_fixup_bus(), but I'm not convinced that's safe to call on a bus
> that's already been scanned.
>

As said its not exactly a slot its more like a regular pci device that
someone suddenly welded into the pci bus. Its not a hotplug as well,
and I do not want to give up on the pcibios_fixup_bus()

As it is, with my patch applied i successfully go over the bus and
remove my own devices before I reprogram the
programmable device.

while ((dev = pci_get_device(PCI_VENDOR_ID_MYCOMP,PCI_DEVICE_ID_MYDEV,NULL))
!= NULL) {
	pci_remove_bus_device(dev);
	pci_dev_put(dev);
}

Load a new design into it.

Then scan the entire bus and add the newly discovered devices.

bus = null;
while ((bus = pci_find_next_bus(bus)) != NULL) {
	pci_scan_child_bus(bus);
	pci_bus_assign_resources(bus);
	pci_bus_add_devices(bus);
}

As seen here, this sequence of instructions seems very intuitive. It
will fail without the patch upon pci_bus_add_devices().

Liberty
