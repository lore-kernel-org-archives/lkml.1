Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZKJCU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZKJCU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZKJCU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:20:57 -0500
Received: from ozlabs.org ([203.10.76.45]:55726 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbZKJCU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:20:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build warnings
Date: Tue, 10 Nov 2009 12:50:58 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <20091109183104.2bf7add6.sfr@canb.auug.org.au> <20091109184046.2a802372.sfr@canb.auug.org.au>
In-Reply-To: <20091109184046.2a802372.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911101250.58516.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 06:10:46 pm Stephen Rothwell wrote:
> I am also getting some section mismatch warnings like this:
> 
> WARNING: drivers/mtd/ubi/ubi.o(.data+0x1c0): Section mismatch in reference from the variable __ops_mtd to the function .init.text:ubi_mtd_param_parse()
> The variable __ops_mtd references
> the function __init ubi_mtd_param_parse()

Right.  This needs a new rule in modpost; here's what I've added:

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -97,10 +97,10 @@ struct kparam_array
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
-	static struct kernel_param_ops __ops_##name =			\
+	static struct kernel_param_ops __param_ops_##name =		\
 		 { (void *)set, (void *)get };				\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
-			    name, &__ops_##name, arg,			\
+			    name, &__param_ops_##name, arg,		\
 			    __same_type(*(arg), bool),			\
 			    (perm) + sizeof(__check_old_set_param(set))*0)
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -951,6 +951,13 @@ static int section_mismatch(const char *
  *   fromsec = .data*
  *   atsym   =__param*
  *
+ * Pattern 1a:
+ *   module_param_call() ops can refer to __init set function if permissions=0
+ *   The pattern is identified by:
+ *   tosec   = .init.text
+ *   fromsec = .data*
+ *   atsym   = __param_ops_*
+ *
  * Pattern 2:
  *   Many drivers utilise a *driver container with references to
  *   add, remove, probe functions etc.
@@ -984,6 +991,12 @@ static int secref_whitelist(const char *
 	    (strncmp(fromsym, "__param", strlen("__param")) == 0))
 		return 0;
 
+	/* Check for pattern 1a */
+	if (strcmp(tosec, ".init.text") == 0 &&
+	    match(fromsec, data_sections) &&
+	    (strncmp(fromsym, "__param_ops_", strlen("__param_ops_")) == 0))
+		return 0;
+
 	/* Check for pattern 2 */
 	if (match(tosec, init_exit_sections) &&
 	    match(fromsec, data_sections) &&


