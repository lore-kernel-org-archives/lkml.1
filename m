Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZLOToN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZLOToN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZLOToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:44:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43073 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbZLOToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DaMBZ/eezKGE3b1WHsQW0LifMLI9I8Y0FMnH4xyicitntZ8dOcEF2/w7oyyfrrmwcp
         aQqrg6JcH5c4kOVSGStdvM4ba0nBGxhpR2Zd1SZIa2/PxtjSHdHe+m0GaNI4LP89N+mv
         LPGx9artDd75BnEpqe71FtBfhXISVEk7lBFaQ=
Message-ID: <4B27E76D.8070904@gmail.com>
Date: Tue, 15 Dec 2009 20:45:49 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] asiliantfb: Fix test of unsigned in asiliant_calc_dclk2()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftarget, Fret, n and m are unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/video/asiliantfb.c b/drivers/video/asiliantfb.c
index 9fe90ce..e70bc22 100644
--- a/drivers/video/asiliantfb.c
+++ b/drivers/video/asiliantfb.c
@@ -140,7 +140,7 @@ static void asiliant_calc_dclk2(u32 *ppixclock, u8 *dclk2_m, u8 *dclk2_n, u8 *dc
 
 		/* 3 <= m <= 257 */
 		if (m >= 3 && m <= 257) {
-			unsigned new_error = ((Ftarget * n) - (Fref * m)) >= 0 ?
+			unsigned new_error = Ftarget * n >= Fref * m ?
 					       ((Ftarget * n) - (Fref * m)) : ((Fref * m) - (Ftarget * n));
 			if (new_error < best_error) {
 				best_n = n;
@@ -152,7 +152,7 @@ static void asiliant_calc_dclk2(u32 *ppixclock, u8 *dclk2_m, u8 *dclk2_n, u8 *dc
 		else if (m <= 1028) {
 			/* remember there are still only 8-bits of precision in m, so
 			 * avoid over-optimistic error calculations */
-			unsigned new_error = ((Ftarget * n) - (Fref * (m & ~3))) >= 0 ?
+			unsigned new_error = Ftarget * n >= Fref * (m & ~3) ?
 					       ((Ftarget * n) - (Fref * (m & ~3))) : ((Fref * (m & ~3)) - (Ftarget * n));
 			if (new_error < best_error) {
 				best_n = n;
