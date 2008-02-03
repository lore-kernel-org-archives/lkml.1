Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYBCWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYBCWBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYBCWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:01:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47531 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYBCWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:01:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:00:54 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/9] firewire-sbp2: misc hotplug related patches
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is various stuff to hopefully improve fw-sbp2's behavior during bus
resets.  The main piece is patch 9/9 which considerably raises the
chance that ongoing I/O survives plugging and unplugging of other
devices on the same bus as the device which services the I/O.

The other patches are basically side products of patch 9/9 but contain
quite useful fixes as well.

I got quite good results with several OxSemi based SBP-2 devices, also
with an Initio based dual-LU device and LSI based devices.  A Prolific
PL-3505 based device with known buggy firmware didn't work too well; I
don't know if (but doubt that) the ieee1394 stack would do better.  My
two TI StorageLynx based devices, both with somewhat quirky firmware as
well, still almost never survive bus resets if there is also I/O.  These
devices don't show such problems with the old stack.

I simply tested HDDs with dd (read only), and CD/DVD-ROM/R/W with
cdparanoia.  The latter sometimes produced audible gaps in the ripped
audio file due to sometimes long blocked I/O when the bus was recovering
from addition or removal of devices.  I think the ability to recover
from such gaps also depends on the optical drive attached to the SBP-2
bridge.  However, dd apparently never had issues with arbitrarily long
I/O pauses.

It has to be noted that I still encountered various weird things while
abusing the hardware, i.e. all of this needs time for testing.  Also, I
don't have a device with multiple logical units beneath the same target
for testing.  The mentioned dual-LU device exposes the LUs in separate
unit directories, i.e. as separate targets.

Combined diffstat and shortlog:

 drivers/firewire/fw-device.c |   28 ++--
 drivers/firewire/fw-sbp2.c   |  224 ++++++++++++++++++++++++++---------
 drivers/ieee1394/sbp2.c      |   12 +
 drivers/ieee1394/sbp2.h      |    2
 4 files changed, 202 insertions(+), 64 deletions(-)

1/9 firewire: log GUID of new devices
2/9 firewire: fw-sbp2: add INQUIRY delay workaround
3/9 ieee1394: sbp2: add INQUIRY delay workaround
4/9 firewire: fw-sbp2: wait for completion of fetch agent reset
5/9 firewire: fw-sbp2: log bus_id at management request failures
6/9 firewire: fw-sbp2: don't add scsi_device twice
7/9 firewire: fw-sbp2: logout and login after failed reconnect
8/9 firewire: fw-sbp2: sort includes
9/9 firewire: fw-sbp2: fix I/O errors during reconnect
-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

