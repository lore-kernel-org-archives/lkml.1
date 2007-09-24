Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXIXWRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXIXWRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXIXWQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:16:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:17103 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbXIXWQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:16:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,292,1186383600"; 
   d="scan'208";a="151592582"
Date: Mon, 24 Sep 2007 15:12:01 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       akpm@linux-foundation.org
Subject: [patch 0/2] SATA Link Power Management patches
Message-Id: <20070924151201.6974d9b5.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a set of patches which implement link power management for SATA. 
We had talked at kernel summit of moving sysfs interface for setting
the link power management policy to the block layer, but after a 
lot of consideration, I think this doesn't make sense.  Mainly because
I feel for SATA the link power management policy should be associated
with the controller, not with the device. So, we continue to use
the shost_attrs array in the scsi host template to create a sysfs
interface that is associated with the scsi_host class. 

These patches have changed since the last version.  The patches have
been refreshed to use the new ata_link structures.  Additionally, I've
separated out DIPM enabling and put it into libata-core, because DIPM
can be used by any SATA disk that is attached to a controller which
allows DIPM, although in this implementation the driver will need
to explicitly set a flag which would indicate to the core that it
is OK to set DIPM.  This is because all interface power state changes
can cause Phy Ready interrupts, and the driver will need to know
to ignore them. DIPM will only be enabled for the min_power link
power management policy value.  This is because many disks are not
clever enough to know that if a controller naks their request for
a SLUMBER transition, they should retry for PARTIAL - instead they
will just give up all together.

With these patches, measured on my X60 with a Watts Up Pro meter,
in the base station after all powertop suggestions have been applied,  
I see a savings of approximately .7-.8 W in min_power mode, and
.5 W in medium_power mode.  For the best power/performance tradeoff,
it's recommended that you use the "medium_power" setting, although
min_power can be used of course when you absolutely need to save
every 10th of a watt and don't care about the additional performance
loss.

Please give them a try.
Thanks,
Kristen
