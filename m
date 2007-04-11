Return-Path: <linux-kernel-owner+w=401wt.eu-S1161388AbXDKW4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161388AbXDKW4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:56:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161380AbXDKWzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55742 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161375AbXDKWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:28 -0400
Date: Wed, 11 Apr 2007 15:52:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 23/31] softmac: avoid assert in ieee80211softmac_wx_get_rate
Message-ID: <20070411225236.GX24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="softmac-avoid-assert-in-ieee80211softmac_wx_get_rate.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: John W. Linville <linville@tuxdriver.com>

[PATCH] softmac: avoid assert in ieee80211softmac_wx_get_rate

Unconfigured bcm43xx device can hit an assert() during wx_get_rate
queries.  This is because bcm43xx calls ieee80211softmac_start late
(i.e. during open instead of probe).

   bcm43xx_net_open ->
      bcm43xx_init_board ->
         bcm43xx_select_wireless_core ->
            ieee80211softmac_start

Fix is to check that device is running before completing
ieee80211softmac_wx_get_rate.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ieee80211/softmac/ieee80211softmac_wx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -265,6 +265,12 @@ ieee80211softmac_wx_get_rate(struct net_
 	int err = -EINVAL;
 
 	spin_lock_irqsave(&mac->lock, flags);
+
+	if (unlikely(!mac->running)) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
 	switch (mac->txrates.default_rate) {
 	case IEEE80211_CCK_RATE_1MB:
 		data->bitrate.value = 1000000;

-- 
