Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZKDOtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZKDOtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZKDOtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:49:03 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46847 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbZKDOtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=a26RA8JXDjv1SAjV+1uUahucrWQLJR5OHs3uI/4oJoJ51IS25pNi7v1Jrba2MhA2tq
         h5bsFhgbom8vu3rZOqr6aru/RNTxzjXsxtuBM9p6hRLLwpyOg5IOujSm15XkyYPpSf1m
         6IelOZtpfrGCgLme6/vUprboYytrQV6t3c4gc=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:48:46 -0200
Message-ID: <b8bf37780911040648n17874029xe422560de7339c32@mail.gmail.com>
Subject: [PATCH v3 5/7] vsprintf: reduce code size by avoiding extra check
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>
Date: Tue, 3 Nov 2009 10:53:13 -0200
Subject: [PATCH v3 5/7] vsprintf: reduce code size by avoiding extra check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

No functional change, just refactor the code so that it avoid checking
"if (hi)" two times in a sequence, taking advantage of previous check made.

It also reduces code size:
   text    data     bss     dec     hex filename
  15735       0       8   15743    3d7f lib/vsprintf.o-before
  15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 14e4197..af79152 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -747,8 +747,9 @@ static char *ip6_compressed_string(char *p, const
char *addr)
 				p = pack_hex_byte(p, hi);
 			else
 				*p++ = hex_asc_lo(hi);
+			p = pack_hex_byte(p, lo);
 		}
-		if (hi || lo > 0x0f)
+		else if (lo > 0x0f)
 			p = pack_hex_byte(p, lo);
 		else
 			*p++ = hex_asc_lo(lo);
-- 
1.6.5.2.143.g8cc62.dirty
