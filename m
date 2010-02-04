Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab0BDR0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:26:12 -0500
Received: from kroah.org ([198.145.64.141]:34946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875Ab0BDRW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:28 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:25 2010
Message-Id: <20100204171524.867830309@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>, Zhu Yi <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [65/74] mac80211: fix NULL pointer dereference when ftrace is enabled
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

commit 3092ad054406f069991ca561adc74f2d9fbb6867 upstream.

I got below kernel oops when I try to bring down the network interface if
ftrace is enabled. The root cause is drv_ampdu_action() is passed with a
NULL ssn pointer in the BA session tear down case. We need to check and
avoid dereferencing it in trace entry assignment.

BUG: unable to handle kernel NULL pointer dereference
Modules linked in: at (null)
IP: [<f98fe02a>] ftrace_raw_event_drv_ampdu_action+0x10a/0x160 [mac80211]
*pde = 00000000
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[...]
Call Trace:
 [<f98fdf20>] ? ftrace_raw_event_drv_ampdu_action+0x0/0x160 [mac80211]
 [<f98dac4c>] ? __ieee80211_stop_rx_ba_session+0xfc/0x220 [mac80211]
 [<f98d97fb>] ? ieee80211_sta_tear_down_BA_sessions+0x3b/0x50 [mac80211]
 [<f98dc6f6>] ? ieee80211_set_disassoc+0xe6/0x230 [mac80211]
 [<f98dc6ac>] ? ieee80211_set_disassoc+0x9c/0x230 [mac80211]
 [<f98dcbb8>] ? ieee80211_mgd_deauth+0x158/0x170 [mac80211]
 [<f98e4bdb>] ? ieee80211_deauth+0x1b/0x20 [mac80211]
 [<f8987f49>] ? __cfg80211_mlme_deauth+0xe9/0x120 [cfg80211]
 [<f898b870>] ? __cfg80211_disconnect+0x170/0x1d0 [cfg80211]

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/driver-trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -655,7 +655,7 @@ TRACE_EVENT(drv_ampdu_action,
 		__entry->ret = ret;
 		__entry->action = action;
 		__entry->tid = tid;
-		__entry->ssn = *ssn;
+		__entry->ssn = ssn ? *ssn : 0;
 	),
 
 	TP_printk(


