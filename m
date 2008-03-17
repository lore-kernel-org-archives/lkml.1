Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYCQSnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYCQSnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYCQSnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:43:45 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:45497 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYCQSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:43:44 -0400
Date: Mon, 17 Mar 2008 19:43:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] thermal: fix Kconfig dependencies
Message-ID: <20080317184339.GA3754@osiris.boeblingen.de.ibm.com>
References: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803170953210.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803170953210.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 09:55:13AM -0700, Linus Torvalds wrote:
> On Mon, 17 Mar 2008, Heiko Carstens wrote:
> > 
> > Change the select to a depends on to fix this. Should work as well.
> 
> Nope, that doesn't work. ACPI_THERMAL will select THERMAL, so now you have 
> THERMAL selected without HWMON.

Oh, missed that. Sorry.
 
> As a minimal fix, you'd at least need to make ACPI_THERMAL depend on 
> THERMAL too.

Updated patch:

Subject: [PATCH] thermal: fix Kconfig dependencies

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9
"thermal: fix generic thermal I/F for hwmon" adds a select HWMON
to THERMAL. This causes HWMON to be selected regardless of its
other dependencies. In this case depends on HAS_IOMEM gets ignored
which causes this build error on s390:

drivers/hwmon/w83627hf.c: In function 'superio_outb':
drivers/hwmon/w83627hf.c:117: error: implicit declaration of function 'outb'

Change the select to a depends on. In addition change the select THERMAL
from ACPI_THERMAL to a depends on THERMAL. Otherwise THERMAL
could be selected by ACPI_THERMAL without HWMON being selected.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/acpi/Kconfig    |    3 +--
 drivers/thermal/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/thermal/Kconfig
===================================================================
--- linux-2.6.orig/drivers/thermal/Kconfig
+++ linux-2.6/drivers/thermal/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig THERMAL
 	bool "Generic Thermal sysfs driver"
-	select HWMON
+	depends on HWMON
 	default y
 	help
 	  Generic Thermal Sysfs driver offers a generic mechanism for
Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -187,8 +187,7 @@ config ACPI_HOTPLUG_CPU
 
 config ACPI_THERMAL
 	tristate "Thermal Zone"
-	depends on ACPI_PROCESSOR
-	select THERMAL
+	depends on ACPI_PROCESSOR && THERMAL
 	default y
 	help
 	  This driver adds support for ACPI thermal zones.  Most mobile and
