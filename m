Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbXITHWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbXITHWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXITHWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:22:10 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:39878 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbXITHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:22:08 -0400
Date: Thu, 20 Sep 2007 09:23:28 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Message-ID: <20070920072328.GA5113@devil>
References: <20070918080537.GA14882@devil> <20070919233110.18a057ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919233110.18a057ac.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 11:31:10PM -0700, Andrew Morton wrote:
> On Tue, 18 Sep 2007 10:05:37 +0200 Andreas Herrmann <aherrman@arcor.de> wrote:
> 
> > Fix compile error if !CONFIG_SYSCTL:
> > 
> >     ...
> >   LD      .tmp_vmlinux1
> > net/built-in.o: In function `init_p9':
> > net/9p/mod.c:59: undefined reference to `p9_sysctl_register'
> > net/built-in.o: In function `exit_p9':
> > net/9p/mod.c:75: undefined reference to `p9_sysctl_unregister'
> > make: *** [.tmp_vmlinux1] Error 1
> >     ...
> 
> A better fix would be

But only if you add another
    #endif /* CONFIG_SYSCTL */

Right?
;-)

> 
> --- a/include/net/9p/9p.h~9p-fix-compile-error-if-config_sysctl
> +++ a/include/net/9p/9p.h
> @@ -412,6 +412,17 @@ int p9_idpool_check(int id, struct p9_id
>  
>  int p9_error_init(void);
>  int p9_errstr2errno(char *, int);
> +#ifdef CONFIG_SYSCTL
>  int __init p9_sysctl_register(void);
>  void __exit p9_sysctl_unregister(void);
> +#else
> +static inline int p9_sysctl_register(void)
> +{
> +	return 0;
> +}
> +
> +static inline void p9_sysctl_unregister(void)
> +{
> +}
> +
>  #endif /* NET_9P_H */
> diff -puN net/9p/mod.c~9p-fix-compile-error-if-config_sysctl net/9p/mod.c
> _
> 
> I struggled for five minutes trying to work out how to make CONFIG_SYSCTL
> go away and gave up in disgust.
> 
> God I hate select.

Hmm, you mean to completely avoid "#ifdef CONFIG_SYSCTL" in the net/p9 code?
How about below patch, which just merges net/9p/sysctl.c into net/9p/mod.c.


Regards,

Andreas

--
Merge net/p9/sysctl.c into net/p9/mod.c to avoid build errors
if !CONFIG_SYSCTL.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 include/net/9p/9p.h |    2 -
 net/9p/Makefile     |    4 +--
 net/9p/mod.c        |   54 +++++++++++++++++++++++++++++----
 net/9p/sysctl.c     |   81 ---------------------------------------------------
 4 files changed, 48 insertions(+), 93 deletions(-)
 delete mode 100644 net/9p/sysctl.c

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 88884d3..f69992f 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -412,6 +412,4 @@ int p9_idpool_check(int id, struct p9_idpool *p);
 
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
-int __init p9_sysctl_register(void);
-void __exit p9_sysctl_unregister(void);
 #endif /* NET_9P_H */
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 85b3a78..488026a 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -8,6 +8,4 @@ obj-$(CONFIG_NET_9P) := 9pnet.o
 	conv.o \
 	error.o \
 	fcprint.o \
-	util.o \
-
-9pnet-$(CONFIG_SYSCTL) += sysctl.o
+	util.o
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 4f9e1d2..8d4ce1b 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -24,6 +24,10 @@
  *
  */
 
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sysctl.h>
+#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <net/9p/9p.h>
@@ -37,8 +41,44 @@ MODULE_PARM_DESC(debug, "9P debugging level");
 
 extern int p9_mux_global_init(void);
 extern void p9_mux_global_exit(void);
-extern int p9_sysctl_register(void);
-extern void p9_sysctl_unregister(void);
+
+static struct ctl_table p9_table[] = {
+#ifdef CONFIG_NET_9P_DEBUG
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "debug",
+		.data           = &p9_debug_level,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec
+	},
+#endif
+	{},
+};
+
+static struct ctl_table p9_net_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "9p",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= p9_table,
+	},
+	{},
+};
+
+static struct ctl_table p9_ctl_table[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= p9_net_table,
+	},
+	{},
+};
+
+static struct ctl_table_header *p9_table_header;
 
 /**
  * v9fs_init - Initialize module
@@ -56,13 +96,13 @@ static int __init init_p9(void)
 		return ret;
 	}
 
-	ret = p9_sysctl_register();
-	if (ret) {
+	p9_table_header = register_sysctl_table(p9_ctl_table);
+	if (!p9_table_header) {
 		printk(KERN_WARNING "9p: registering sysctl failed\n");
-		return ret;
+		return -ENOMEM;
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -72,7 +112,7 @@ static int __init init_p9(void)
 
 static void __exit exit_p9(void)
 {
-	p9_sysctl_unregister();
+	unregister_sysctl_table(p9_table_header);
 	p9_mux_global_exit();
 }
 
diff --git a/net/9p/sysctl.c b/net/9p/sysctl.c
deleted file mode 100644
index 8b61027..0000000
--- a/net/9p/sysctl.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- *  net/9p/sysctl.c
- *
- *  9P sysctl interface
- *
- *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/sysctl.h>
-#include <linux/init.h>
-#include <net/9p/9p.h>
-
-static struct ctl_table p9_table[] = {
-#ifdef CONFIG_NET_9P_DEBUG
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "debug",
-		.data           = &p9_debug_level,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec
-	},
-#endif
-	{},
-};
-
-static struct ctl_table p9_net_table[] = {
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "9p",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= p9_table,
-	},
-	{},
-};
-
-static struct ctl_table p9_ctl_table[] = {
-	{
-		.ctl_name	= CTL_NET,
-		.procname	= "net",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= p9_net_table,
-	},
-	{},
-};
-
-static struct ctl_table_header *p9_table_header;
-
-int __init p9_sysctl_register(void)
-{
-	p9_table_header = register_sysctl_table(p9_ctl_table);
-	if (!p9_table_header)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void __exit p9_sysctl_unregister(void)
-{
-	 unregister_sysctl_table(p9_table_header);
-}
-- 
1.5.3


