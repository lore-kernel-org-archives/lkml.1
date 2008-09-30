Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYI3DT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYI3DT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYI3DTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:59268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYI3DT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="621752524"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 00/12] e1000e debug and protection patches
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com
Date: Mon, 29 Sep 2008 20:19:16 -0700
Message-ID: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:19:17.0107 (UTC) FILETIME=[523A3C30:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please be warned this is a test series of patches that we are currently
validating, but we wanted to post them sooner than later. this series of
patches implements:

1-2) base kernel code fixes that might be helpful for debugging
3-6) a series of patches to fix some (possible) buglets in eeprom access code
7) a patch that triggered the bugs that were fixed in 3-6, from Thomas
8-9) (what should be) debug helper patches for testers to log to syslog the
     first bytes of the eeprom, that are checksummed at least.
10) protect iomapped memory from write by kernel processes
11) write protect the actual e1000e flash space, add module param to disable[1]
12) update the version so we can tell we're running with this test driver.

# This series applies on GIT commit eaf9e45100b56c18a2236464cadd92d9a3d399ea

Tomorrow we should be able to test and post the eeprom restore patches for
the driver.

[1]  we will follow up tomorrow with a patch that locks the actual flash AND
     the bits used by 11) that requires a full chip reset to unlock, as
     we see a possible way that the iomapped registers could still be poked
     in such a way to unlock the flash space.

I will probably update these again but they seem to work for now.

---

Bruce Allan (3):
      e1000e: write protect ICHx NVM to prevent malicious write/erase
      e1000e: Use set_memory_ro()/set_memory_rw() to protect flash memory
      x86: export set_memory_ro and set_memory_rw

Jesse Barnes (1):
      pci sysfs warning

Jesse Brandeburg (7):
      update version
      e1000e: dump eeprom to dmesg for ich8/9
      e1000e: allow bad checksum
      e1000e: drop stats lock
      e1000e: fix lockdep issues
      e1000e: do not ever sleep in interrupt context
      e1000e: reset swflag after resetting hardware

Thomas Gleixner (1):
      e1000e: debug contention on NVM SWFLAG


 arch/x86/mm/pageattr.c       |    2 +
 drivers/net/e1000e/e1000.h   |    6 +-
 drivers/net/e1000e/ethtool.c |    9 ++
 drivers/net/e1000e/hw.h      |    1 
 drivers/net/e1000e/ich8lan.c |   82 +++++++++++++++++++++
 drivers/net/e1000e/netdev.c  |  167 ++++++++++++++++++++++++++++--------------
 drivers/net/e1000e/param.c   |   30 ++++++++
 drivers/pci/pci-sysfs.c      |   14 ++++
 8 files changed, 255 insertions(+), 56 deletions(-)

-- 
Signature
