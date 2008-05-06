Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbYEFCJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbYEFCJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYEFCJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:09:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:37007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbYEFCJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,440,1204531200"; 
   d="scan'208";a="278216689"
Date: Mon, 5 May 2008 19:09:10 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Rufus & Azrael <rufus-azrael@numericable.fr>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Message-ID: <20080506020910.GA24041@linux-os.sc.intel.com>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505234938.GB11433@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:49:39AM +0200, Ingo Molnar wrote:
> 
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > Which seems to be mapping framebuffer successfully.
> > 
> > Can you please try the patch below and capture the dmesg after you get 
> > the above xf86MapVidMem error and send it. That should give us more 
> > information on the failure.
> 
> > +#define	DEBUG
> 
> btw., could we turn this into a /debug or sysctl flag thing, to make it 
> easier for people to get these debug messages?
> 

Below is the patch to enable debug messages by a boot option "debugpat".

We are also planning to a /proc or /debug entry to dump the memtype
list at runtime rather than depending on full dmesg. Will send the patch soon.

Thanks,
Venki



Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-05-05 18:27:30.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-05-05 18:28:38.000000000 -0700
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
+#define PAT_PRINTK(fmt, arg...) \
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
+			PAT_PRINTK("New Entry\n");
 			list_add(&new_entry->nd, parse->nd.prev);
 			new_entry = NULL;
 			break;
@@ -335,7 +348,7 @@ int reserve_memtype(u64 start, u64 end, 
 				break;
 			}
 
-			pr_debug("Overlap at 0x%Lx-0x%Lx\n",
+			PAT_PRINTK("Overlap at 0x%Lx-0x%Lx\n",
 			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, saved_ptr->nd.prev);
@@ -387,7 +400,7 @@ int reserve_memtype(u64 start, u64 end, 
 				break;
 			}
 
-			pr_debug(KERN_INFO "Overlap at 0x%Lx-0x%Lx\n",
+			PAT_PRINTK("Overlap at 0x%Lx-0x%Lx\n",
 				 saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, &saved_ptr->nd);
@@ -409,16 +422,16 @@ int reserve_memtype(u64 start, u64 end, 
 	if (new_entry) {
 		/* No conflict. Not yet added to the list. Add to the tail */
 		list_add_tail(&new_entry->nd, &memtype_list);
-		pr_debug("New Entry\n");
+		PAT_PRINTK("New Entry\n");
 	}
 
 	if (ret_type) {
-		pr_debug(
+		PAT_PRINTK(
 	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
 			start, end, cattr_name(actual_type),
 			cattr_name(req_type), cattr_name(*ret_type));
 	} else {
-		pr_debug(
+		PAT_PRINTK(
 	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s\n",
 			start, end, cattr_name(actual_type),
 			cattr_name(req_type));
@@ -459,7 +472,7 @@ int free_memtype(u64 start, u64 end)
 			current->comm, current->pid, start, end);
 	}
 
-	pr_debug("free_memtype request 0x%Lx-0x%Lx\n", start, end);
+	PAT_PRINTK("free_memtype request 0x%Lx-0x%Lx\n", start, end);
 	return err;
 }
 
