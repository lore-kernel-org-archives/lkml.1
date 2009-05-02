Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbZEBQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbZEBQuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 12:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZEBQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 12:50:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:24815 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZEBQuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 12:50:04 -0400
Message-ID: <49FC7A13.8040807@oracle.com>
Date: Sat, 02 May 2009 09:51:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Lee <lee-in-berlin@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc4: compile fail with CONFIG_DRM_I915=y
References: <49FC4F88.3090403@web.de>
In-Reply-To: <49FC4F88.3090403@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49FC79B8.011A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Hi list,
> 
> compiling 2.6.30-rc4 with following options will result in an compile
> error:
> 
> CONFIG_DRM_I915=y
> CONFIG_ACPI_VIDEO=m
> 
> 
> drivers/video/backlight/backlight.c: In function
> ‘backlight_device_register’:
> drivers/video/backlight/backlight.c:247: warning: format not a string
> literal and no format arguments
> drivers/video/output.c: In function ‘video_output_register’:
> drivers/video/output.c:99: warning: format not a string literal and no
> format arguments
> drivers/usb/storage/libusual.c: In function ‘usu_probe_thread’:
> drivers/usb/storage/libusual.c:159: warning: format not a string literal
> and no format arguments
> drivers/built-in.o: In function `intel_opregion_free':
> (.text+0xaf051): undefined reference to `acpi_video_exit'
> drivers/built-in.o: In function `intel_opregion_init':
> (.text+0xaf411): undefined reference to `acpi_video_register'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/home/randall/kernel-source'
> make: *** [debian/stamp/build/kernel] Error 2
> 
> Compiling the kernel with both options as module or both options
> built-in results in a working kernel.

Len Brown posted a patch to fix this, although I can't find it in
any email archives just now, so I'm appending it below.


-- 

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
