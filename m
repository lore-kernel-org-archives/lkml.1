Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYFVOWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYFVOWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbYFVOUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:20:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45116 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbYFVOUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:20:50 -0400
To: mchehab@infradead.org
Subject: [PATCH] dvb_net endianness fix
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQz-00024e-JS@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:20:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to RFC 4326 (4.1) D-bit is MSB in net-endian 16bit.
dvb_net.c did
				/* Set D-bit for CRC32 verification,
				 * if it was set originally. */
				ulen |= 0x0080;
which works of little-endian (htons(1<<15) is 0x0080 there), but breaks
on big-endian.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-core/dvb_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index c2334ae..ff71610 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -606,7 +606,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 			if (priv->ule_dbit) {
 				/* Set D-bit for CRC32 verification,
 				 * if it was set originally. */
-				ulen |= 0x0080;
+				ulen |= htons(0x8000);
 			}
 
 			ule_crc = iov_crc32(ule_crc, iov, 3);
-- 
1.5.3.GIT

