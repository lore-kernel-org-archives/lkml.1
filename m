Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZBGMsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZBGMsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZBGMqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:46 -0500
Received: from ozlabs.org ([203.10.76.45]:45015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZBGMqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:44 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 9/9] module: remove the SHF_ALLOC flag on the __versions section.
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Message-Id: <20090207124643.0829DDDDED@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: reduce kernel memory usage

This patch just takes off the SHF_ALLOC flag on __versions so we don't
keep them around after module load.

This saves about 7% of module memory if CONFIG_MODVERSIONS=y.

Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1928,6 +1928,9 @@ static noinline struct module *load_modu
 		if (strstarts(secstrings+sechdrs[i].sh_name, ".exit"))
 			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
+		/* Don't keep __versions around; it's just for loading. */
+		if (strcmp(secstrings + sechdrs[i].sh_name, "__versions") == 0)
+			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 
 	modindex = find_sec(hdr, sechdrs, secstrings,

