Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYHZR6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYHZR6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbYHZR56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:57:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:14107 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYHZR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=rskeuwKJWgf1iIWThyTZLOzQPl+8DGNEatLJYioQ65Ns6KG6BhdM1IzOPlXSV+GAsy
         feUMj/sVoCwy+JcJnx+c3ruvg3fY7eYwLA4oBXrAikqXiH97CAN/4IAGld8T5LorWHnE
         Lbg0jPNqEEUsQEnXpETLz3yLZokfgjtfxL1UQ=
Message-ID: <48B4441E.5030108@gmail.com>
Date: Tue, 26 Aug 2008 20:57:50 +0300
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uclinux: fix gzip header parsing in binfmt_flat.c
References: <48B442C3.2000309@gmail.com>
In-Reply-To: <48B442C3.2000309@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070402020902060502000308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070402020902060502000308
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There are off-by-one errors in decompress_exec() when calculating the length of
optional "original file name" and "comment" fields: the "ret" index is not
incremented when terminating '\0' character is reached. The check of the buffer
overflow (after an "extra-field" length was taken into account) is also fixed.

Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
---
Sorry for repost, looks like I forgot to remove "--color" when saved diff
attached to the previous e-mail.

I've encountered this off-by-one error when tried to reuse gzip-header-parsing
part of the decompress_exec() function. There was an "original file name" field
in the payload (with miscalculated length) and zlib_inflate() returned
Z_DATA_ERROR. But after the fix similar to this one all worked fine.

WARNING: the proposed patch wasn't properly tested.

--------------070402020902060502000308
Content-Type: text/x-patch;
 name="binfmt_flat_decompress_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="binfmt_flat_decompress_fix.diff"

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index dfc0197..ccb781a 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -229,13 +229,13 @@ static int decompress_exec(
 	ret = 10;
 	if (buf[3] & EXTRA_FIELD) {
 		ret += 2 + buf[10] + (buf[11] << 8);
-		if (unlikely(LBUFSIZE == ret)) {
+		if (unlikely(LBUFSIZE <= ret)) {
 			DBG_FLT("binfmt_flat: buffer overflow (EXTRA)?\n");
 			goto out_free_buf;
 		}
 	}
 	if (buf[3] & ORIG_NAME) {
-		for (; ret < LBUFSIZE && (buf[ret] != 0); ret++)
+		while (ret < LBUFSIZE && buf[ret++] != 0)
 			;
 		if (unlikely(LBUFSIZE == ret)) {
 			DBG_FLT("binfmt_flat: buffer overflow (ORIG_NAME)?\n");
@@ -243,7 +243,7 @@ static int decompress_exec(
 		}
 	}
 	if (buf[3] & COMMENT) {
-		for (;  ret < LBUFSIZE && (buf[ret] != 0); ret++)
+		while (ret < LBUFSIZE && buf[ret++] != 0)
 			;
 		if (unlikely(LBUFSIZE == ret)) {
 			DBG_FLT("binfmt_flat: buffer overflow (COMMENT)?\n");

--------------070402020902060502000308--
