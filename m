Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZCKMIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZCKMIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZCKMIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:08:39 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43771 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZCKMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:08:37 -0400
Date: Wed, 11 Mar 2009 12:07:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "John W. Linville" <linville@tuxdriver.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: 2.6.29-rc "TKIP: replay detected" regression
Message-ID: <Pine.LNX.4.64.0903111114510.22922@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to 2.6.29-rc1's 274bfb8dc5ffa16cb073801bebe76ab7f4e2e73d
"lib80211: absorb crypto bits from net/ieee80211", the TKIP and CCMP
"replay detected" messages were subject to the IEEE80211_DEBUG_DROP()
macro, neither I nor my distro had CONFIG_IEEE80211_DEBUG set, I never
glimpsed such messages, and ThinkPad T43p ipw2200 wireless worked fine.

-		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
-			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=%pM"
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "TKIP: replay detected: STA=%pM"

Wireless is still working fine - thank you - but now that such messages
are not CONFIG'ed out, my /var/log/messages is getting cluttered with
"TKIP: replay detected"s, and more unpleasantly (because I have WARNINGs
to screen) occasional "__ratelimit: NN callbacks suppressed" appearing.

Messages from the last day appended below: only one CCMP, but two
kinds of TKIP message - sometimes it's just the same TSC repeated,
but more irritating are the sequences when it gets a reset to zero
"previous TSC 000000000dbb received TSC 000000000000" followed by
message (or suppression) as it goes on to receive 1, 2, 3, ...
The AP here, if it's of any interest, is a Siemens Gigaset SE587.

I've not correlated these bursts with any bad behaviour at all,
reception seems fine even amidst these sequences: so I'd be glad
just to have those messages suppressed again - and of course can
patch them out of my own kernel builds, but others may suffer too.

Hugh

Mar 10 12:47:27 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000380 received TSC 000000000380
Mar 10 17:44:42 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 0000000009fd received TSC 0000000009fd
Mar 10 17:50:51 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000a5b received TSC 000000000a5b
Mar 10 18:07:27 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000aec received TSC 000000000aec
Mar 10 18:17:24 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000b36 received TSC 000000000b36
Mar 10 20:18:54 blonde kernel: CCMP: replay detected: STA=00:21:04:13:08:d3 previous PN 000000000527 received PN 000000000526
Mar 10 20:22:10 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000e8e received TSC 000000000e8e
Mar 10 23:27:26 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 00000000015f received TSC 00000000015f
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000000
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000001
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000002
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000003
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000004
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000005
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000006
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000007
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000008
Mar 11 10:17:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000009
Mar 11 10:27:23 blonde kernel: __ratelimit: 30 callbacks suppressed
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000002d
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000002e
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000002f
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000031
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000032
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000033
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000034
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000035
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000036
Mar 11 10:27:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000037
Mar 11 10:29:23 blonde kernel: __ratelimit: 32 callbacks suppressed
Mar 11 10:29:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000005a
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000005b
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000005c
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000005d
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000005e
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000005f
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000060
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000061
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000062
Mar 11 10:37:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000063
Mar 11 10:47:23 blonde kernel: __ratelimit: 33 callbacks suppressed
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000088
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000089
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000008a
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000008c
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000008d
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000008e
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 00000000008f
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000090
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000091
Mar 11 10:47:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 000000000092
Mar 11 10:57:23 blonde kernel: __ratelimit: 30 callbacks suppressed
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000b5
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000b6
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000b7
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000b8
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000b9
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000ba
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000bb
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000bc
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000bd
Mar 11 10:57:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000c1
Mar 11 11:07:23 blonde kernel: __ratelimit: 30 callbacks suppressed
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e2
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e3
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e4
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e5
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e6
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e7
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e8
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000e9
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000ea
Mar 11 11:07:23 blonde kernel: TKIP: replay detected: STA=00:21:04:13:08:d3 previous TSC 000000000dbb received TSC 0000000000eb
