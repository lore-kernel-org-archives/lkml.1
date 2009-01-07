Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbZAGTXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbZAGTXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbZAGTWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:22:33 -0500
Received: from mga05.intel.com ([192.55.52.89]:62294 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756566AbZAGTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:22:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,339,1228118400"; 
   d="scan'208";a="655323912"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 2/4] wimax: fix kconfig interactions with rfkill and input layers
Date: Wed,  7 Jan 2009 11:22:20 -0800
Message-Id: <f0f7dc5763046cc336ca087a2525c8b52811ddb4.1231355768.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
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

