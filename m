Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZHZMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZHZMeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbZHZMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:34:16 -0400
Received: from ozlabs.org ([203.10.76.45]:42725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbZHZMeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:34:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] module: workaround duplicate section names
Date: Wed, 26 Aug 2009 22:04:12 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>
References: <200908262202.54457.rusty@rustcorp.com.au>
In-Reply-To: <200908262202.54457.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262204.13395.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

(This patch leaves other problems, particularly the sections
 directory, but recent parisc toolchains seem to produce these
 modules and this prevents a crash and is a minimal change -- RR).

The root cause is a duplicate section name (.text); is this legal?

However, there's a problem with commit
6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
a mod->sect_attrs (in this case it's null because of the duplication),
it still gets used without checking in add_notes_attrs()

This should fix it

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Helge Deller <deller@gmx.de>
---

diff --git a/kernel/module.c b/kernel/module.c
index fd14114..a703c49 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2353,7 +2353,8 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
-	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+	if (mod->sect_attrs)
+		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Get rid of temporary copy */
 	vfree(hdr);
