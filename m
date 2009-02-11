Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZBKAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZBKAbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbZBKA2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:13 -0500
Received: from kroah.org ([198.145.64.141]:51025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756450AbZBKA2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:11 -0500
Date: Tue, 10 Feb 2009 16:24:34 -0800
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
       alan@lxorguk.ukuu.org.uk, Karsten Keil <kkeil@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 10/56] module: remove over-zealous check in __module_get()
Message-ID: <20090211002434.GK14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="module-remove-over-zealous-check-in-__module_get.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 7f9a50a5b89b87f8e754f59ae9968da28be618a5 upstream.

Impact: fix spurious BUG_ON() triggered under load

module_refcount() isn't reliable outside stop_machine(), as demonstrated
by Karsten Keil <kkeil@suse.de>, networking can trigger it under load
(an inc on one cpu and dec on another while module_refcount() is tallying
 can give false results, for example).

Almost noone should be using __module_get, but that's another issue.

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/module.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -387,7 +387,6 @@ void symbol_put_addr(void *addr);
 static inline void __module_get(struct module *module)
 {
 	if (module) {
-		BUG_ON(module_refcount(module) == 0);
 		local_inc(&module->ref[get_cpu()].count);
 		put_cpu();
 	}

