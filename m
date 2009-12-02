Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZLBNor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZLBNor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZLBNoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:44:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZLBNoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:44:46 -0500
Subject: [PATCH][stable] b44 WOL setup: one-bit-off stack corruption kernel
 panic fix
From: Stanislav Brabec <sbrabec@suse.cz>
To: Gary Zambrano <zambrano@broadcom.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-2"
Organization: SuSE CR, s. r. o.
Date: Wed, 02 Dec 2009 14:45:47 +0100
Message-Id: <1259761547.8709.264.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About 50% of shutdowns of b44 Ethernet adapter ends by kernel panic with
kernels compiled with stack-protector.

Checking b44_magic_pattern() return values, one call of
b44_magic_pattern() returns 127. It means, that set_bit(128, pmask) was
called on line 1509. It means that bit 0 of 17th byte of pmask was
overwritten. But pmask has only 16 bytes. Stack corruption happens.
 
It seems that set_bit() on line 1509 always writes one bit off.

The fix does not only solve the stack corruption, but also makes Wake On
LAN working on my onboard B44 on Asus A7V-333X mainboard.

It seems that this problem affects all kernel versions since commit
725ad800 on 2006-06-20.

Signed-off-by: Stanislav Brabec <sbrabec@suse.cz>

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 2a91323..4869adb 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -1505,8 +1505,7 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
 		for (k = 0; k< ethaddr_bytes; k++) {
 			ppattern[offset + magicsync +
 				(j * ETH_ALEN) + k] = macaddr[k];
-			len++;
-			set_bit(len, (unsigned long *) pmask);
+			set_bit(len++, (unsigned long *) pmask);
 		}
 	}
 	return len - 1;


-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

