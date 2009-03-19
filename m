Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZCSJga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZCSJga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZCSJgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:36:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbZCSJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:36:18 -0400
Date: Thu, 19 Mar 2009 02:29:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] PCI: Introduce pci_rescan_bus()
Message-Id: <20090319022956.25ae6a5a.akpm@linux-foundation.org>
In-Reply-To: <20090318223956.887.57080.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
	<20090318223956.887.57080.stgit@bob.kio>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 16:39:56 -0600 Alex Chiang <achiang@hp.com> wrote:

> +/**
> + * pci_rescan_bus - scan a PCI bus for devices.
> + * @bus: PCI bus to scan
> + *
> + * Scan a PCI bus and child buses for new devices, adds them,
> + * and enables them.
> + *
> + * Returns the max number of subordinate bus discovered.
> + */
> +unsigned int __devinit pci_rescan_bus(struct pci_bus *bus)
> +{
> +	unsigned int max;
> +	struct pci_dev *dev;
> +
> +	max = pci_scan_child_bus(bus);
> +	list_for_each_entry(dev, &bus->devices, bus_list)
> +		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> +		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
> +			if (dev->subordinate)
> +				pci_bus_size_bridges(dev->subordinate);
> +
> +	pci_bus_assign_resources(bus);
> +	pci_enable_bridges(bus);
> +	pci_bus_add_devices(bus);
> +
> +	return max;
> +}

The conspicuous lack of locking for the list walk requires either

a) documenting or
b) fixing

IMO.
