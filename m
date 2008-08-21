Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYHURPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYHURPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYHURPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:15:00 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:58370 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYHURO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:14:59 -0400
Message-ID: <48ADA2C2.8090905@keyaccess.nl>
Date: Thu, 21 Aug 2008 19:15:46 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu>
In-Reply-To: <20080821120626.GG5615@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------040906020306090709010609"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040906020306090709010609
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 21-08-08 14:06, Ingo Molnar wrote:

> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
>> BTW, Rene: Did the patch from yday, caching the last list add, help in 
>> eliminating the slowdown in X startup?

Yes, it does. I was reluctant to say so as I feel it works around the 
problem instead of solving it but yes, it does (free_memtype() would 
need a similar entry cache for shutdown).

> Would be nice to test tip/master - it has both that patch included and 
> the latest pageattr-array API (with enablement in AGP drivers) patchset, 
> done by Shaohua Li, based on Dave's original patch.

That patch by itself doesn't help any -- the new set_memory_array_uc() 
still calls reserve_memtype() for each single page in the array. To 
help, it needs to coalesce adjacent entries, which is itself easy to do 
were it not for the need to keep the list of reserved (base,end) pairs 
around for free_memtype() time (and halfway fail time).

Also just now looked at multipage allocs in AGP but that has the same 
issue really -- if you do multipage allocs, you then need to keep the 
list of regions around for free time.

With worst case lists of AGPSize / 4K entries, this is not nice either 
(althought worst case is veryvery much worst and unlikely and best case 
is a 1 entry list).

Should PAT just coalesce the memtype list itself?

Rene.

P.S.

The pageattr-array patch that you currently have in tip/master only 
enables it for intel-agp, not the others. The attached enables it for 
all drivers currently directly using agp_generic_alloc_page() and 
agp_generic_destroy_page() (ocal driver is amd-k7-agp).


--------------040906020306090709010609
Content-Type: text/plain;
 name="0001-AGP-make-AGP-drivers-use-new-generic_alloc_pages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-AGP-make-AGP-drivers-use-new-generic_alloc_pages.patch"

>From c7f1e98ee8796ca2812363e88dc9ffbf9020528b Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Thu, 21 Aug 2008 19:06:36 +0200
Subject: [PATCH] AGP: make AGP drivers use new generic_alloc_pages() interface

The new agp_generic_alloc_pages() interface uses the also new
pageattr array interface API. This makes all AGP drivers that
up to now used generic_{alloc,destroy}_page() use it.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/char/agp/alpha-agp.c    |    2 ++
 drivers/char/agp/amd-k7-agp.c   |    2 ++
 drivers/char/agp/amd64-agp.c    |    2 ++
 drivers/char/agp/ati-agp.c      |    2 ++
 drivers/char/agp/efficeon-agp.c |    2 ++
 drivers/char/agp/hp-agp.c       |    2 ++
 drivers/char/agp/i460-agp.c     |    2 ++
 drivers/char/agp/nvidia-agp.c   |    2 ++
 drivers/char/agp/parisc-agp.c   |    2 ++
 drivers/char/agp/sis-agp.c      |    2 ++
 drivers/char/agp/sworks-agp.c   |    2 ++
 drivers/char/agp/uninorth-agp.c |    4 ++++
 drivers/char/agp/via-agp.c      |    4 ++++
 13 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/alpha-agp.c b/drivers/char/agp/alpha-agp.c
index 5da89f6..5ea4da8 100644
--- a/drivers/char/agp/alpha-agp.c
+++ b/drivers/char/agp/alpha-agp.c
@@ -143,7 +143,9 @@ struct agp_bridge_driver alpha_core_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index e280531..603a986 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -386,7 +386,9 @@ static const struct agp_bridge_driver amd_irongate_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 7495c52..2812ee2 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -224,7 +224,9 @@ static const struct agp_bridge_driver amd_8151_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 6ecbcaf..ae2791b 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -418,7 +418,9 @@ static const struct agp_bridge_driver ati_generic_bridge = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 8ca6f26..453543a 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -335,7 +335,9 @@ static const struct agp_bridge_driver efficeon_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index 80d7317..183ac3f 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -435,7 +435,9 @@ const struct agp_bridge_driver hp_zx1_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 };
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index e587eeb..10da687 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -575,7 +575,9 @@ const struct agp_bridge_driver intel_i460_driver = {
 	.insert_memory		= i460_insert_memory_small_io_page,
 	.remove_memory		= i460_remove_memory_small_io_page,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 #endif
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index eaceb61..dc70d37 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -312,7 +312,9 @@ static const struct agp_bridge_driver nvidia_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 8c42dcc..f2492ec 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -224,7 +224,9 @@ static const struct agp_bridge_driver parisc_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 };
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 2587ef9..6c3837a 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -140,7 +140,9 @@ static struct agp_bridge_driver sis_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 2fb27fe..6224df8 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -437,7 +437,9 @@ static const struct agp_bridge_driver sworks_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index eef7270..2accc97 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -509,7 +509,9 @@ const struct agp_bridge_driver uninorth_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 };
@@ -534,7 +536,9 @@ const struct agp_bridge_driver u3_agp_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_paged	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
 	.needs_scratch_page	= true,
diff --git a/drivers/char/agp/via-agp.c b/drivers/char/agp/via-agp.c
index 7b36476..9f4d49e 100644
--- a/drivers/char/agp/via-agp.c
+++ b/drivers/char/agp/via-agp.c
@@ -190,7 +190,9 @@ static const struct agp_bridge_driver via_agp3_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
@@ -214,7 +216,9 @@ static const struct agp_bridge_driver via_driver = {
 	.alloc_by_type		= agp_generic_alloc_by_type,
 	.free_by_type		= agp_generic_free_by_type,
 	.agp_alloc_page		= agp_generic_alloc_page,
+	.agp_alloc_pages	= agp_generic_alloc_pages,
 	.agp_destroy_page	= agp_generic_destroy_page,
+	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
-- 
1.5.5


--------------040906020306090709010609--
