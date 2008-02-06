Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYBFS1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYBFS1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYBFS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:27:13 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54227 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYBFS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:27:11 -0500
Message-ID: <47A9FBFD.50100@s5r6.in-berlin.de>
Date: Wed, 06 Feb 2008 19:27:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] firewire-sbp2: misc hotplug related patches
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <200802060017.06958.jwilson@redhat.com>
In-Reply-To: <200802060017.06958.jwilson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> scsi 6:0:0:0: Direct-Access-RBC ST312002 6A               8.01 PQ: 0 ANSI: 4
> firewire_core: created device fw2: GUID 000108000000f605, S800
> sd 6:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
> sd 6:0:0:0: [sdc] Write Protect is off
> sd 6:0:0:0: [sdc] Mode Sense: 00 00 00 00
> sd 6:0:0:0: [sdc] Asking for cache data failed
> firewire_core: created device fw3: GUID 0000d10080a575eb, S400
> sd 6:0:0:0: [sdc] Assuming drive cache: write through
> sd 6:0:0:0: [sdc] READ CAPACITY failed
> sd 6:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY 
> driverbyte=DRIVER_OK,SUGGEST_OK
> sd 6:0:0:0: [sdc] Sense not available.
> sd 6:0:0:0: [sdc] Write Protect is off
> sd 6:0:0:0: [sdc] Mode Sense: 00 00 00 00
> sd 6:0:0:0: [sdc] Asking for cache data failed
> sd 6:0:0:0: [sdc] Assuming drive cache: write through
> sd 6:0:0:0: [sdc] Attached SCSI disk
> scsi7 : SBP-2 IEEE-1394
> firewire_sbp2: fw1.0: reconnected to LUN 0000 (0 retries)
> firewire_core: created device fw4: GUID 0050c501e00b23e9, S400
[...]
> # fdisk /dev/sdc
> 
> Unable to read /dev/sdc
> 
> 
> Given the READ CAPACITY failed and DID_BUS_BUSY messages for sdc (and lack of 
> notice about its partitions), it sort of looks like we never set the disk up 
> correctly in the first place, and we're subsequently just reconnecting to 
> that failed setup... So the reconnect code may be doing the right thing, and 
> the real problem I'm looking at is us screwing up the setup of the device in 
> the first place, for some reason...

What happens is that the 2nd disk resets the bus while fw-sbp2 executes
__scsi_add_device in sbp2_login.  sbp2_reconnect would be necessary
immediately, but it can't run in parallel with sbp2_login... yet.

Kristian already had a solution for the case that __scsi_add_device
fails due to a bus reset or something else.  Just recently I added a
failover for the case that __scsi_add_device returns with alleged
success but leaves the scsi_device in offline state.  In your case,
__scsi_add_device returns with "succeeds" as well but the results of the
sd driver's probing aren't quite useful, even though the device was not
put offline in the process.

As a minimally invasive fix for setups like yours, we have to make
__scsi_add_device fail if the bus generation changed.  I will try
something later today.
-- 
Stefan Richter
-=====-==--- --=- --==-
http://arcgraph.de/sr/
