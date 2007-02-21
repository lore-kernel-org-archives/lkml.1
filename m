Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXBUBxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXBUBxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964838AbXBUBwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:52:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:35814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841AbXBUBwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:52:06 -0500
Date: Tue, 20 Feb 2007 17:50:41 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ang Way Chuang <wcang@nrg.cs.usm.my>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 10/18] dvb-core: fix bug in CRC-32 checking on 64-bit systems
Message-ID: <20070221015041.GK3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-core-fix-bug-in-CRC-32-checking-on-64-bit-systems.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ang Way Chuang <wcang@nrg.cs.usm.my>

CRC-32 checking during ULE decapsulation always failed on x86_64 systems due
to the size of a variable used to store CRC. This bug was discovered on
Fedora Core 6 with kernel-2.6.18-1.2849. The i386 counterpart has no such
problem. This patch has been tested on 64-bit system as well as 32-bit system.

(cherry picked from commit dedcefb085fe98a1feaf63590fe2fc7e0ecb1987)

Signed-off-by: Ang Way Chuang <wcang@nrg.cs.usm.my>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-core/dvb_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.18.7.orig/drivers/media/dvb/dvb-core/dvb_net.c
+++ linux-2.6.18.7/drivers/media/dvb/dvb-core/dvb_net.c
@@ -604,7 +604,7 @@ static void dvb_net_ule( struct net_devi
 				{ &utype, sizeof utype },
 				{ priv->ule_skb->data, priv->ule_skb->len - 4 }
 			};
-			unsigned long ule_crc = ~0L, expected_crc;
+			u32 ule_crc = ~0L, expected_crc;
 			if (priv->ule_dbit) {
 				/* Set D-bit for CRC32 verification,
 				 * if it was set originally. */
@@ -617,7 +617,7 @@ static void dvb_net_ule( struct net_devi
 				       *((u8 *)priv->ule_skb->tail - 2) << 8 |
 				       *((u8 *)priv->ule_skb->tail - 1);
 			if (ule_crc != expected_crc) {
-				printk(KERN_WARNING "%lu: CRC32 check FAILED: %#lx / %#lx, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
+				printk(KERN_WARNING "%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
 				       priv->ts_count, ule_crc, expected_crc, priv->ule_sndu_len, priv->ule_sndu_type, ts_remain, ts_remain > 2 ? *(unsigned short *)from_where : 0);
 
 #ifdef ULE_DEBUG

--
