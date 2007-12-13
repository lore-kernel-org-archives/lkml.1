Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbXLNADZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbXLNADZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765600AbXLNADG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:03:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:21917 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765038AbXLNADC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:03:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="437649903"
Message-Id: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:43 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/12] PAT 64b: PAT support for X86_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. It is that wonderful time of the year again.
No, no. We are not talking about holiday season or new year here.

We are talking about one another rehash of "why we do not support PAT in x86"
question and series of patches that implement some PAT support before going
into hibernation again. Only difference is that we hope to take this little
further this time and may be really get this support into
upstream kernel soon.


This series is heavily derived from the PAT patchset by Eric Biederman and
Andi Kleen.
http://www.firstfloor.org/pub/ak/x86_64/pat/

We have forwarded ported these patches to latest kernel, addressed some of the
race conditions, cut a lot more corners to get this into a working patchset
that can be seen as an RFC. Specifically, the chanegs we added include:

* Various bug fixes over original patchset above.
* Change x86_64 identity map to only map non-reserved memory. This helps
  to handle UC/WC mapping of reserved region in a much simple manner
  (we don't have to do cpa any more, as such not keep track of the actual
   reference counts. We still  track all the usages to keep the mappings
   consistent. We just avoid the headache of splitting mattr regions for
   managing ref counts for every individual usage of the reserved area).
* Modify reserve_mattr and free_mattr to handle various mapping of reserved 
  regions cleanly.


There are many rough edges in the patchset. TBD list below refers to
the open issues that we have thought through during this process. 

TBD:
* Do we need to allow RAM pages to be mapped as WC? If not, then
  we don't need to follow the TLB flush mechanism (make pte not present,
  flush, and set pte with new mapping) mentioned in section 10.12.4 of SDM
  Vol3a.
* If the above can be assumed, then for a complete solution, handle RAM
  pages with UC and /dev/mem mapping conflicts.
  Can we use the existing page struct to keep track of the /dev/mem
  mappings (through the page ref count) and not allow
  to free the page while the /dev/mem mappings are active. And
  allow /dev/mem to map only those pages which are marked reserved (which
  the driver does before doing iomap).
* For X and others, do we need the ioctl interface to sysfs or get the type
  attribute through a different sysfs file.
* Clean up early table space allocation, avoiding overallocation there.
* Avoid mapping 0 - 1M physical addresses in kernel text mapping.
* Read reserved regions in /dev/mem read() as 0xffff or something, and continue
  reading across holes, till we reach the high_memory (end of memory).
* For fork(), for every /dev/mem mapping, we have to keep track of the usage
  by doing reserve_mattr().

There are also many edges completely missing. Lot of things we did not look
at all for this first cut. Specifically:

* Only supports x86_64 for now. i386 may not even compile with this patchset.
* We did not look at implication of PAT on Suspend-Resume.
* We did not look at implications of PAT on KEXEC.
* Coding style details.

We expect this can be done easily once we have discussed/resolved the
basic PAT problems with this RFC.


Fireaway all comments, complaints, concerns and things we may break while
we do this.

Tested with 2.6.24-rc4 and X86_64.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

-- 
