Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbZENWuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbZENWuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZENWme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:34 -0400
Received: from kroah.org ([198.145.64.141]:52435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbZENWmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:24 2009
Message-Id: <20090514223524.373095782@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Jeff Layton <jlayton@redhat.com>, Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 25/51] cifs: Increase size of tmp_buf in cifs_readdir to avoid potential overflows
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=cifs-increase-size-of-tmp_buf-in-cifs_readdir-to-avoid-potential-overflows.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.de>

Commit 7b0c8fcff47a885743125dd843db64af41af5a61 refreshed and use
a #define from commit f58841666bc22e827ca0dcef7b71c7bc2758ce82.

cifs: Increase size of tmp_buf in cifs_readdir to avoid potential overflows

Increase size of tmp_buf to possible maximum to avoid potential
overflows. Also moved UNICODE_NAME_MAX definition so that it can be used
elsewhere.

Pointed-out-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_unicode.h |    7 +++++++
 fs/cifs/readdir.c      |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -64,6 +64,13 @@ int cifs_strtoUCS(__le16 *, const char *
 #endif
 
 /*
+ * To be safe - for UCS to UTF-8 with strings loaded with the rare long
+ * characters alloc more to account for such multibyte target UTF-8
+ * characters.
+ */
+#define UNICODE_NAME_MAX ((4 * NAME_MAX) + 2)
+
+/*
  * UniStrcat:  Concatenate the second string to the first
  *
  * Returns:
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -1072,7 +1072,7 @@ int cifs_readdir(struct file *file, void
 		with the rare long characters alloc more to account for
 		such multibyte target UTF-8 characters. cifs_unicode.c,
 		which actually does the conversion, has the same limit */
-		tmp_buf = kmalloc((2 * NAME_MAX) + 4, GFP_KERNEL);
+		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
 		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
 			if (current_entry == NULL) {
 				/* evaluate whether this case is an error */


