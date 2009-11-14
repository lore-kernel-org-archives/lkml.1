Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZKOHOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZKOHOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZKOHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:09 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:53038 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZKOHOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=JUziROq9TgKTBx98eDEK/OXth1uQBqIsPauiokPrB3oT1y3zxjO6b7DXjFHH5B08Q0
         48fIu6c2S573HUx50ffKNKDIANtEpqRKS89NP0uHTusStMNl9q+XMbZsWK3tJVIjUPsR
         t8Tb5IlvvwdlzVMZUPp4HngdbGrrIPH+iGor0=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 05/12] vsprintf: reduce code size by avoiding extra check
Date: Sat, 14 Nov 2009 05:11:53 -0200
Message-Id: <f10ae6f99b20a00bfbce030d28992381f034fdf3.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just refactor the code so that it avoid checking
"if (hi)" two times in a sequence, taking advantage of previous check made.

It also reduces code size:
   text    data     bss     dec     hex filename
  15726       0       8   15734    3d76 vsprintf.o (ex lib/lib.a-BEFORE)
  15710       0       8   15718    3d66 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d107583..3c83f7b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -745,8 +745,9 @@ static char *ip6_compressed_string(char *p, const char *addr)
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
1.6.5.2.180.gc5b3e.dirty

