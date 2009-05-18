Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZERTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZERTLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZERTLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:11:01 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:27468 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZERTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:11:00 -0400
Date: Mon, 18 May 2009 12:11:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Zorael <zorael@gmail.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [i915] Kernel does not compile when set to use i915 kernel
 mode-setting per default (CONFIG_DRM_I915_KMS=y)
Message-Id: <20090518121140.d0bacafd.randy.dunlap@oracle.com>
In-Reply-To: <200905182101.06511.rjw@sisk.pl>
References: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com>
	<200905182101.06511.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A11B25F.0244:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 21:01:06 +0200 Rafael J. Wysocki wrote:

> Adding CCs.
> 
> On Monday 18 May 2009, you wrote:
> > (First post, so please CC to zorael@gmail.com in case it doesn't automatically.)
> > 
> > 
> > I'm trying to compile 2.6.30-rc6 to enable kernel mode-setting *per
> > default*, for my Intel 945GME video chipset. Alas, when compiling, it
> > halts with the following tidbit:
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `intel_opregion_free':
> > /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:422: undefined
> > reference to `acpi_video_exit'
> > drivers/built-in.o: In function `intel_opregion_init':
> > /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:393: undefined
> > reference to `acpi_video_register'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make[1]: Leaving directory `/usr/src/linux-2.6.29'
> > make: *** [debian/stamp/build/kernel] Error 2
> > 
> > 
> > grepping acpi_video_register recursively I see it's defined as an
> > empty function in ./include/acpi/video.h, and as a more proper
> > function in ./drivers/acpi/video.c. Does somehow setting it to use KMS
> > per default via CONFIG_DRM_I915_KMS=y stop it from reading those
> > files?
> > 
> > I used to run with KMS by default in the early -30rc*s, but at some
> > point (rc2?), it stopped compiling succesfully. If I don't enable it
> > per default, it *does* compile, though I don't know how to explicitly
> > enable it at boot-time. So I'm living without KMS for the time being.
> > Woe.
> > 
> > Anything obvious I'm doing wrong?


Len posted a patch for this.  It's below.
Len, do you have this patch queued for Linus?

---
From: Len Brown <len.brown@intel.com>
Subject: [PATCH] ACPI, i915: build fix

drivers/built-in.o: In function `intel_opregion_init':
(.text+0x9d540): undefined reference to `acpi_video_register'

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/gpu/drm/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 3a22eb9..f33d252 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -83,6 +83,12 @@ config DRM_I915
 config DRM_I915_KMS
 	bool "Enable modesetting on intel by default"
 	depends on DRM_I915
+	# i915 KMS depends on ACPI_VIDEO when ACPI is enabled
+	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
+	select VIDEO_OUTPUT_CONTROL if ACPI
+	select BACKLIGHT_CLASS_DEVICE if ACPI
+	select INPUT if ACPI
+	select ACPI_VIDEO if ACPI
 	help
 	  Choose this option if you want kernel modesetting enabled by default,
 	  and you have a new enough userspace to support this. Running old
-- 
