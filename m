Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbXLMGqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbXLMGqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbXLMGiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56536 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbXLMGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:58 -0500
Date: Wed, 12 Dec 2007 22:35:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pablo Neira Ayuso <pablo@netfilter.org>,
       Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 24/36] TEXTSEARCH: Do not allow zero length patterns in the
	textsearch infrastructure
Message-ID: <20071213063505.GY25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="textsearch-do-not-allow-zero-length-patterns-in-the-textsearch-infrastructure.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pablo Neira Ayuso <pablo@netfilter.org>

[TEXTSEARCH]: Do not allow zero length patterns in the textsearch infrastructure

[ Upstream commit: e03ba84adb62fbc6049325a5bc00ef6932fa5e39 ]

If a zero length pattern is passed then return EINVAL.
Avoids infinite loops (bm) or invalid memory accesses (kmp).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/textsearch.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -7,7 +7,7 @@
  *		2 of the License, or (at your option) any later version.
  *
  * Authors:	Thomas Graf <tgraf@suug.ch>
- * 		Pablo Neira Ayuso <pablo@eurodev.net>
+ * 		Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * ==========================================================================
  *
@@ -250,7 +250,8 @@ unsigned int textsearch_find_continuous(
  *       the various search algorithms.
  *
  * Returns a new textsearch configuration according to the specified
- *         parameters or a ERR_PTR().
+ * parameters or a ERR_PTR(). If a zero length pattern is passed, this
+ * function returns EINVAL.
  */
 struct ts_config *textsearch_prepare(const char *algo, const void *pattern,
 				     unsigned int len, gfp_t gfp_mask, int flags)
@@ -259,6 +260,9 @@ struct ts_config *textsearch_prepare(con
 	struct ts_config *conf;
 	struct ts_ops *ops;
 	
+	if (len == 0)
+		return ERR_PTR(-EINVAL);
+
 	ops = lookup_ts_algo(algo);
 #ifdef CONFIG_KMOD
 	/*

-- 
