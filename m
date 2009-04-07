Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbZDGPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbZDGPCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZDGPCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:02:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZDGPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:02:42 -0400
Date: Tue, 7 Apr 2009 07:59:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
In-Reply-To: <alpine.LFD.2.00.0904070751510.4010@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904070759050.4010@localhost.localdomain>
References: <1238839639.3560.37.camel@macbook.infradead.org>  <20090407053739.GA10500@elte.hu>  <1239083045.22733.383.camel@macbook.infradead.org>  <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu>  <1239084280.22733.404.camel@macbook.infradead.org>
  <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>  <20090407090229.GA2467@elte.hu> <1239104035.22733.443.camel@macbook.infradead.org> <alpine.LFD.2.00.0904070751510.4010@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Linus Torvalds wrote:
> 
> Can we please do it something like the following instead:
> 
> 	#define if(a, ...) \
> 		__trace_if( (a, ## __VA_ARGS__) )
> 
> so that you don't need to do that ", ## __VA_ARGS__" thing three times?

IOW, does this (TOTALLY UNTESTED) patch work?

		Linus

---
 include/linux/compiler.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6faa7e5..cebfdcd 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -114,7 +114,9 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
  */
-#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
+#define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
+#define __trace_if(cond) \
+	if (__builtin_constant_p((cond)) ? !!(cond) :			\
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
