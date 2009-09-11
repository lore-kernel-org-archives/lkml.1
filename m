Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZIKAbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZIKAbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZIKA3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:10 -0400
Received: from kroah.org ([198.145.64.141]:38077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZIKA3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:10 2009
Message-Id: <20090911002410.660886830@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Massimo Cirillo <maxcir@gmail.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 11/22] JFFS2: add missing verify buffer allocation/deallocation
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=jffs2-add-missing-verify-buffer-allocation-deallocation.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Massimo Cirillo <maxcir@gmail.com>

commit bc8cec0dff072f1a45ce7f6b2c5234bb3411ac51 upstream.

The function jffs2_nor_wbuf_flash_setup() doesn't allocate the verify buffer
if CONFIG_JFFS2_FS_WBUF_VERIFY is defined, so causing a kernel panic when
that macro is enabled and the verify function is called. Similarly the
jffs2_nor_wbuf_flash_cleanup() must free the buffer if
CONFIG_JFFS2_FS_WBUF_VERIFY is enabled.
The following patch fixes the problem.
The following patch applies to 2.6.30 kernel.

Signed-off-by: Massimo Cirillo <maxcir@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/wbuf.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1268,10 +1268,20 @@ int jffs2_nor_wbuf_flash_setup(struct jf
 	if (!c->wbuf)
 		return -ENOMEM;
 
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+	c->wbuf_verify = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
+	if (!c->wbuf_verify) {
+		kfree(c->wbuf);
+		return -ENOMEM;
+	}
+#endif
 	return 0;
 }
 
 void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c) {
+#ifdef CONFIG_JFFS2_FS_WBUF_VERIFY
+	kfree(c->wbuf_verify);
+#endif
 	kfree(c->wbuf);
 }
 


