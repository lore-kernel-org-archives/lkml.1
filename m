Return-Path: <linux-kernel-owner+w=401wt.eu-S934251AbYEFWwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbYEFWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbYEFWvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:51:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:20942 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbYEFWvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:51:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="242969009"
Date: Tue, 6 May 2008 15:51:40 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Rufus & Azrael <rufus-azrael@numericable.fr>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Message-ID: <20080506225140.GB18706@linux-os.sc.intel.com>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506115524.GE32591@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:55:24PM +0200, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > Below is the patch to enable debug messages by a boot option 
> > "debugpat".
> 
> ok, i have applied the patch with some modifications - see below.
> 
> Since we build in this code unconditionally also make the flag 
> switchable from a sysctl, so that users do not have to reboot to see PAT 
> debug messages ...
> 

Below patch adds the sysctl interface.

Thanks,
Venki


Add sysctl interface to runtime change debugpat setting.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c      |    6 +++---
 include/linux/kernel.h |    1 +
 kernel/sysctl.c        |    8 ++++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-05-06 10:52:51.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-05-06 15:27:59.000000000 -0700
@@ -39,16 +39,16 @@ static int nopat(char *str)
 early_param("nopat", nopat);
 
 
-static int debug_enable;
+int pat_debug_enable = 0;
 static int __init pat_debug_setup(char *str)
 {
-	debug_enable = 1;
+	pat_debug_enable = 1;
 	return 0;
 }
 __setup("debugpat", pat_debug_setup);
 
 #define dprintk(fmt, arg...) \
-	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
+	do { if (pat_debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
 
 
 static int pat_known_cpu(void)
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h	2008-05-02 09:45:26.000000000 -0700
+++ linux-2.6/include/linux/kernel.h	2008-05-06 10:54:06.000000000 -0700
@@ -239,6 +239,7 @@ extern int tainted;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned);
 extern int root_mountflags;
+extern int pat_debug_enable;
 
 /* Values used for system_state */
 extern enum system_states {
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2008-05-02 09:45:26.000000000 -0700
+++ linux-2.6/kernel/sysctl.c	2008-05-06 10:55:08.000000000 -0700
@@ -685,6 +685,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "debugpat",
+		.data		= &pat_debug_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 #if defined(CONFIG_MMU)
 	{
