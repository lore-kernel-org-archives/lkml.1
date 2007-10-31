Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXJaPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXJaPY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbXJaPYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33398 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658AbXJaPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:04 -0400
Date: Wed, 31 Oct 2007 08:11:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/26] Fix ieee80211 handling of bogus hdrlength field
Message-ID: <20071031151107.GE2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ieee80211-handling-of-bogus-hdrlength-field.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: John W. Linville <linville@tuxdriver.com>

changeset 04045f98e0457aba7d4e6736f37eed189c48a5f7 from mainline

Reported by Chris Evans <scarybeasts@gmail.com>:

> The summary is that an evil 80211 frame can crash out a victim's
> machine. It only applies to drivers using the 80211 wireless code, and
> only then to certain drivers (and even then depends on a card's
> firmware not dropping a dubious packet). I must confess I'm not
> keeping track of Linux wireless support, and the different protocol
> stacks etc.
>
> Details are as follows:
>
> ieee80211_rx() does not explicitly check that "skb->len >= hdrlen".
> There are other skb->len checks, but not enough to prevent a subtle
> off-by-two error if the frame has the IEEE80211_STYPE_QOS_DATA flag
> set.
>
> This leads to integer underflow and crash here:
>
> if (frag != 0)
>    flen -= hdrlen;
>
> (flen is subsequently used as a memcpy length parameter).

How about this?

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ieee80211/ieee80211_rx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -366,6 +366,12 @@ int ieee80211_rx(struct ieee80211_device
 	frag = WLAN_GET_SEQ_FRAG(sc);
 	hdrlen = ieee80211_get_hdrlen(fc);
 
+	if (skb->len < hdrlen) {
+		printk(KERN_INFO "%s: invalid SKB length %d\n",
+			dev->name, skb->len);
+		goto rx_dropped;
+	}
+
 	/* Put this code here so that we avoid duplicating it in all
 	 * Rx paths. - Jean II */
 #ifdef CONFIG_WIRELESS_EXT

-- 
