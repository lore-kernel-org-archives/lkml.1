Return-Path: <linux-kernel-owner+w=401wt.eu-S970364AbXFHUFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970364AbXFHUFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970892AbXFHUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:04:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:54394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970874AbXFHUEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:04:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andres Salomon <dilinger@debian.org>, Dmitry Torokhov <dtor@mail.ru>,
       Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] update Documentation/driver-model/platform.txt
Date: Fri,  8 Jun 2007 13:04:39 -0700
Message-Id: <11813330832783-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <20070608200407.GA22825@kroah.com>
References: <20070608200407.GA22825@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Make note of the legacy "probe-the-hardware" drivers, and some APIs that
are mostly unused except by such drivers.  We probably can't escape having
legacy drivers for a while (e.g.  old ISA drivers), but we can at least
discourage this style code for new drivers, and unless it's unavoidable.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/platform.txt |   40 +++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
index 19c4a6e..2a97320 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -96,6 +96,46 @@ System setup also associates those clocks with the device, so that that
 calls to clk_get(&pdev->dev, clock_name) return them as needed.
 
 
+Legacy Drivers:  Device Probing
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Some drivers are not fully converted to the driver model, because they take
+on a non-driver role:  the driver registers its platform device, rather than
+leaving that for system infrastructure.  Such drivers can't be hotplugged
+or coldplugged, since those mechanisms require device creation to be in a
+different system component than the driver.
+
+The only "good" reason for this is to handle older system designs which, like
+original IBM PCs, rely on error-prone "probe-the-hardware" models for hardware
+configuration.  Newer systems have largely abandoned that model, in favor of
+bus-level support for dynamic configuration (PCI, USB), or device tables
+provided by the boot firmware (e.g. PNPACPI on x86).  There are too many
+conflicting options about what might be where, and even educated guesses by
+an operating system will be wrong often enough to make trouble.
+
+This style of driver is discouraged.  If you're updating such a driver,
+please try to move the device enumeration to a more appropriate location,
+outside the driver.  This will usually be cleanup, since such drivers
+tend to already have "normal" modes, such as ones using device nodes that
+were created by PNP or by platform device setup.
+
+None the less, there are some APIs to support such legacy drivers.  Avoid
+using these calls except with such hotplug-deficient drivers.
+
+	struct platform_device *platform_device_alloc(
+			char *name, unsigned id);
+
+You can use platform_device_alloc() to dynamically allocate a device, which
+you will then initialize with resources and platform_device_register().
+A better solution is usually:
+
+	struct platform_device *platform_device_register_simple(
+			char *name, unsigned id,
+			struct resource *res, unsigned nres);
+
+You can use platform_device_register_simple() as a one-step call to allocate
+and register a device.
+
+
 Device Naming and Driver Binding
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 The platform_device.dev.bus_id is the canonical name for the devices.
-- 
1.5.2.1

