Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZAJVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZAJVeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZAJVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:34:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:47746 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZAJVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qlrXWnpM3dPhyR+Qk76KvVQQ7YkRZC9Zvc+mdyIAcJUVDcdfno+Rr3bTJvI/buFc5u
         rpaSHmEcR+t9bhWL11aHAWt2o3Lxz6PCRkJtYnYdN0YdP4USmN+sC3KUeGZfqWDOQXrQ
         Xis61nTnWPkU2/oyNnd1+vnu4Z4JJEuftvdXI=
Subject: Re: [PATCH] Disable branch profiling macros when sparsed.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <f19298770901100135m7cd9c6a1k52f92e66e5b41b79@mail.gmail.com>
References: <20090110052727.5471.3654.stgit@zaytsev.su>
	 <20090109.221348.166902734.davem@davemloft.net>
	 <1231571906.5714.30.camel@brick>
	 <f19298770901100135m7cd9c6a1k52f92e66e5b41b79@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 13:33:58 -0800
Message-Id: <1231623238.5714.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 12:35 +0300, Alexey Zaytsev wrote:
> On Sat, Jan 10, 2009 at 10:18, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > On Fri, 2009-01-09 at 22:13 -0800, David Miller wrote:
> >> If even sparse can't handle these things, it's no surprise
> >> how many gcc bogus warning problems we've run into because
> >> of this hairy if() macro.
> >
> > It's not that sparse can't handle it, the warning is valid,
> > _____r and ______f are shadowed when these get nested.  It
> > gets even worse when interacting with likely/unlikely tracing
> > as that chose the same identifiers too.  So there the noise
> > could be drastically reduced changing the different identifiers
> > for the if () and __branch_check macros, but nesting will always
> > warn.
> >
> > I've just been setting this to no in my allyesconfig sparse
> > runs....just wait until kmemtrace gets to mainline, then it
> > gets really bad :(
> >
> 
> I don't really understand what is bad here. The 'unlikely' and 'if'
> trace implementation looks quite elegant to me. Yes, they generate
> 10kbyte spaghetti monsters (in C) for a simple WARN_ON_ONCE(),
> but probably we should just remove a few unlekely() from the WARN_*
> code, and I'm not sure it's even worth it. There would be no direct
> speedup.
> 
> And it took only one line to disable.

I'm not saying anything about ftrace being bad here, it's a pretty
elegant way of doing is.

But instead of disabling it, a patch like the following eliminates
most of the warnings even when enabled, it relies on making the
frace_*_update functions return the condition that is being updated
which removes the need for an _____r temporary.

Also I changed the ______f's to be ______bc/bd (branch check, branch
data)...but those are arbitrary.

Untested other than kills the sparse warnings that are caused by nesting
if(likely())..nested ifs stil warning but only on _____bc which is far
less common.

It's very possible this breaks ftrace or produces shitty code...consider
it just an idea to add an update function that takes/returns the
condition.

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d95da10..e8e85be 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -76,24 +76,21 @@ struct ftrace_branch_data {
  * to disable branch tracing on a per file basis.
  */
 #if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
-void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
+int ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #define likely_notrace(x)	__builtin_expect(!!(x), 1)
 #define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
 
 #define __branch_check__(x, expect) ({					\
-			int ______r;					\
 			static struct ftrace_branch_data		\
 				__attribute__((__aligned__(4)))		\
 				__attribute__((section("_ftrace_annotated_branch"))) \
-				______f = {				\
+				______bc = {				\
 				.func = __func__,			\
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
-			______r = likely_notrace(x);			\
-			ftrace_likely_update(&______f, ______r, expect); \
-			______r;					\
+			ftrace_likely_update(&______bc, likely_notrace(x), expect); \
 		})
 
 /*
@@ -109,27 +106,32 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # endif
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
+
+static inline int ftrace_if_update(struct ftrace_branch_data *bd, int cond)
+{
+	if (cond)
+		bd->hit++;
+	else
+		bd->miss++;
+
+	return cond;
+}
+
 /*
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
  */
 #define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
 	({								\
-		int ______r;						\
 		static struct ftrace_branch_data			\
 			__attribute__((__aligned__(4)))			\
 			__attribute__((section("_ftrace_branch")))	\
-			______f = {					\
+			______bd = {					\
 				.func = __func__,			\
 				.file = __FILE__,			\
 				.line = __LINE__,			\
 			};						\
-		______r = !!(cond);					\
-		if (______r)						\
-			______f.hit++;					\
-		else							\
-			______f.miss++;					\
-		______r;						\
+		ftrace_if_update(&______bd, !!(cond));			\
 	}))
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 6c00feb..385d608 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -165,7 +165,7 @@ void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
-void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
+int ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
 {
 	/*
 	 * I would love to have a trace point here instead, but the
@@ -180,6 +180,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
 		f->correct++;
 	else
 		f->incorrect++;
+
+	return val;
 }
 EXPORT_SYMBOL(ftrace_likely_update);
 





