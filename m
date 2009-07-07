Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZGGRE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZGGRE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZGGREu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:04:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64013 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbZGGREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:04:49 -0400
Subject: Possible memory leak in net/wireless/scan.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 18:04:29 +0100
Message-Id: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 17:04:30.0054 (UTC) FILETIME=[FDE86060:01C9FF24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm investigating several kmemleak reports like the one below (it could
as well be a false positive but it needs more digging):

unreferenced object 0xc338af70 (size 256):
  comm "softirq", pid 0, jiffies 4294903018
  backtrace:
    [<c01e0c3a>] create_object+0xfa/0x250
    [<c01e1e7d>] kmemleak_alloc+0x5d/0x70
    [<c01db2d5>] __kmalloc+0x115/0x1f0
    [<f826395b>] cfg80211_inform_bss_frame+0x5b/0x170 [cfg80211]
    [<f8fa82de>] ieee80211_bss_info_update+0x3e/0x1b0 [mac80211]
    [<f8fa85c5>] ieee80211_scan_rx+0x165/0x1a0 [mac80211]
    [<f8fb58dc>] ieee80211_invoke_rx_handlers+0x1cc/0x21d0 [mac80211]
    [<f8fb50c2>] __ieee80211_rx_handle_packet+0x2d2/0x5f0 [mac80211]
    [<f8fb7c8b>] __ieee80211_rx+0x3ab/0x670 [mac80211]
    [<f8fa469e>] ieee80211_tasklet_handler+0xfe/0x120 [mac80211]
    [<c0143b13>] tasklet_action+0x63/0xe0
    [<c0144142>] __do_softirq+0xc2/0x1a0
    [<c0144285>] do_softirq+0x65/0x70
    [<c01443d5>] irq_exit+0x65/0x90
    [<c0104a6f>] do_IRQ+0x4f/0xc0
    [<c010376e>] common_interrupt+0x2e/0x40

The reported object seems to be the struct cfg80211_internal_bss *res
allocated in cfg80211_inform_bss_frame(). This object is passed to
cfg80211_bss_update(). What looks a bit suspicious to me is that if an
object is found in the rb tree, this function calls kref_get() on it in
the "if (found)" block and one more time before return. Should it only
call kref_get(&found->ref) once:

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e95b638..f8e71b3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -366,7 +366,6 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	found = rb_find_bss(dev, res);
 
 	if (found) {
-		kref_get(&found->ref);
 		found->pub.beacon_interval = res->pub.beacon_interval;
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;

I'll try this later today to see if it fixes the leak. If that's not
correct, I'll post more information about the content of the reported
object (in general, it shouldn't be on any valid list or rb tree since
kmemleak can't find it).

Thanks.

-- 
Catalin

