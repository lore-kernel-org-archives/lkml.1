Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZBGHqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZBGHqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 02:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZBGHqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 02:46:08 -0500
Received: from ozlabs.org ([203.10.76.45]:57743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZBGHqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 02:46:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] module: remove over-zealous check in __module_get()
Date: Sat, 7 Feb 2009 18:15:56 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Karsten Keil <kkeil@suse.de>,
       stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071815.56926.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix spurious BUG_ON() triggered under load

module_refcount() isn't reliable outside stop_machine(), as demonstrated
by Karsten Keil <kkeil@suse.de>, networking can trigger it under load
(an inc on one cpu and dec on another while module_refcount() is tallying
 can give false results, for example).

Almost noone should be using __module_get, but that's another issue.

Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -407,7 +407,6 @@ static inline void __module_get(struct m
 static inline void __module_get(struct module *module)
 {
 	if (module) {
-		BUG_ON(module_refcount(module) == 0);
 		local_inc(__module_ref_addr(module, get_cpu()));
 		put_cpu();
 	}
