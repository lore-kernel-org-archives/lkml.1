Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbYD0Uoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbYD0Uoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYD0Uoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:44:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:18739 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYD0Uoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hZAt1mFxT/O4NxypPgEYKotyXEV0g28Q6tSrA4GhazwEDoRK3XYZnYEk1VtEO7lR07G9ifUiQFDsGIDi8SeG6KFRLFvl4ZbhYdBEjkpAm0hJDhdvgpBMSOQ434UDhpUm/uYyiAljayCIO5It7uqjDQiHO+6Zf1zuHmx7a5Kb1A4=
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Bert Wesarg <bert.wesarg@googlemail.com>,
       Mike Travis <travis@sgi.com>, Paul Jackson <pj@sgi.com>
Subject: [PATCH] Fix calculus of bitmap_scnprintf_len()
Date: Sun, 27 Apr 2008 22:43:23 +0200
Message-Id: <1209329003-22036-1-git-send-email-bert.wesarg@googlemail.com>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function bitmap_scnprintf_len() is currently not used, but the returned
value is 4 times larger than needed. This value is also only a good upper
bound. Which should be mentioned in the comment.

The correct number of chars needed for the buffer, exluding any new line and
terminating zero is:

int bitmap_scnprintf_len(int len)
{
	return  /* complete hunks with commas */
	          ((len / CHUNKSZ) * 9)
	        /* partial hunk, 4 bits in one char */
	       + (((len % CHUNKSZ) + 3) / 4)
	        /* one less comma, if no partial hunk */
	       -  !(len % CHUNKSZ);
}

Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Paul Jackson <pj@sgi.com>

---
 lib/bitmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index a6939e1..47e6f0f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -325,7 +325,7 @@ int bitmap_scnprintf_len(unsigned int len)
 	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
 	int bitslen = ALIGN(len, CHUNKSZ);
 	int wordlen = CHUNKSZ / 4;
-	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
+	int buflen = (bitslen / CHUNKSZ) * (wordlen + 1);
 
 	return buflen;
 }
-- 
1.5.4

