Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYLJFps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYLJFps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYLJFpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:45:38 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:17940 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLJFpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:45:38 -0500
Message-ID: <fa686aa40812092145h72c29ea8o7b55ab6bc0ce52ff@mail.gmail.com>
Date: Tue, 9 Dec 2008 22:45:36 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: How to handle device drivers depending on another device.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scenario: I have an Ethernet device whose driver is probed via the
of_platform bus.  The PHY device is attached to an MDIO bus, but the
MDIO controller hardware is not integrated into the Ethernet device
(separate hardware).  The MDIO bus driver uses phylib.  At probe time,
the Ethernet driver must get a reference to the phy_device structure
in order to set it up and control it.  (Actually, I've got this exact
scenario with 3 different devices on various embedded boards except
using I2C or SPI bus connections.  For simplicity sake I'll stick to
the ETH->MDIO case)

Problem: There are no guarantees that the MDIO bus controller will be
probed before the Ethernet device.
  - If the MDIO bus is probed first, the there is no problem.  The
Ethernet driver can use something like bus_find_device() to locate the
PHY.
  - If the MDIO bus is not probed first, then the PHY is not ready,
and the Ethernet probe function must in some way defer locating the
phy_device until after the MDIO bus is probed.

I'm looking at making the Eth driver register a bus notifier callback
so that it can check each new phy device as it gets registered, but
this is only half a solution because it doesn't get notifications for
PHY devices that are already registered.  To solve this, the driver
could use a use both a notifier and a call to bus_find_device().
However, I'm concerned about a race condition between the two
activities.  If bus_find_device() is called before registering the
notifier, then it theoretically possible for the PHY to be registered
between the two calls and the Eth driver not getting notified.  If the
notifier is registered before the bus_find_device() call, then it is
possible that the Eth driver will get told about a PHY device more
than once if the phy is registered after the notifier, but before
bus_find_device().  I can certainly handle this condition in my
driver, but it seems ugly to me.  Especially so if this is a common
case which would be useful to other drivers (see below).

Here are my questions:
First, is this race condition something I should even be concerned
about (ie. is it more theoretical than practical).  Am I being overly
paranoid in being concerned about it?

Second, does this sound like a common case that would be useful for
more than just a handful of driver that I'm working on?  Specifically,
would it be useful to have an alternate bus_register_notifier()
function which also generated ADD_DEVICE and BOUND_DRIVER
notifications for devices already present?  If others see value in it
then I'll code something up.

Third, let me know if it seems like I'm looking at this problem in the
wrong way.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
