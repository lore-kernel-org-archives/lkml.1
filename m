Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYAFUNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYAFUNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAFUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:13:25 -0500
Received: from lixom.net ([66.141.50.11]:32962 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYAFUNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:13:24 -0500
Date: Sun, 6 Jan 2008 14:22:23 -0600
From: Olof Johansson <olof@lixom.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, mpm@selenic.com
Subject: [PATCH] Add bug/warn marker to generic report_bug()
Message-ID: <20080106202223.GA12640@lixom.net>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105190713.73745ec6@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc uses the generic report_bug() from lib/bug.c to report warnings,
and I'm guessing other arches do as well.

Add the module list as well as the end-of-trace marker to the output. This
required making print_oops_end_marker() nonstatic.


Signed-off-by: Olof Johansson <olof@lixom.net>


---

On Sat, Jan 05, 2008 at 07:07:13PM -0800, Arjan van de Ven wrote:
> 3rd try for this patch series; now with a split up patch for __WARN_ON
> 
> This series has the goal of extending the usefulness of the WARN_ON() information,
> at least on architectures that use the generic WARN_ON() infrastructure. (Those who
> do their own thing either already have the extra information, or could consider
> switching to the generic code). In order to do that, WARN_ON() first needs to 
> be uninlined since there's like 1200 callsites and adding code to each of those
> isn't pretty.
> 
> As part of this, I had to split the __WARN_ON patch in -mm into 2 pieces, one to 
> introduce __WARN_ON, and a separate one to do the ifdef cleanup. 

Looks good. The following patch takes care of the warning printout from
powerpc as well. Unfortunately I had to non-staticfy
print_oops_end_marker().


-Olof

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..88d1aa3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -133,6 +133,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
+extern void print_oops_end_marker(void);
 fastcall NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
diff --git a/kernel/panic.c b/kernel/panic.c
index d9e90cf..0269a7f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -281,7 +281,7 @@ static int init_oops_id(void)
 }
 late_initcall(init_oops_id);
 
-static void print_oops_end_marker(void)
+void print_oops_end_marker(void)
 {
 	init_oops_id();
 	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
diff --git a/lib/bug.c b/lib/bug.c
index 530f38f..3aa60a5 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -148,7 +148,9 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 			       "[verbose debug info unavailable]\n",
 			       (void *)bugaddr);
 
+		print_modules();
 		show_regs(regs);
+		print_oops_end_marker();
 		return BUG_TRAP_TYPE_WARN;
 	}
 
