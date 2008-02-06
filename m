Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYBFFRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYBFFRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 00:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBFFRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 00:17:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbYBFFRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 00:17:36 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/9] firewire-sbp2: misc hotplug related patches
Date: Wed, 6 Feb 2008 00:17:06 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060017.06958.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 05:00:54 pm Stefan Richter wrote:
> Here is various stuff to hopefully improve fw-sbp2's behavior during bus
> resets.  The main piece is patch 9/9 which considerably raises the
> chance that ongoing I/O survives plugging and unplugging of other
> devices on the same bus as the device which services the I/O.
>
> The other patches are basically side products of patch 9/9 but contain
> quite useful fixes as well.
>
> I got quite good results with several OxSemi based SBP-2 devices

I've got one setup on which this doesn't seem to help much... Two firewire 
drives (both ox911 bridge, v4.0 firmware) hooked to a system, both of which 
are recognized, logged into, etc., on startup. However, pretty much without 
fail, at least one of them has to perform a reconnection. That claims to 
succeed, but the device isn't actually usable when this happens -- 
fdisk /dev/sdx fails with 'unable to read /dev/sdx'.

Example dmesg output when one of the two drives has to be reconnected:

firewire_core: created device fw0: GUID 00023c0031037366, S400
scsi6 : SBP-2 IEEE-1394
firewire_core: created device fw1: GUID 0050c501e001c394, S400
firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
firewire_core: phy config: card 0, new root=ffc1, gap_count=5
scsi 6:0:0:0: Direct-Access-RBC ST312002 6A               8.01 PQ: 0 ANSI: 4
firewire_core: created device fw2: GUID 000108000000f605, S800
sd 6:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 6:0:0:0: [sdc] Write Protect is off
sd 6:0:0:0: [sdc] Mode Sense: 00 00 00 00
sd 6:0:0:0: [sdc] Asking for cache data failed
firewire_core: created device fw3: GUID 0000d10080a575eb, S400
sd 6:0:0:0: [sdc] Assuming drive cache: write through
sd 6:0:0:0: [sdc] READ CAPACITY failed
sd 6:0:0:0: [sdc] Result: hostbyte=DID_BUS_BUSY 
driverbyte=DRIVER_OK,SUGGEST_OK
sd 6:0:0:0: [sdc] Sense not available.
sd 6:0:0:0: [sdc] Write Protect is off
sd 6:0:0:0: [sdc] Mode Sense: 00 00 00 00
sd 6:0:0:0: [sdc] Asking for cache data failed
sd 6:0:0:0: [sdc] Assuming drive cache: write through
sd 6:0:0:0: [sdc] Attached SCSI disk
scsi7 : SBP-2 IEEE-1394
firewire_sbp2: fw1.0: reconnected to LUN 0000 (0 retries)
firewire_core: created device fw4: GUID 0050c501e00b23e9, S400
firewire_core: phy config: card 2, new root=ffc1, gap_count=5
firewire_sbp2: fw4.0: logged in to LUN 0000 (0 retries)
scsi 7:0:0:0: Direct-Access-RBC ST312002 2A               8.01 PQ: 0 ANSI: 4
sd 7:0:0:0: [sdd] 234441648 512-byte hardware sectors (120034 MB)
sd 7:0:0:0: [sdd] Write Protect is off
sd 7:0:0:0: [sdd] Mode Sense: 11 00 00 00
sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 7:0:0:0: [sdd] 234441648 512-byte hardware sectors (120034 MB)
sd 7:0:0:0: [sdd] Write Protect is off
sd 7:0:0:0: [sdd] Mode Sense: 11 00 00 00
sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdd: sdd1
sd 7:0:0:0: [sdd] Attached SCSI disk

fw device decoder ring:
fw0 = fw400 card
fw1 = /dev/sdc (120G HD in ox911 case, hooked to fw0)
fw2 = fw800 card
fw3 = fw400 card
fw4 = /dev/sdd (120G HD in ox911 case, hooked to fw3)


# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [raid0] 
md4 : active raid1 sdd1[1]
      117218176 blocks [2/1] [_U]

# fdisk /dev/sdc

Unable to read /dev/sdc


Given the READ CAPACITY failed and DID_BUS_BUSY messages for sdc (and lack of 
notice about its partitions), it sort of looks like we never set the disk up 
correctly in the first place, and we're subsequently just reconnecting to 
that failed setup... So the reconnect code may be doing the right thing, and 
the real problem I'm looking at is us screwing up the setup of the device in 
the first place, for some reason...


-- 
Jarod Wilson
jwilson@redhat.com
