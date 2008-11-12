Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYKLAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYKLAbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYKLA0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:20 -0500
Received: from kroah.org ([198.145.64.141]:42221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbYKLA0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:18 -0500
Date: Tue, 11 Nov 2008 16:23:25 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Richard Purdie <rpurdie@openedhand.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 15/49] JFFS2: fix race condition in jffs2_lzo_compress()
Message-ID: <20081112002325.GP10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jffs2-fix-race-condition-in-jffs2_lzo_compress.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

commit dc8a0843a435b2c0891e7eaea64faaf1ebec9b11 upstream

deflate_mutex protects the globals lzo_mem and lzo_compress_buf.  However,
jffs2_lzo_compress() unlocks deflate_mutex _before_ it has copied out the
compressed data from lzo_compress_buf.  Correct this by moving the mutex
unlock after the copy.

In addition, document what deflate_mutex actually protects.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Richard Purdie <rpurdie@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/compr_lzo.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/jffs2/compr_lzo.c
+++ b/fs/jffs2/compr_lzo.c
@@ -19,7 +19,7 @@
 
 static void *lzo_mem;
 static void *lzo_compress_buf;
-static DEFINE_MUTEX(deflate_mutex);
+static DEFINE_MUTEX(deflate_mutex);	/* for lzo_mem and lzo_compress_buf */
 
 static void free_workspace(void)
 {
@@ -49,18 +49,21 @@ static int jffs2_lzo_compress(unsigned c
 
 	mutex_lock(&deflate_mutex);
 	ret = lzo1x_1_compress(data_in, *sourcelen, lzo_compress_buf, &compress_size, lzo_mem);
-	mutex_unlock(&deflate_mutex);
-
 	if (ret != LZO_E_OK)
-		return -1;
+		goto fail;
 
 	if (compress_size > *dstlen)
-		return -1;
+		goto fail;
 
 	memcpy(cpage_out, lzo_compress_buf, compress_size);
-	*dstlen = compress_size;
+	mutex_unlock(&deflate_mutex);
 
+	*dstlen = compress_size;
 	return 0;
+
+ fail:
+	mutex_unlock(&deflate_mutex);
+	return -1;
 }
 
 static int jffs2_lzo_decompress(unsigned char *data_in, unsigned char *cpage_out,

-- 
