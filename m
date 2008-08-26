Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYHZBDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYHZBDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 21:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYHZBDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 21:03:45 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:10466 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYHZBDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 21:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Px+wpesZekwGlz2ZnmPNIkSJ7MgcmbBZqDSZE0Jwehw8y/YpVGbdUkAoPCM31F+vkw
         F2mZ1AzFJHUurah/XZAUbW46O2++Hta1aBCoYPbUQoFnSZWyTY33/OOlja3cvl13FiUd
         3q8ulRzelKA1vasiQytvWUjlnOqi13QWZ0uS0=
Message-ID: <c0ff893e0808251803tee7f145i6a5aa9f79d943dec@mail.gmail.com>
Date: Tue, 26 Aug 2008 09:03:43 +0800
From: "luo kaih" <kaih.luo@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: xt_time gives a wrong monthday in a leap year
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the function localtime_3 in xt_time.c  gives a wrong monthday in a
leap year after 28th 2 . calculating monthday should use the array
days_since_leapyear[] not
days_since_year[]  in a leap year .
Signed-off-by: Kaihui Luo <kaih.luo@gmail.com>
---
--- linux-2.6.26/net/netfilter/xt_time.c.orig   2008-08-25
11:59:46.000000000 +0800
+++ linux-2.6.26/net/netfilter/xt_time.c        2008-08-25
12:16:12.000000000 +0800
@@ -136,17 +136,19 @@ static void localtime_3(struct xtm *r, t
        * from w repeatedly while counting.)
        */
       if (is_leap(year)) {
+               /* use days_since_leapyear[] in a leap year */
               for (i = ARRAY_SIZE(days_since_leapyear) - 1;
-                   i > 0 && days_since_year[i] > w; --i)
+                   i > 0 && days_since_leapyear[i] > w; --i)
                       /* just loop */;
+               r->monthday = w - days_since_leapyear[i] + 1;
       } else {
               for (i = ARRAY_SIZE(days_since_year) - 1;
                   i > 0 && days_since_year[i] > w; --i)
                       /* just loop */;
+               r->monthday = w - days_since_year[i] + 1;
       }

       r->month    = i + 1;
-       r->monthday = w - days_since_year[i] + 1;
       return;
 }
