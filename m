Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYEFLzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYEFLzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYEFLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:55:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYEFLzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:55:37 -0400
Date: Tue, 6 May 2008 13:55:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with
	xf86MapVidMem error
Message-ID: <20080506115524.GE32591@elte.hu>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506020910.GA24041@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Below is the patch to enable debug messages by a boot option 
> "debugpat".

ok, i have applied the patch with some modifications - see below.

Since we build in this code unconditionally also make the flag 
switchable from a sysctl, so that users do not have to reboot to see PAT 
debug messages ...

i have renamed PAT_PRINTK to dprintk.

	Ingo

------------>
Subject: x86: add "debugpat" boot option
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 5 May 2008 19:09:10 -0700

enable debug messages by a boot option "debugpat".

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

Index: linux-x86.q/arch/x86/mm/pat.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pat.c
+++ linux-x86.q/arch/x86/mm/pat.c
@@ -38,6 +38,19 @@ static int nopat(char *str)
 }
 early_param("nopat", nopat);
 
+
+static int debug_enable;
+static int __init pat_debug_setup(char *str)
+{
+	debug_enable = 1;
+	return 0;
+}
+__setup("debugpat", pat_debug_setup);
+
+#define dprintk(fmt, arg...) \
+	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
+
+
 static int pat_known_cpu(void)
 {
 	if (!pat_wc_enabled)
@@ -285,7 +298,7 @@ int reserve_memtype(u64 start, u64 end, 
 		struct memtype *saved_ptr;
 
 		if (parse->start >= end) {
-			pr_debug("New Entry\n");
+			dprintk("New Entry\n");
 			list_add(&new_entry->nd, parse->nd.prev);
 			new_entry = NULL;
 			break;
@@ -335,7 +348,7 @@ int reserve_memtype(u64 start, u64 end, 
 				break;
 			}
 
-			pr_debug("Overlap at 0x%Lx-0x%Lx\n",
+			dprintk("Overlap at 0x%Lx-0x%Lx\n",
 			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, saved_ptr->nd.prev);
@@ -387,7 +400,7 @@ int reserve_memtype(u64 start, u64 end, 
 				break;
 			}
 
-			pr_debug(KERN_INFO "Overlap at 0x%Lx-0x%Lx\n",
+			dprintk("Overlap at 0x%Lx-0x%Lx\n",
 				 saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, &saved_ptr->nd);
@@ -409,16 +422,16 @@ int reserve_memtype(u64 start, u64 end, 
 	if (new_entry) {
 		/* No conflict. Not yet added to the list. Add to the tail */
 		list_add_tail(&new_entry->nd, &memtype_list);
-		pr_debug("New Entry\n");
+		dprintk("New Entry\n");
 	}
 
 	if (ret_type) {
-		pr_debug(
+		dprintk(
 	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
 			start, end, cattr_name(actual_type),
 			cattr_name(req_type), cattr_name(*ret_type));
 	} else {
-		pr_debug(
+		dprintk(
 	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s\n",
 			start, end, cattr_name(actual_type),
 			cattr_name(req_type));
@@ -459,7 +472,7 @@ int free_memtype(u64 start, u64 end)
 			current->comm, current->pid, start, end);
 	}
 
-	pr_debug("free_memtype request 0x%Lx-0x%Lx\n", start, end);
+	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
 	return err;
 }
 
