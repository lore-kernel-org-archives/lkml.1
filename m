Return-Path: <linux-kernel-owner+w=401wt.eu-S966098AbXEKVIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966098AbXEKVIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbXEKVH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:07:56 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36002 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463AbXEKVHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:07:55 -0400
Date: Fri, 11 May 2007 23:08:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] kbuild: silence section mismatch warnings
Message-ID: <20070511210850.GA382@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Forwarded message from Sam Ravnborg <sam@ravnborg.org> -----

Forgot lkml in first mail...

	Sam

Subject: [RFC PATCH] kbuild: silence section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 11 May 2007 23:03:46 +0200
User-Agent: Mutt/1.4.2.1i
To: Chris Wedgwood <cw@f00f.org>, Andrew Morton <akpm@osdl.org>,
	"David S. Miller" <davem@redhat.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Satyam Sharma <satyam.sharma@gmail.com>
Cc: sam@ravnborg.org

Following patch allow us in specific places to silence section mismatch warnings.
There is a few legitime places that modpost does not yet recognize where
reference from .text to .init.text (likewise for data) are legitime.
This allow us to spot the few places and annotate them so we do not
get false warnings that in the end will let real warnings pass.

The annotation is simple to grep for so revieing all uses in a few
months time are trivial. It is assumed that a few places will
use this to shut up the warning as replacement for the real fix.
But these cases are esay to spot and to fix up.

With this and the following two patches I have a section mismatch free
build.
The plan is that a section mismatch soon will graduate from a warning to an error.
This will hurt a few drives but then they have an incentive to fix it up.

Comments welcome.

	Sam

diff --git a/include/linux/init.h b/include/linux/init.h
index 8bc32bb..3b63be5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -45,6 +45,17 @@
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
 #define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
 
+/* modpost check for references from .text to .init.text and likewise
+ * from .data to .init.data. They are in most cases sign of bugs but
+ * in a few places this is OK. The following can be used to tell
+ * modpost that such a reference is OK.
+ * For references to .exit.text and .exit.data the same annotation
+ * will silence warnings from modpost.
+ */
+#define __init_refok     noinline __attribute__ ((__section__ (".text_initrefok")))
+#define __initdata_refok noinline __attribute__ ((__section__ (".data_initrefok")))
+
+
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
 #else
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..986200b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -582,6 +582,14 @@ static int strrcmp(const char *s, const char *sub)
 
 /**
  * Whitelist to allow certain references to pass with no warning.
+ *
+ * Pattern 0:
+ *   Functions tagged with __init_refok => section .text_initrefok
+ *   and data tagged with __initdata_refok => section .data_initrefok
+ *   are marked so to tell modpost that they indeed may reference
+ *   functions/data in the init and exit sections.
+ *   So do not warn in these cases.
+ *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
  *   then this is legal despite the warning generated.
@@ -683,6 +691,10 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		"zone_wait_table_init",
 		NULL
 	};
+	/* Check for pattern 0 */
+	if ((strcmp(fromsec, ".text_initrefok") == 0) ||
+	    (strcmp(fromsec, ".data_initrefok") == 0))
+		return 1;
 
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)

----- End forwarded message -----
