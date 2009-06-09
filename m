Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZFINsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZFINsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZFINq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:58 -0400
Received: from mx1.emlix.com ([193.175.82.87]:55131 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/8] lib: isolate rational fractions helper function
Date: Tue,  9 Jun 2009 15:46:49 +0200
Message-Id: <1244555211-15618-7-git-send-email-os@emlix.com>
In-Reply-To: <1244555211-15618-6-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
 <1244555211-15618-2-git-send-email-os@emlix.com>
 <1244555211-15618-3-git-send-email-os@emlix.com>
 <1244555211-15618-4-git-send-email-os@emlix.com>
 <1244555211-15618-5-git-send-email-os@emlix.com>
 <1244555211-15618-6-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a helper function to determine optimum numerator
denominator value pairs taking into account restricted
register size. Useful especially with PLL and other clock
configurations.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 include/linux/rational.h |   19 ++++++++++++++
 lib/Kconfig              |    3 ++
 lib/Makefile             |    1 +
 lib/rational.c           |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/rational.h
 create mode 100644 lib/rational.c

diff --git a/include/linux/rational.h b/include/linux/rational.h
new file mode 100644
index 0000000..4f532fc
--- /dev/null
+++ b/include/linux/rational.h
@@ -0,0 +1,19 @@
+/*
+ * rational fractions
+ *
+ * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <os@emlix.com>
+ *
+ * helper functions when coping with rational numbers,
+ * e.g. when calculating optimum numerator/denominator pairs for
+ * pll configuration taking into account restricted register size
+ */
+
+#ifndef _LINUX_RATIONAL_H
+#define _LINUX_RATIONAL_H
+
+void rational_best_approximation(
+	unsigned long given_numerator, unsigned long given_denominator,
+	unsigned long max_numerator, unsigned long max_denominator,
+	unsigned long *best_numerator, unsigned long *best_denominator);
+
+#endif /* _LINUX_RATIONAL_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 8ade0a7..9960be0 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -10,6 +10,9 @@ menu "Library routines"
 config BITREVERSE
 	tristate
 
+config RATIONAL
+	boolean
+
 config GENERIC_FIND_FIRST_BIT
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index 33a40e4..1f6edef 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -50,6 +50,7 @@ ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
 endif
 
 obj-$(CONFIG_BITREVERSE) += bitrev.o
+obj-$(CONFIG_RATIONAL)	+= rational.o
 obj-$(CONFIG_CRC_CCITT)	+= crc-ccitt.o
 obj-$(CONFIG_CRC16)	+= crc16.o
 obj-$(CONFIG_CRC_T10DIF)+= crc-t10dif.o
diff --git a/lib/rational.c b/lib/rational.c
new file mode 100644
index 0000000..76f5a0c
--- /dev/null
+++ b/lib/rational.c
@@ -0,0 +1,60 @@
+/*
+ * rational fractions
+ *
+ * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <os@emlix.com>
+ *
+ * helper functions when coping with rational numbers
+ */
+
+#include <linux/rational.h>
+
+/*
+ * calculate best rational approximation for a given fraction
+ * taking into account restricted register size, e.g. to find
+ * appropriate values for a pll with 5 bit denominator and
+ * 8 bit numerator register fields, trying to set up with a
+ * frequency ratio of 3.1415, one would say:
+ *
+ * rational_best_approximation(31415, 10000,
+ *		(1 << 8) - 1, (1 << 5) - 1, &n, &d);
+ *
+ * you may look at given_numerator as a fixed point number,
+ * with the fractional part size described in given_denominator.
+ *
+ * for theoretical background, see:
+ * http://en.wikipedia.org/wiki/Continued_fraction
+ */
+
+void rational_best_approximation(
+	unsigned long given_numerator, unsigned long given_denominator,
+	unsigned long max_numerator, unsigned long max_denominator,
+	unsigned long *best_numerator, unsigned long *best_denominator)
+{
+	unsigned long n, d, n0, d0, n1, d1;
+	n = given_numerator;
+	d = given_denominator;
+	n0 = d1 = 0;
+	n1 = d0 = 1;
+	for (;;) {
+		unsigned long t, a;
+		if ((n1 > max_numerator) || (d1 > max_denominator)) {
+			n1 = n0;
+			d1 = d0;
+			break;
+		}
+		if (d == 0)
+			break;
+		t = d;
+		a = n / d;
+		d = n % d;
+		n = t;
+		t = n0 + a * n1;
+		n0 = n1;
+		n1 = t;
+		t = d0 + a * d1;
+		d0 = d1;
+		d1 = t;
+	}
+	*best_numerator = n1;
+	*best_denominator = d1;
+}
-- 
1.5.3.7

