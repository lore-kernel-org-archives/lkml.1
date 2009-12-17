Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbZLQEdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbZLQEdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935512AbZLQEEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:32 -0500
Received: from kroah.org ([198.145.64.141]:55574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935560AbZLQEE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.184091195@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [064/151] mac80211: Fix bug in computing crc over dynamic IEs in beacon
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit 1814077fd12a9cdf478c10076e9c42094e9d9250 upstream.

On a 32-bit machine, BIT() macro does not give the required
bit value if the bit is mroe than 31. In ieee802_11_parse_elems_crc(),
BIT() is suppossed to get the bit value more than 31 (42 (id of ERP_INFO_IE),
37 (CHANNEL_SWITCH_IE), (42), 32 (POWER_CONSTRAINT_IE), 45 (HT_CAP_IE),
61 (HT_INFO_IE)). As we do not get the required bit value for the above
IEs, crc over these IEs are never calculated, so any dynamic change in these
IEs after the association is not really handled on 32-bit platforms.
This patch fixes this issue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -579,7 +579,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start
 		if (elen > left)
 			break;
 
-		if (calc_crc && id < 64 && (filter & BIT(id)))
+		if (calc_crc && id < 64 && (filter & (1ULL << id)))
 			crc = crc32_be(crc, pos - 2, elen + 2);
 
 		switch (id) {


