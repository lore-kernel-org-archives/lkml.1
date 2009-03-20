Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbZCTX1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbZCTX1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762930AbZCTXYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:23 -0400
Received: from kroah.org ([198.145.64.141]:48503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762920AbZCTXYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:23 2009
Message-Id: <20090320222923.632902504@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:15 -0700
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
       alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@novell.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 05/43] ALSA: Fix vunmap and free order in snd_free_sgbuf_pages()
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=alsa-fix-vunmap-and-free-order-in-snd_free_sgbuf_pages.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6af845e4eb36fb91b322aaf77ec1cab2220a48ad upstream.

In snd_free_sgbuf_pags(), vunmap() is called after releasing the SG
pages, and it causes errors on Xen as Xen manages the pages
differently.  Although no significant errors have been reported on
the actual hardware, this order should be fixed other way round,
first vunmap() then free pages.

Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/sgbuf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/core/sgbuf.c
+++ b/sound/core/sgbuf.c
@@ -38,6 +38,10 @@ int snd_free_sgbuf_pages(struct snd_dma_
 	if (! sgbuf)
 		return -EINVAL;
 
+	if (dmab->area)
+		vunmap(dmab->area);
+	dmab->area = NULL;
+
 	tmpb.dev.type = SNDRV_DMA_TYPE_DEV;
 	tmpb.dev.dev = sgbuf->dev;
 	for (i = 0; i < sgbuf->pages; i++) {
@@ -48,9 +52,6 @@ int snd_free_sgbuf_pages(struct snd_dma_
 		tmpb.bytes = (sgbuf->table[i].addr & ~PAGE_MASK) << PAGE_SHIFT;
 		snd_dma_free_pages(&tmpb);
 	}
-	if (dmab->area)
-		vunmap(dmab->area);
-	dmab->area = NULL;
 
 	kfree(sgbuf->table);
 	kfree(sgbuf->page_table);


