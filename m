Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbXIRIEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbXIRIEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXIRIET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:04:19 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:36327 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbXIRIER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:04:17 -0400
Date: Tue, 18 Sep 2007 10:05:37 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Message-ID: <20070918080537.GA14882@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error if !CONFIG_SYSCTL:

    ...
  LD      .tmp_vmlinux1
net/built-in.o: In function `init_p9':
net/9p/mod.c:59: undefined reference to `p9_sysctl_register'
net/built-in.o: In function `exit_p9':
net/9p/mod.c:75: undefined reference to `p9_sysctl_unregister'
make: *** [.tmp_vmlinux1] Error 1
    ...

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 include/net/9p/9p.h |    4 ++++
 net/9p/mod.c        |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 88884d3..f723a03 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -412,6 +412,10 @@ int p9_idpool_check(int id, struct p9_idpool *p);
 
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
+
+#ifdef CONFIG_SYSCTL
 int __init p9_sysctl_register(void);
 void __exit p9_sysctl_unregister(void);
+#endif
+
 #endif /* NET_9P_H */
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 4f9e1d2..b4d435c 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -56,11 +56,13 @@ static int __init init_p9(void)
 		return ret;
 	}
 
+#ifdef CONFIG_SYSCTL
 	ret = p9_sysctl_register();
 	if (ret) {
 		printk(KERN_WARNING "9p: registering sysctl failed\n");
 		return ret;
 	}
+#endif
 
 	return ret;
 }
@@ -72,7 +74,9 @@ static int __init init_p9(void)
 
 static void __exit exit_p9(void)
 {
+#ifdef CONFIG_SYSCTL
 	p9_sysctl_unregister();
+#endif
 	p9_mux_global_exit();
 }
 
-- 
1.5.3


