Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbZAHGRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbZAHGRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZAHGR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:17:26 -0500
Received: from 076-076-148-181.pdx.net ([76.76.148.181]:35214 "EHLO gocho"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753537AbZAHGRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:17:24 -0500
X-Greylist: delayed 46703 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 01:17:21 EST
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 2/3] wimax: fix kconfig interactions with rfkill and input layers
Date: Wed,  7 Jan 2009 09:18:46 -0800
Message-Id: <f0f7dc5763046cc336ca087a2525c8b52811ddb4.1231348339.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1231348339.git.inaky@linux.intel.com>
References: <cover.1231348339.git.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WiMAX can work without RFKILL, but it was missing a check to make sure
RFKILL is not being made a module with wimax compiled into the
kernel. This caused failed builds in s390, where CONFIG_INPUT is
always off.

When RFKILL is enabled, the code uses the input layer to report
hardware switch changes; thus, if RFKILL is enabled, INPUT has to be
too. It also needs to display some message when INPUT is disabled that
explains why WiMAX is not selectable.

(issues found by Randy Dunlap in the linux-next tree).

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
---
 net/wimax/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/wimax/Kconfig b/net/wimax/Kconfig
index 0bdbb69..18495cd 100644
--- a/net/wimax/Kconfig
+++ b/net/wimax/Kconfig
@@ -1,9 +1,23 @@
 #
 # WiMAX LAN device configuration
 #
+# Note the ugly 'depends on' on WIMAX: that disallows RFKILL to be a
+# module if WIMAX is to be linked in. The WiMAX code is done in such a
+# way that it doesn't require and explicit dependency on RFKILL in
+# case an embedded system wants to rip it out.
+#
+# As well, enablement of the RFKILL code means we need the INPUT layer
+# support to inject events coming from hw rfkill switches. That
+# dependency could be killed if input.h provided appropiate means to
+# work when input is disabled.
+
+comment "WiMAX Wireless Broadband support requires CONFIG_INPUT enabled"
+	depends on INPUT = n && RFKILL != n
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
+	depends on (y && RFKILL != m) || m
+	depends on (INPUT && RFKILL != n) || RFKILL = n
 	help
 
 	  Select to configure support for devices that provide
-- 
1.5.6.5

