Return-Path: <linux-kernel-owner+w=401wt.eu-S937246AbXHGVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937246AbXHGVXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965102AbXHGU4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59879 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965094AbXHGU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:18 -0400
Date: Tue, 7 Aug 2007 13:48:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, neilb@suse.de, bfields@citi.umich.edu,
       akinobu.mita@gmail.com, trond.myklebust@fys.uio.no
Subject: [2.6.22.2 review 69/84] nfsd: fix possible oops on re-insertion of
	rpcsec_gss modules
Message-ID: <20070807204835.GS23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gss-modules.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

The handling of the re-registration case is wrong here; the "test" that was
returned from auth_domain_lookup will not be used again, so that reference
should be put.  And auth_domain_lookup never did anything with "new" in
this case, so we should just clean it up ourself.

Thanks to Akinobu Mita for bug report, analysis, and testing.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_gss/svcauth_gss.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -760,11 +760,12 @@ svcauth_gss_register_pseudoflavor(u32 ps
 	new->h.flavour = &svcauthops_gss;
 	new->pseudoflavor = pseudoflavor;
 
+	stat = 0;
 	test = auth_domain_lookup(name, &new->h);
-	if (test != &new->h) { /* XXX Duplicate registration? */
-		auth_domain_put(&new->h);
-		/* dangling ref-count... */
-		goto out;
+	if (test != &new->h) { /* Duplicate registration */
+		auth_domain_put(test);
+		kfree(new->h.name);
+		goto out_free_dom;
 	}
 	return 0;
 

-- 
