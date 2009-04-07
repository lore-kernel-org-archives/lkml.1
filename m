Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZDGDaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZDGDaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZDGD3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:29:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:56519 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZDGD3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:29:49 -0400
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.0904062127420.24008@gandalf.stny.rr.com>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
	 <20090406175918.c38654b2.akpm@linux-foundation.org>
	 <1239066583.22733.258.camel@macbook.infradead.org>
	 <1239067146.22733.260.camel@macbook.infradead.org>
	 <alpine.DEB.2.00.0904062127420.24008@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 20:29:40 -0700
Message-Id: <1239074980.22733.303.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PROFILE_ALL_BRANCHES option causes us to define if() as a macro...
taking precisely one argument. This causes a build failure if the
condition is actually a comma expression -- 'if (a(), b)'.

This patch turns the if() macro into a varargs macro which copes with a
comma expression as its 'arguments'.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>

---
Some might argue that I shouldn't have been using if(a,b) in the first
place, but in my defence it _should_ have worked, and it was less ugly
than the original. I did this:

#define for_each_active_iommu(i, drhd)                                  \
        list_for_each_entry(drhd, &dmar_drhd_units, list)               \
                if (i=drhd->iommu, drhd->ignored) {} else

... instead of what I was originally given, which was (with the first
three macros added to list.h as a generic facility)...

#define list_first_entry_selected(pos, head, member, selector)		  \
	pos = list_entry((head)->next, typeof(*pos), member),		  \
	pos = ({while (!(selector) && (&pos->member != (head)))		  \
		pos = list_entry(pos->member.next, typeof(*pos), member); \
		pos; })
#define list_next_entry_selected(pos, head, member, selector)		  \
	pos = list_entry(pos->member.next, typeof(*pos), member),	  \
	pos = ({while (!(selector) && (&pos->member != (head)))		  \
		pos = list_entry(pos->member.next, typeof(*pos), member); \
		pos; })
#define list_for_each_entry_selected_do(pos, head, member, selector, to_do) \
	for (list_first_entry_selected(pos, head, member, selector),	    \
		({if (&pos->member != (head)) to_do});			    \
		prefetch(pos->member.next), &pos->member != (head);	    \
		list_next_entry_selected(pos, head, member, selector),	    \
		({if (&pos->member != (head)) to_do}))

#define for_each_active_iommu(i, drhd)					\
	list_for_each_entry_selected_do(drhd, &dmar_drhd_units, list,	\
				!drhd->ignored, {i = drhd->iommu; })

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6faa7e5..c28d876 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -114,7 +114,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
  */
-#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
+#define if(cond, ...) if (__builtin_constant_p((cond, ## __VA_ARGS__))	\
+			  ? !!(cond, ## __VA_ARGS__) :			\
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
@@ -125,8 +126,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
-		______r = !!(cond);					\
-		______f.miss_hit[______r]++;					\
+		______r = !!(cond, ## __VA_ARGS__);			\
+		______f.miss_hit[______r]++;				\
 		______r;						\
 	}))
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

