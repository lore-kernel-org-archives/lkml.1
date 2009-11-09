Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZKICtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZKICtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZKICtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:49:19 -0500
Received: from ozlabs.org ([203.10.76.45]:59745 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZKICtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:49:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 10/10] module: fix is_exported() to return true for all types of exports
Date: Mon, 9 Nov 2009 13:19:19 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <4AF5DF9F.5020208@tuffmail.co.uk> <1257627841-15817-10-git-send-email-alan-jenkins@tuffmail.co.uk>
In-Reply-To: <1257627841-15817-10-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911091319.20308.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 07:34:01 am Alan Jenkins wrote:
> /proc/kallsyms annotates module symbols as global (e.g. 'D' for a data
> symbol) or local (e.g. 'd'), depending on whether is_exported() returns
> true or false.

Thanks, I've applied the whole series.

Cheers,
Rusty.
PS.  One fix so far:

Fix for CONFIG_MODVERSIONS=n:

kernel/module.c: In function ‘init_ksymtab’:
kernel/module.c:200: warning: initialization makes integer from pointer without a cast
kernel/module.c:201: warning: excess elements in struct initializer
kernel/module.c:201: warning: (near initialization for ‘(anonymous)’)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -194,30 +194,45 @@ extern const unsigned long __start___kcr
 
 static struct ksymtab ksymtab[EXPORT_TYPE_MAX];
 
+#ifdef CONFIG_MODVERSIONS
+#define init_one_ksymtab(ksymt, start, stop, crc_start)	\
+	do {						\
+		struct ksymtab *ks = (ksymt);		\
+		ks->syms = (start);			\
+		ks->num_syms = (stop) - ks->syms;	\
+		ks->crcs = (crc_start);			\
+	} while (0)
+#else
+#define init_one_ksymtab(ksymt, start, stop, crc_start)	\
+	do {						\
+		struct ksymtab *ks = (ksymt);		\
+		ks->syms = (start);			\
+		ks->num_syms = (stop) - ks->syms;	\
+	} while (0)
+#endif
+
 static int __init init_ksymtab(void)
 {
-	ksymtab[EXPORT_TYPE_PLAIN] = (struct ksymtab) {
-		__start___ksymtab, __start___kcrctab,
-		__stop___ksymtab - __start___ksymtab,
-	};
-	ksymtab[EXPORT_TYPE_GPL] = (struct ksymtab) {
-		__start___ksymtab_gpl, __start___kcrctab_gpl,
-		__stop___ksymtab_gpl - __start___ksymtab_gpl,
-	};
+	init_one_ksymtab(&ksymtab[EXPORT_TYPE_PLAIN],
+			 __start___ksymtab, __stop___ksymtab,
+			 __start___kcrctab);
+	init_one_ksymtab(&ksymtab[EXPORT_TYPE_GPL],
+			 __start___ksymtab_gpl, __stop___ksymtab_gpl,
+			 __start___kcrctab_gpl);
 #ifdef CONFIG_UNUSED_EXPORTS
-	ksymtab[EXPORT_TYPE_UNUSED] = (struct ksymtab) {
-		__start___ksymtab_unused, __start___kcrctab_unused,
-		__stop___ksymtab_unused - __start___ksymtab_unused,
-	};
-	ksymtab[EXPORT_TYPE_UNUSED_GPL] = (struct ksymtab) {
-		__start___ksymtab_unused_gpl, __start___kcrctab_unused_gpl,
-		__stop___ksymtab_unused_gpl - __start___ksymtab_unused_gpl,
-	};
+	init_one_ksymtab(&ksymtab[EXPORT_TYPE_UNUSED],
+			 __start___ksymtab_unused,
+			 __stop___ksymtab_unused,
+			 __start___kcrctab_unused);
+	init_one_ksymtab(&ksymtab[EXPORT_TYPE_UNUSED_GPL],
+			 __start___ksymtab_unused_gpl,
+			 __stop___ksymtab_unused_gpl,
+			 __start___kcrctab_unused_gpl);
 #endif
-	ksymtab[EXPORT_TYPE_GPL_FUTURE] = (struct ksymtab) {
-		__start___ksymtab_gpl_future, __start___kcrctab_gpl_future,
-		__stop___ksymtab_gpl_future - __start___ksymtab_gpl_future,
-	};
+	init_one_ksymtab(&ksymtab[EXPORT_TYPE_GPL_FUTURE],
+			 __start___ksymtab_gpl_future,
+			 __stop___ksymtab_gpl_future,
+			 __start___kcrctab_gpl_future);
 
 	return 0;
 }
