Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbZIDDsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbZIDDsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 23:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932556AbZIDDsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 23:48:45 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:62973 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbZIDDsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 23:48:45 -0400
X-Greylist: delayed 1587 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 23:48:45 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=glojybIfzTZK06wbkqy+RtNw+z93QAPiuEGhQ+vnIuppt7kvZOYH/mmnmhqAJZqRUD
         KN3UJXYChWWp4hFr4nGJ2JYaAAWe5XgxqhbW+d3MO0depD4EEVA56PfLCvuWw6cSS7R1
         nqL4v2iE6zzcPm2CcZxdyN+KCOUFME+bt1ddA=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] fix "no member named 'sect_attrs' of strcut module"
Date: Fri,  4 Sep 2009 11:48:28 +0800
Message-Id: <1252036108-24221-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

The commit(1b364bf438cf337a3818aee77d68c0713f3e1fc4, "module: workaround
duplicate section names") introduced a condition to avoid null pointer
reference:

-       add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+       if (mod->sect_attrs)
+               add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);

but sect_attrs is only defined when CONFIG_KALLSYMS enabled, so this
patch is need to fix the following error:

error: 'struct module' has no member named 'sect_attrs'

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index eccb561..b4016d1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2355,8 +2355,10 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+#ifdef CONFIG_KALLSYMS
 	if (mod->sect_attrs)
 		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+#endif
 
 	/* Get rid of temporary copy */
 	vfree(hdr);
-- 
1.6.2.1

