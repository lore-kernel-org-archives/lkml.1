Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYHLASi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYHLASi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYHLASa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:18:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39058 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYHLAS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:18:29 -0400
Date: Tue, 12 Aug 2008 01:18:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.27-rc3
Message-ID: <alpine.DEB.0.82.0808120117000.31598@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

I either decided to leave these in linux-next for a week and forgot about 
them or forgot about them in the first place. The biggest bit is better 
suspend/resume support for Intel AGP.

Dave.

 drivers/char/agp/agp.h          |    3 +
 drivers/char/agp/ali-agp.c      |   10 ++--
 drivers/char/agp/amd-k7-agp.c   |   10 ++--
 drivers/char/agp/amd64-agp.c    |   51 ++++++++++++++---------
 drivers/char/agp/ati-agp.c      |    7 +--
 drivers/char/agp/backend.c      |   28 ++++++++-----
 drivers/char/agp/generic.c      |   41 +++++++++++++++----
 drivers/char/agp/intel-agp.c    |   83 ++++++++++++++++++++++-----------------
 drivers/char/agp/isoch.c        |   37 +++++++++--------
 drivers/char/agp/sis-agp.c      |   17 ++++----
 drivers/char/agp/sworks-agp.c   |   25 ++++++------
 drivers/char/agp/uninorth-agp.c |   32 +++++++-------
 include/linux/agp_backend.h     |    5 ++
 13 files changed, 205 insertions(+), 144 deletions(-)

commit 91397585e3fb47b3900e17d70c6edc356e36bb46
Author: Krzysztof Helt <krzysztof.h1@wp.pl>
Date:   Wed Aug 6 18:48:45 2008 +0200

    agp: fix SIS 5591/5592 wrong PCI id
    
    The correct id is the id of the main host (5591) not
    the id of the PCI-to-PCI bridge AGP (0001).
    Output from "lspci -nv" shows that only the former
    has AGP capabilities flag set:
    
    00:00.0 0600: 1039:5591 (rev 02)
            Flags: bus master, medium devsel, latency 64
            Memory at ec000000 (32-bit, non-prefetchable) [size=32M]
            Capabilities: [c0] AGP version 1.0
    
    00:02.0 0604: 1039:0001 (prog-if 00 [Normal decode])
            Flags: bus master, fast devsel, latency 0
            Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
            I/O behind bridge: 0000c000-0000cfff
            Memory behind bridge: eb500000-eb5fffff
            Prefetchable memory behind bridge: eb300000-eb3fffff
    
    Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a8c84df9f71e4a7b14bdd41687a70d366c087eef
Author: Keith Packard <keithp@keithp.com>
Date:   Thu Jul 31 15:48:07 2008 +1000

    intel/agp: rewrite GTT on resume
    
    On my Intel chipset (965GM), the GTT is entirely erased across
    suspend/resume.  This patch simply re-plays the current mapping at resume
    time to restore the table.=20
    
    I noticed this once I started relying on persistent GTT mappings across VT
    switch in our GEM work -- the old X server and DRM code carefully unbind
    all memory from the GTT on VT switch, but GEM does not bother.
    
    I placed the list management and rewrite code in the generic layer on the
    assumption that it will be needed on other hardware, but I did not add the
    rewrite call to anything other than the Intel resume function.
    
    Keep a list of current GATT mappings.  At resume time, rewrite them into
    the GATT.  This is needed on Intel (at least) as the entire GATT is
    cleared across suspend/resume.
    
    [akpm@linux-foundation.org: coding-style fixes]
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Cc: Dave Jones <davej@codemonkey.org.uk>
    Cc: Andi Kleen <andi@firstfloor.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e3cf69511a2c5369c58f6fd6a065de152c3d4b22
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Jul 30 12:26:51 2008 -0700

    agp: use dev_printk when possible
    
    Convert printks to use dev_printk().
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 55814b74c95a73dae6795e167294e6edc733aae9
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Jul 30 12:26:51 2008 -0700

    amd64-agp: run fallback when no bridges found, not when driver registration fails
    
    I think the intent was that if no bridges matched agp_amd64_pci_table[],
    we would fall back to checking for any bridge with the AGP capability.
    But in the current code, we execute the fallback path only when
    pci_register_driver() itself fails, which is unrelated to whether any
    matching devices were found.
    
    This patch counts the AGP bridges found in the probe() method and executes
    the fallback path when none is found.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 99d32bd5c7b1caa05d1fe3c89b08aabd459bc12a
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Wed Jul 30 12:26:50 2008 -0700

    intel_agp: official name for GM45 chipset
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
