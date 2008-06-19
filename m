Return-Path: <linux-kernel-owner+w=401wt.eu-S1751151AbYFSEmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbYFSEmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 00:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYFSEmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 00:42:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41745 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYFSEla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 00:41:30 -0400
Date: Thu, 19 Jun 2008 05:41:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp patches for 2.6.26 final
Message-ID: <alpine.DEB.0.82.0806190538490.14089@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

This contains a fix for a mapping race from Jan, some pci ids from via 
via Greg, Intel bugfix + new pci ids, and bool/whitespace cleanups.

Dave.

 drivers/char/agp/agp.h          |    6 +-
 drivers/char/agp/alpha-agp.c    |    4 +-
 drivers/char/agp/amd-k7-agp.c   |    4 +-
 drivers/char/agp/amd64-agp.c    |    4 +-
 drivers/char/agp/ati-agp.c      |    4 +-
 drivers/char/agp/backend.c      |   16 ++--
 drivers/char/agp/compat_ioctl.c |    2 +-
 drivers/char/agp/efficeon-agp.c |    6 +-
 drivers/char/agp/frontend.c     |   12 +-
 drivers/char/agp/generic.c      |   35 +++---
 drivers/char/agp/hp-agp.c       |    6 +-
 drivers/char/agp/i460-agp.c     |    2 +-
 drivers/char/agp/intel-agp.c    |  235 +++++++++++++++++++++++++--------------
 drivers/char/agp/nvidia-agp.c   |    4 +-
 drivers/char/agp/parisc-agp.c   |    6 +-
 drivers/char/agp/sgi-agp.c      |    8 +-
 drivers/char/agp/sworks-agp.c   |    6 +-
 drivers/char/agp/uninorth-agp.c |   10 +-
 drivers/char/agp/via-agp.c      |   13 ++-
 include/linux/agp_backend.h     |   16 +--
 include/linux/agpgart.h         |    4 +-
 21 files changed, 235 insertions(+), 168 deletions(-)

commit 62c96b9d0917894c164aa3e474a3ff3bca1554ae
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jun 19 14:27:53 2008 +1000

    agp/intel: cleanup some serious whitespace badness
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 25ce77abf8be3a96b3673e46722a9bd05f149584
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Thu Jun 19 14:17:58 2008 +1000

    [AGP] intel_agp: Add support for Intel 4 series chipsets
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 598d14482380312939a3e3a4ae0657eb6b50a532
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Thu Jun 19 14:00:37 2008 +1000

    [AGP] intel_agp: extra stolen mem size available for IGD_GM chipset
    
    This adds missing stolen memory size detect for IGD_GM, be sure to
    detect right size as current X intel driver (2.3.2) which has already
    worked out.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9516b030b484fc99cf24213caf88df01f99248dd
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jun 19 10:42:17 2008 +1000

    agp: more boolean conversions.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c72580129209aaa509ace81c1f2ee1caa9c9774b
Author: Joe Perches <joe@perches.com>
Date:   Wed Mar 26 14:10:02 2008 -0700

    drivers/char/agp - use bool
    
    Use boolean in AGP instead of having own TRUE/FALSE
    
    --
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit da503fa60b84d5945deb3ab74efdd0bec61df4a1
Author: Jan Beulich <jbeulich@novell.com>
Date:   Wed Jun 18 09:28:00 2008 +0100

    agp: two-stage page destruction issue
    
    besides it apparently being useful only in 2.6.24 (the changes in 2.6.25
    really mean that it could be converted back to a single-stage mechanism),
    I'm seeing an issue in Xen Dom0 kernels, which is caused by the calling
    of gart_to_virt() in the second stage invocations of the destroy function.
    I think that besides this being a real issue with Xen (where
    unmap_page_from_agp() is not just a page table attribute change), this
    also is invalid from a theoretical perspective: One should not assume that
    gart_to_virt() is still valid after unmapping a page. So minimally (keeping
    the 2-stage mechanism) a patch like the one below would be needed.
    
    Jan
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dcd981a77b2b35d169656d4b9cee208096ed7ccf
Author: Greg KH <gregkh@suse.de>
Date:   Thu Jun 19 09:52:26 2008 +1000

    agp/via: fixup pci ids
    
    add a new PCI ID and remove an old dodgy one, include the explaination
    in the commented code so nobody readds later.
    
    (davej also sent the pci id addition).
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
