Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbXIZWq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbXIZWq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbXIZWqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:46:22 -0400
Received: from mga05.intel.com ([192.55.52.89]:24927 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758180AbXIZWqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:46:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,199,1188802800"; 
   d="scan'208";a="325846897"
Date: Wed, 26 Sep 2007 15:45:59 -0700
From: Mark Gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS power example / hack
Message-ID: <20070926224559.GC23218@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070926223712.GA22029@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926223712.GA22029@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is a bit of a hack to illustrate how the qos
parameter infrastructure can communication information to the e1000
driver to use to set interrupt consolidation policy as a function of
acceptable network latency.  

Its just an example.


Signed-off-by: Mark Gross <mgross@linux.intel.com>

diff -urN -X linux-2.6.23-rc8/Documentation/dontdiff linux-2.6.23-rc8-qos-nolatency.c/drivers/net/e1000/e1000_main.c linux-2.6.23-rc8-qos-apps/drivers/net/e1000/e1000_main.c
--- linux-2.6.23-rc8-qos-nolatency.c/drivers/net/e1000/e1000_main.c	2007-09-26 13:54:33.000000000 -0700
+++ linux-2.6.23-rc8-qos-apps/drivers/net/e1000/e1000_main.c	2007-09-26 15:00:17.000000000 -0700
@@ -27,6 +27,7 @@
 *******************************************************************************/
 
 #include "e1000.h"
+#include <linux/qos_params.h>
 #include <net/ip6_checksum.h>
 
 char e1000_driver_name[] = "e1000";
@@ -2764,6 +2765,7 @@
 {
 	unsigned int retval = itr_setting;
 	struct e1000_hw *hw = &adapter->hw;
+	int requested_latency = qos_requirement(QOS_NETWORK_LATENCY);
 
 	if (unlikely(hw->mac_type < e1000_82540))
 		goto update_itr_done;
@@ -2803,6 +2805,13 @@
 		break;
 	}
 
+	if (requested_latency < 50)
+		retval = lowest_latency;
+	else if (requested_latency < 250)
+		retval = low_latency;
+	else
+		; //don't change the current algorithm
+
 update_itr_done:
 	return retval;
 }
