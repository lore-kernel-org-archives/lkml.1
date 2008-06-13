Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYFMV2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYFMV2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYFMV1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:27:52 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:39853 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754121AbYFMV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:27:51 -0400
Date: Fri, 13 Jun 2008 22:27:44 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH 0/2] PCI 2.1 VPD support
Message-ID: <20080613212743.GZ11300@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI 2.1 specifies a way to provide VPD in the expansion ROM.  This patch
series exposes that in the same way as PCI 2.2 VPD.

I do not have any production devices with VPD in ROM so I reflashed a NIC
with an image including it.  This code should be tested against some
production ROMs since I may have misinterpreted the specification both
when reading and writing!

There are two remaining aspects of this that I'm not quite happy about:

1. I understand that the expansion ROM may share a decoder with BAR 0,
which makes expansion ROM access dangerous when a driver is loaded.  The
sysfs "rom" attribute must be specifically read-enabled by writing to it,
which I assume is intended to protect against this.  Perhaps
pci_vpd_pci21_read() should test pdev->rom_attr_enabled?

2. PCI resource allocation may fail during pci_scan_device() and
therefore I could not insert the call to pci_vpd_pci21_init() there.
Instead I added it to pci_create_sysfs_dev_files() - but I don't really
think this function should be probing.  Is there a better place to add
the call?

Ben.

Ben Hutchings (2):
  PCI: ROM access changes to support PCI 2.1 VPD
  PCI: Expose PCI 2.1 VPD through sysfs

 drivers/pci/pci-sysfs.c |    2 +-
 drivers/pci/pci.h       |    1 +
 drivers/pci/rom.c       |  245 +++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 206 insertions(+), 42 deletions(-)

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
