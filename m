Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZBJTJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZBJTJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZBJTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:46 -0500
Received: from kroah.org ([198.145.64.141]:53781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755463AbZBJTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:42 -0500
Date: Tue, 10 Feb 2009 11:00:13 -0800
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
Subject: [patch 17/53] module: remove over-zealous check in __module_get()
Message-ID: <20090210190013.GR14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="module-remove-over-zealous-check-in-__module_get.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
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
@@ -391,7 +391,6 @@ void symbol_put_addr(void *addr);
 static inline void __module_get(struct module *module)
 {
 	if (module) {
-		BUG_ON(module_refcount(module) == 0);
 		local_inc(&module->ref[get_cpu()].count);
 		put_cpu();
 	}

