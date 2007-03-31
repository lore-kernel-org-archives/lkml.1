Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbXCaWMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbXCaWMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 18:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXCaWMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 18:12:13 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:39493 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752635AbXCaWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 18:12:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ybs+ulmA//Woq2oFVIhr3ooFhHluAjjtkb7XWRmyW6HhoilGiYNzZdgWjSaWGpxQ+u1tedRjMZHGFHOYzIXJhyPzb13xwYVkROdWqICshgd17VeNOPslXRgAIonjgvF26iD4AMgfnL2YYnsBUd1TrAcYUgPFAIbTVObQeYYi4Vc=  ;
X-YMail-OSG: zz9R930VM1mcVbd0kRruv__4KFLgG687URavt3EX69NTXBhC
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc5-git 2/2] update Documentation/driver-model/platform.txt
Date: Sat, 31 Mar 2007 14:58:43 -0700
User-Agent: KMail/1.7.1
Cc: Andres Salomon <dilinger@debian.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311458.43800.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make note of the legacy "probe-the-hardware" drivers, and some APIs that are
mostly unused except by such drivers.  We probably can't escape having legacy
drivers for a while (e.g. old ISA drivers), but we can at least discourage
this style code for new drivers, and unless it's unavoidable.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/Documentation/driver-model/platform.txt	2007-03-31 14:26:14.000000000 -0700
+++ g26/Documentation/driver-model/platform.txt	2007-03-31 14:49:42.000000000 -0700
@@ -96,6 +96,46 @@ System setup also associates those clock
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
