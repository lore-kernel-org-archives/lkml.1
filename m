Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYJUViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYJUViW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYJUViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:38:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52706 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYJUViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:38:11 -0400
Date: Tue, 21 Oct 2008 17:37:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
Message-ID: <20081021213723.GL17268@tuxdriver.com>
References: <48FDFCCA.8040604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FDFCCA.8040604@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:01:14AM -0700, Larry Finger wrote:
> On my x86_64 system, the mainline 2.6.27-git kernel (v2.6.27-6030-g6da0b38)
> shows the following anomaly with the 'iwlist scan' command:
> 
>           Cell 03 - Address: 00:14:BF:85:49:FA
>                     ESSID:"lwfdjf"
>                     Mode:Master
>                     Channel:1
>                     Frequency:2.412 GHz (Channel 1)
>                     Quality=66/100  Signal level:-62 dBm  Noise level=-68 dBm
>                     Encryption key:on
>                     IE: Unknown: 00066C7766646A66
>                     IE: Unknown: 010882848B962430486C
>                     IE: Unknown: 030101
>                     IE: Unknown: 2A0104
>                     IE: Unknown: 2F0104
>                     IE: Unknown: 32040C121860
>                     IE: Unknown: DD09001018020014000000
>                     IE: WPA Version 1
>                         Group Cipher : TKIP
>                         Pairwise Ciphers (1) : TKIP
>                         Authentication Suites (1) : PSK
>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
>                               24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
>                               12 Mb/s; 48 Mb/s
>                     Extra:tsf=0000014488aeb18b
>                     Extra: Last beacon: 448ms ago
> 
> This problem was bisected to commit 43ac2ca3840f64f699a239535c590fa7ebaaac27,
> entitled "mac80211: Handle scan result IEs in one block". The same bug is
> present in the wireless-testing tree.

I'm guessing that iwlist doesn't like the packed IEs?  Does this patch help?

John

P.S.  I'm not sure if this qualifies as actual userland breakage or not...

---

From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: do not aggregate IEs from scan results

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/scan.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 416bb41..51ed74d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -728,8 +728,6 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 
 	while (end - pos > IW_GENERIC_IE_MAX) {
 		next = pos + 2 + pos[1];
-		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
-			next = next + 2 + next[1];
 
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVGENIE;
-- 
1.5.4.3

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
