Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYBDPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYBDPto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYBDPth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:49:37 -0500
Received: from saeurebad.de ([85.214.36.134]:35872 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYBDPtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:49:36 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC] Sectionized printk data
Date: Mon, 04 Feb 2008 16:48:34 +0100
Message-ID: <87zlugsox9.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

current approaches to have printk format strings in the corresponding
data section to the function they appear in look like the following (at
least what I have seen so far):

int __init some_function(void)
{
	static char errmsg[] __initdata = "failure %s in %s\n";

        [...]
        printk(errmsg);
        [...]
}

The attached patch allows something along the lines:

int __init some_function(void)
{
        [...]
        pr_init(KERN_WARNING "failure %s in %s\n", ...);
        [...]
}

Another idea I had was to make printk a macro that figures out the
section of the surrounding function and then moves the data
automatically when it is a literal, but I couldn't find mechanisms that
allow this.  Anyone of you got an idea?

What do you think in general?

	Hannes

---
From: Johannes Weiner <hannes@saeurebad.de>

Sectionized printk wrappers

Introduce printk wrappers that place format string literals in init/exit
data sections.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
The place for these wrappers is probably very wrong.  Suggestions
welcome.

	<Imagine diff-stat here>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ff356b2..6a1355d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -192,7 +192,22 @@ static inline int __cold printk(const char *s, ...) { return 0; }
 static inline int log_buf_get_len(void) { return 0; }
 static inline int log_buf_read(int idx) { return 0; }
 static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
-#endif
+
+/* Sectionized printk constant data */
+#include <linux/init.h>
+#define pr_section(sec, fmt, args...) ({		\
+	static const char __fmt[] sec = fmt;		\
+	printk(__fmt, ## args);				\
+})
+#define pr_init(fmt, args)	pr_section(__initdata, fmt, ## args)
+#define pr_exit(fmt, args)	pr_section(__exitdata, fmt, ## args)
+#define pr_devinit(fmt, args)	pr_section(__devinitdata, fmt, ## args)
+#define pr_devexit(fmt, args)	pr_section(__devexitdata, fmt, ## args)
+#define pr_cpuinit(fmt, args)	pr_section(__cpuinitdata, fmt, ## args)
+#define pr_cpuexit(fmt, args)	pr_section(__cpuexitdata, fmt, ## args)
+#define pr_meminit(fmt, args)	pr_section(__meminitdata, fmt, ## args)
+#define pr_memexit(fmt, args)	pr_section(__memexitdata, fmt, ## args)
+#endif /* CONFIG_PRINTK */
 
 extern void __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
