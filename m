Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZFPER2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZFPER2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZFPERV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:17:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbZFPERV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:17:21 -0400
Date: Mon, 15 Jun 2009 21:16:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] WARN(): add a \n to the message printk
In-Reply-To: <alpine.LFD.2.01.0906152055580.3282@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906152114070.3282@localhost.localdomain>
References: <20090615000822.6e6bf282@infradead.org> <alpine.LFD.2.01.0906150933330.3305@localhost.localdomain> <alpine.LFD.2.01.0906150945490.3305@localhost.localdomain> <20090615171044.GC25760@elte.hu>
 <alpine.LFD.2.01.0906152055580.3282@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Linus Torvalds wrote:
> 
> And no, this does not necessarily fix Arjan's problem: it only adds the 
> newline before printk's that _do_ have a KERN_<lvl> format. So now, in 
> order to get the extra '\n' after the WARN_ON() line, somebody needs to 
> make sure that the printk's in the warning printing have loglevels.
> 
> Arjan?

The "print_modules()" function needs a KERN_WARNING in front of it.

Or something like this (on top of the patch I just sent out), which allows 
you to specify loglevel that is just the default one, whatever that 
happens to be. Using KERN_DEFAULT, of course.

Hmm?

		Linus

---
 include/linux/kernel.h |    2 ++
 kernel/module.c        |    2 +-
 kernel/printk.c        |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 066bb1e..1b2e174 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -97,6 +97,8 @@ extern const char linux_proc_banner[];
 #define	KERN_INFO	"<6>"	/* informational			*/
 #define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
 
+/* Use the default kernel loglevel */
+#define KERN_DEFAULT	"<d>"
 /*
  * Annotation for a "continued" line of log printout (only done after a
  * line that had no enclosing \n). Only to be used by core/arch code
diff --git a/kernel/module.c b/kernel/module.c
index e4ab36c..215aaab 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2899,7 +2899,7 @@ void print_modules(void)
 	struct module *mod;
 	char buf[8];
 
-	printk("Modules linked in:");
+	printk(KERN_DEFAULT "Modules linked in:");
 	/* Most callers should already have preempt disabled, but make sure */
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list)
diff --git a/kernel/printk.c b/kernel/printk.c
index a87770c..b4d97b5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -696,6 +696,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			switch (c) {
 			case '0' ... '7': /* loglevel */
 				current_log_level = c - '0';
+			/* Fallthrough - make sure we're on a new line */
+			case 'd': /* KERN_DEFAULT */
 				if (!new_text_line) {
 					emit_log_char('\n');
 					new_text_line = 1;
