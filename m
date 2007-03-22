Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbXCVSNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbXCVSNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934178AbXCVSNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:13:05 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:36574 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934176AbXCVSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:13:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4ZPBLnPVlhA7+VrHOLHP4VIWLKtFTZyVXS9JC8hNxd1RbYpA+zGnrNTsygApzlIrwBl2hAilVnYLc4qBIggEi2jgj8ztMnjduMwcXQxHANt+ujeDeE/uL9ElSEuFKQ04Me53Rxi9lqMhJcr3VkJ+zX6ue8KIqv25X+fAipfw+s8=  ;
X-YMail-OSG: RRdE2mMVM1n3EEPLdwvL47NJW.xxCWe6xghaPdQzPmorT8HxMpjDujw08maXhh03oUGjDWQNBtZ0QCSzYD3rM8PWHoXObmhuXhpKngFCWMGl2UShezO13sKrzIVferFpEpoMQS5KkTLmG0jh3VSvodolmw--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] clk_must_disable() interface
Date: Thu, 22 Mar 2007 11:03:10 -0700
User-Agent: KMail/1.7.1
Cc: Andrew Victor <andrew@sanpeople.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221103.11367.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a clk_must_disable() operation, exposing the clock constraints
which often distinguish system power states.  Systems with such constraints
include ones using ARM-based AT91, OMAP, and PXA chips.  The new operation
lets driver methods check those constraints.

(Note that because of its APM/ACPI legacy, Linux can't currently handle more
then two of those state through the /sys/power/state infrastructure; they
are called "standby" and suspend-to-"mem", regardless of what the underlying
hardware calls them.)

A common benefit to leaving some device clocks enabled is that a suspended
device may then be able to issue system wakeup events.  RS232, USB, Ethernet,
and other drivers can use driver model wakeup flags as userspace directions
about how to trade off between the lowest power "full off" driver states and
the more functional wakeup-enabled ones.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Seems appropriate for 2.6.22 merge ... last time this came up, there
were no real objections, but the sample implementation (AT91) was a
bit messy.

 include/linux/clk.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+)

Index: at91/include/linux/clk.h
===================================================================
--- at91.orig/include/linux/clk.h	2007-02-16 08:47:11.000000000 -0800
+++ at91/include/linux/clk.h	2007-02-16 08:47:17.000000000 -0800
@@ -121,4 +121,24 @@ int clk_set_parent(struct clk *clk, stru
  */
 struct clk *clk_get_parent(struct clk *clk);
 
+/**
+ * clk_must_disable - report whether a clock's users must disable it
+ * @clk: one node in the clock tree
+ *
+ * This routine returns true only if the upcoming system state requires
+ * disabling the specified clock.
+ *
+ * It's common for platform power states to constrain certain clocks (and
+ * their descendants) to be unavailable, while other states allow that
+ * clock to be active.  A platform's power states often include an "all on"
+ * mode; system wide sleep states like "standby" or "suspend-to-RAM"; and
+ * operating states which sacrifice functionality for lower power usage.
+ *
+ * The constraint value is commonly tested in device driver suspend(), to
+ * leave clocks active if they are needed for features like wakeup events.
+ * On platforms that support reduced functionality operating states, the
+ * constraint may also need to be tested during resume() and probe() calls.
+ */
+int clk_must_disable(struct clk *clk);
+
 #endif
