Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXLMHPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXLMHPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762433AbXLMG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55599 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762659AbXLMG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:08 -0500
Date: Wed, 12 Dec 2007 22:53:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 47/60] BRIDGE: Lost call to br_fdb_fini() in br_init()
	error path
Message-ID: <20071213065318.GW6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bridge-lost-call-to-br_fdb_fini-in-br_init-error-path.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pavel Emelyanov <xemul@openvz.org>

[BRIDGE]: Lost call to br_fdb_fini() in br_init() error path

[ Upstream commit: 17efdd45755c0eb8d1418a1368ef7c7ebbe98c6e ]
 
In case the br_netfilter_init() (or any subsequent call)
fails, the br_fdb_fini() must be called to free the allocated
in br_fdb_init() br_fdb_cache kmem cache.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -39,7 +39,7 @@ static int __init br_init(void)
 
 	err = br_fdb_init();
 	if (err)
-		goto err_out1;
+		goto err_out;
 
 	err = br_netfilter_init();
 	if (err)
@@ -65,6 +65,8 @@ err_out3:
 err_out2:
 	br_netfilter_fini();
 err_out1:
+	br_fdb_fini();
+err_out:
 	llc_sap_put(br_stp_sap);
 	return err;
 }

-- 
