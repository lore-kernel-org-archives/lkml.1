Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYI2QVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYI2QVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYI2QUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:20:53 -0400
Received: from styx.suse.cz ([82.119.242.94]:54866 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751355AbYI2QUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:20:52 -0400
Date: Mon, 29 Sep 2008 18:20:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <alpine.LNX.1.10.0809291740140.4022@jikos.suse.cz>
Message-ID: <alpine.LNX.1.10.0809291817130.4022@jikos.suse.cz>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251913300.1736@jbrandeb-desk.amr.corp.intel.com>
 <alpine.LNX.1.10.0809291740140.4022@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Jiri Kosina wrote:

> > in case your mailer hoses something apply in this order:
> > # This series applies on GIT commit 011fcfcb75311c7368f13170b9e68adcf146a557
> > 01-e-mem.patch
> > 02-e_flash.patch
> > 03-e1000e-release-lock-in-reset.patch
> > 04-e1000e-dont-sleep.patch
> > 05-e1000e-no-deeplocks.patch
> > 06-e1000e-drop-stats-lock.patch
> > 07-subject-e1000e-debug-patch.patch
> > 08-e1000e-version.patch
> > 09-e1000e-allow-bad-checksum.patch
> > 10-e1000e-dump-eeprom-to-dmesg.txt
> When using this patchset (plus patch that adds check for address range in 
> pci_mmap_resource() by Jesse Barnes), the machine (that already has 
> corrupted (but not completely erased)) hangs after dumping eeprom 
> contents:
> 0000:00:19.0: 0000:00:19.0: The NVM Checksum Is Not Valid
> /*********************/
> Current EEPROM Checksum : 0x2259
> Calculated              : 0xa259
> Offset    Values
> ========  ======
> 00000000: 00 15 58 c6 4a ff 00 08 ff ff 30 00 ff ff ff ff
> 00000010: ff ff ff ff c7 10 b9 20 aa 17 49 10 86 80 00 00
> 00000020: 01 0d 00 00 00 00 05 16 20 50 00 38 00 00 8b 0d
> 00000030: 02 06 c1 01 03 08 00 00 00 00 00 00 00 00 00 00
> 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00000060: 00 01 00 40 28 12 07 40 ff ff ff ff ff ff ff ff
> 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 59 22
> /*********************/
> after this, alt-sysrq-p indicates that it's somehow running in the loops 
> around r1000_read_nvm_ich8lan and e1000_release_swflag_uch8lan. Below 
> there are several subsequent alt-sysrq-p outputs on this frozen system

And I believe that this is because of this code in 
09-e1000e-allow-bad-checksum.patch:

        for (i = 0;; i++) {
                if (e1000_validate_nvm_checksum(hw) >= 0) {
                        /* copy the MAC address out of the NVM */
                        if (e1000e_read_mac_addr(&adapter->hw))
                                e_err("NVM Read Error reading MAC address\n");
                        break;
                }
                if (i == 2) {
                        e_err("The NVM Checksum Is Not Valid\n");
                        e1000e_dump_eeprom(adapter);
                        /*
                         * set MAC address to all zeroes to invalidate and
                         * temporary disable this device for the user. This
                         * blocks regular traffic while still permitting
                         * ethtool ioctls from reaching the hardware as well as
                         * allowing the user to run the interface after
                         * manually setting a hw addr using
                         * `ip link set address`
                         */
                        memset(hw->mac.addr, 0, netdev->addr_len);
                }
        }

We are missing 'break;' after the memset, and that is where the hanging 
machine comes from (the loop keeps spinning forever), right? I will verify 
this right away.

-- 
Jiri Kosina
SUSE Labs
