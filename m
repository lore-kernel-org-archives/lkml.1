Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZI2G2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZI2G2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 02:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZI2G2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 02:28:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZI2G2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 02:28:19 -0400
Date: Mon, 28 Sep 2009 23:27:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
Message-Id: <20090928232748.c41eeb5b.akpm@linux-foundation.org>
In-Reply-To: <4AC1A6FB.1080304@suse.de>
References: <4AC1A6FB.1080304@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 11:49:39 +0530 Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Hi all,
> 
> On Thu, Sep 10, 2009 at 11:31 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
> >
> >   http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> >   git://git.zen-sources.org/zen/mmotm.git
> >
> 
> With this snapshot plus fixes, I'm unable to limit the memory using the
> kernel command line switch "mem=nn" on a x86_64 box. Is this the
> expected behavior?
> 
> Using "cgroup_disable=memory" together with "mem=nn" switch didn't help.
> Am I supposed to use some other switch along with this?
> 

hm, perhaps that -mm was needing this?


commit eda6da9286ad5b35b1eb70f6368958a8ee41a9dd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat Sep 19 11:07:57 2009 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat Sep 19 20:31:33 2009 +0200

    Revert 'x86: Fix system crash when loading with "reservetop" parameter'
    
    After close looking, commit 8126dec3 will break:
    
     1. some cpu feature  in early stage too, like cpu_has_x2apic
     2. will break built-in-command line
     3. will break other memmap= and mem=
     4. early_dbgp and early_console that will use early_ioremap to access mmio (?)
    
    So revert it.
    
    Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
    Cc: Linus Torvalds <torvalds@linux-foundation.org>,
    Cc: Andrew Morton <akpm@linux-foundation.org>,
    LKML-Reference: <4AB51DFD.2000904@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 19f15c4..f5baa2a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -712,21 +712,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
-#ifdef CONFIG_X86_64
-	/*
-	 * Must call this twice: Once just to detect whether hardware doesn't
-	 * support NX (so that the early EHCI debug console setup can safely
-	 * call set_fixmap(), and then again after parsing early parameters to
-	 * honor the respective command line option.
-	 */
-	check_efer();
-#endif
-
-	parse_early_param();
-
 	/* VMI may relocate the fixmap; do this before touching ioremap area */
 	vmi_init();
 
@@ -809,6 +794,21 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Must call this twice: Once just to detect whether hardware doesn't
+	 * support NX (so that the early EHCI debug console setup can safely
+	 * call set_fixmap(), and then again after parsing early parameters to
+	 * honor the respective command line option.
+	 */
+	check_efer();
+#endif
+
+	parse_early_param();
+
 #ifdef CONFIG_X86_64
 	check_efer();
 #endif

