Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYDAPJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYDAPJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbYDAPJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:09:28 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:5911 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620AbYDAPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SsnZlMW4ZlQnNv0K5+VCn+TIMzXfu1n4pcUVGnJeLxsJyaTGN2SxS0PMUS4/2DPVfjY/s835MjX+1sqFaxyOecxmOVSG9RuPIFpYuRMSWp/j8glpocbWiLM7wtZoKN3EkAyAeEFLouWURWiw82MM8rSRWJvGpwgiyKEXBdJWVfQ=
Date: Tue, 01 Apr 2008 23:06:41 +0800 (CST)
Message-Id: <20080401.230641.146239754.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] arch/um/os-Linux/main.c: Fix memory leaks.
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes possible memory leaks in the main() function of
arch/um/os-Linux/main.c.

Cc: jdike@addtoit.com
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---

Index: linux-2.6/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.orig/arch/um/os-Linux/main.c
+++ linux-2.6/arch/um/os-Linux/main.c
@@ -113,14 +113,10 @@ static void setup_env_path(void)
 
 extern void scan_elf_aux( char **envp);
 
-int __init main(int argc, char **argv, char **envp)
+static char** dup_argv(int argc, char **argv)
 {
+	int i;
 	char **new_argv;
-	int ret, i, err;
-
-	set_stklim();
-
-	setup_env_path();
 
 	new_argv = malloc((argc + 1) * sizeof(char *));
 	if (new_argv == NULL) {
@@ -135,6 +131,28 @@ int __init main(int argc, char **argv, c
 		}
 	}
 	new_argv[argc] = NULL;
+	return new_argv;
+}
+
+static void free_argv(int argc, char **argv)
+{
+	int i;
+	for (i = 0; i < argc; i++) {
+		free(argv[i]);
+	}
+	free(argv);
+}
+
+int __init main(int argc, char **argv, char **envp)
+{
+	char **new_argv;
+	int ret, i, err;
+
+	set_stklim();
+
+	setup_env_path();
+
+	new_argv = dup_argv(argc, argv);
 
 	/*
 	 * Allow these signals to bring down a UML if all other
@@ -185,6 +203,7 @@ int __init main(int argc, char **argv, c
 		perror("Failed to exec kernel");
 		ret = 1;
 	}
+	free_argv(argc, new_argv);
 	printf("\n");
 	return uml_exitcode;
 }
