Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYBEFjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYBEFjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYBEFi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:38:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41498 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYBEFiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:38:55 -0500
Date: Tue, 5 Feb 2008 05:38:52 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.25
Message-ID: <alpine.DEB.0.82.0802050537430.11259@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

It adds initial support for chipset flushing along with some intel pciids.

Dave.

 arch/x86/pci/i386.c             |    2 +-
 drivers/char/agp/agp.h          |    6 +-
 drivers/char/agp/amd-k7-agp.c   |    4 -
 drivers/char/agp/backend.c      |    2 +-
 drivers/char/agp/compat_ioctl.c |    4 +
 drivers/char/agp/compat_ioctl.h |    2 +
 drivers/char/agp/frontend.c     |   13 ++-
 drivers/char/agp/generic.c      |    7 +
 drivers/char/agp/intel-agp.c    |  305 +++++++++++++++++++++++++++++++--------
 include/linux/agp_backend.h     |    1 +
 include/linux/agpgart.h         |    1 +
 11 files changed, 276 insertions(+), 71 deletions(-)

commit bc894606e8843808c232319f69c26c18f6eaa662
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Feb 5 15:05:23 2008 +1000

    agp: remove flush_agp_mappings calls from new flush handling code
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f011ae7437761dc071b4154cabb0041df041a7c0
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jan 25 11:23:04 2008 +1000

    intel-agp: introduce IS_I915 and do some cleanups..
    
    Add a new IS_I915 and also do some checkpatch whitespace cleanups.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9119f85a0cdbac0397b39fa198866bf530cfab8b
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Wed Jan 23 15:49:26 2008 +1000

    [intel_agp] fix name for G35 chipset
    
    Change origin chipset name i965G_1 to market name G35.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4d64dd9e5d96cdcfa8dee91c7848341718c77444
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jan 23 15:34:29 2008 +1000

    intel-agp: fixup resource handling in flush code.
    
    The flush code resource handling was having problems where some BIOS
    reserve the resource in a pnp block and some don't.
    
    Also there was a bug in that configure was being called at resume
    and resetting some of the structs.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4e8b6e25943a22036a6b704ebef634c7dec4c10e
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Wed Jan 23 14:54:37 2008 +1000

    intel-agp: add new chipset ID
    
    This one adds new pci ids for Intel intergrated graphics chipset, with gtt
    table access change on it and new gtt table size definition.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 91d361c279b66ce4d617d544641d5f70b27c401a
Author: Julia Lawall <julia@diku.dk>
Date:   Wed Dec 5 13:55:36 2007 -0800

    agp: remove unnecessary pci_dev_put
    
    pci_get_class implicitly does a pci_dev_put on its second argument, so
    pci_dev_put is only needed if there is a break out of the loop.
    
    The semantic match detecting this problem is as follows:
    
    // <smpl>
    @@
    expression dev;
    expression E;
    @@
    
    * pci_dev_put(dev)
      ... when != dev = E
    (
    * pci_get_device(...,dev)
    |
    * pci_get_device_reverse(...,dev)
    |
    * pci_get_subsys(...,dev)
    |
    * pci_get_class(...,dev)
    )
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Cc: Dave Jones <davej@codemonkey.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 62f29babbc60ab572d3cecda981931d3a66123d6
Author: serue@us.ibm.com <serue@us.ibm.com>
Date:   Wed Dec 5 13:55:36 2007 -0800

    agp: remove uid comparison as security check
    
    In the face of containers and user namespaces, a uid==0 check for
    security is not safe.  Switch to a capability check.
    
    I'm not sure I picked the right capability, but this being AGP
    CAP_SYS_RAWIO seemed to make sense.
    
    Signed-off-by: Serge Hallyn <serue@us.ibm.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 1fa4db7d308da04f6644c5cb8eed244c200d4ed5
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Nov 29 10:00:48 2007 +1000

    fix AGP warning
    
    drivers/char/agp/intel-agp.c: In function 'intel_i965_g33_setup_chipset_flush':
    drivers/char/agp/intel-agp.c:872: warning: right shift count >= width of type
    
    I wish the agp code wasn't written in a 10,000-column xterm :(
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2162e6a2b0cd5acbb9bd8a3c94e1c1269b078295
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Nov 21 16:36:31 2007 +1000

    agp/intel: Add chipset flushing support for i8xx chipsets.
    
    This is a bit of a large hammer but it makes sure the chipset is flushed
    by writing out 1k of data to an uncached page. We may be able to get better
    information in the future on how to this better.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6c00a61e1bc969c3ea931f62f8789d9818bf1918
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Oct 29 18:06:10 2007 +1000

    intel-agp: add chipset flushing support
    
    This adds support for flushing the chipsets on the 915, 945, 965 and G33
    families of Intel chips.
    
    The BIOS doesn't seem to always allocate the BAR on the 965 chipsets
    so I have to use pci resource code to create a resource
    
    It adds an export for pcibios_align_resource.

commit a13af4b4d842da6d7065b8c73fa8f0ac58fea1b6
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Oct 29 15:14:03 2007 +1000

    agp: add chipset flushing support to AGP interface
    
    This bumps the AGP interface to 0.103.
    
    Certain Intel chipsets contains a global write buffer, and this can require
    flushing from the drm or X.org to make sure all data has hit RAM before
    initiating a GPU transfer, due to a lack of coherency with the integrated
    graphics device and this buffer.
    
    This just adds generic support to the AGP interfaces, a follow-on patch
    will add support to the Intel driver to use this interface.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
