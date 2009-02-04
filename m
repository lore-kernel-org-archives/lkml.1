Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbZBDTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbZBDTI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761512AbZBDS6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:58:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:42564 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762609AbZBDS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:58:01 -0500
Date: Wed, 4 Feb 2009 19:57:58 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Basterfield <andrew@dialogue.co.uk>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: Copying file with bad utf byte sequence in filename to rw UDF
	filesystem panics
Message-ID: <20090204185758.GC7066@duck.suse.cz>
References: <49824E77.7010706@dialogue.co.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49824E77.7010706@dialogue.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri 30-01-09 00:48:55, Andrew Basterfield wrote:
> Binary package hint: linux-image-2.6.24-22-generic
>
> I have a file on ext3 that has a spurious 0x8A char in it's filename.
> When I try to copy it to a R/W UDF volume I get a kernel panic.
>
> $ ls Air\ -\ Le\ Soleil\ Est\ Pr�s\ De\ Moi.mp3 | hexdump -C
> 00000000  41 69 72 20 2d 20 4c 65  20 53 6f 6c 65 69 6c 20  |Air - Le Soleil |
> 00000010  45 73 74 20 50 72 8a 73  20 44 65 20 4d 6f 69 2e  |Est Pr.s De Moi.|
> 00000020  6d 70 33 0a                                       |mp3.|
> 00000024
>
> The filesystem has to be mounted with iocharset=utf8
>
> Is this related to http://lkml.org/lkml/2008/1/30/483
  OK, attached patch should fix your problem.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--SkvwRMAIpAhPCcCJ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-udf-Fix-oops-when-invalid-character-in-filename-occ.patch"

>From a006760466b41fda23d10b9de53b9ad7e2d6120b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 4 Feb 2009 19:46:11 +0100
Subject: [PATCH] udf: Fix oops when invalid character in filename occurs

Functions udf_CS0toNLS() and udf_NLStoCS0() didn't count with the fact that
NLS can return negative length when invalid character is given to it for
conversion. Thus interesting things could happen (such as overwriting random
memory with the rest of filename). Add appropriate checks.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/unicode.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index a3bbdbd..cefa8c8 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -254,7 +254,7 @@ static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
 {
 	const uint8_t *ocu;
 	uint8_t cmp_id, ocu_len;
-	int i;
+	int i, len;
 
 
 	ocu_len = ocu_i->u_len;
@@ -279,8 +279,13 @@ static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
 		if (cmp_id == 16)
 			c = (c << 8) | ocu[i++];
 
-		utf_o->u_len += nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
-					      UDF_NAME_LEN - utf_o->u_len);
+		len = nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
+				    UDF_NAME_LEN - utf_o->u_len);
+		/* Valid character? */
+		if (len >= 0)
+			utf_o->u_len += len;
+		else
+			utf_o->u_name[utf_o->u_len++] = '?';
 	}
 	utf_o->u_cmpID = 8;
 
@@ -290,7 +295,8 @@ static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
 static int udf_NLStoCS0(struct nls_table *nls, dstring *ocu, struct ustr *uni,
 			int length)
 {
-	unsigned len, i, max_val;
+	int len;
+	unsigned i, max_val;
 	uint16_t uni_char;
 	int u_len;
 
@@ -302,8 +308,13 @@ try_again:
 	u_len = 0U;
 	for (i = 0U; i < uni->u_len; i++) {
 		len = nls->char2uni(&uni->u_name[i], uni->u_len - i, &uni_char);
-		if (len <= 0)
+		if (!len)
 			continue;
+		/* Invalid character, deal with it */
+		if (len < 0) {
+			len = 1;
+			uni_char = '?';
+		}
 
 		if (uni_char > max_val) {
 			max_val = 0xffffU;
-- 
1.6.0.2


--SkvwRMAIpAhPCcCJ--
