Return-Path: <linux-kernel-owner+w=401wt.eu-S933764AbZJGCEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbZJGCEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZJGCEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:04:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZJGCEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:04:00 -0400
Subject: Re: system gets stuck in a lock during boot
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: Justin Mattock <justinmattock@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091006203225.GC2631@redhat.com>
References: <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>
	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>
	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>
	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>
	 <20091002211211.GA2633@redhat.com>
	 <1254792249.13160.213.camel@gandalf.stny.rr.com>
	 <20091006203225.GC2631@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 22:02:01 -0400
Message-Id: <1254880921.1696.112.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 16:32 -0400, Jason Baron wrote:

> So the problem I'm seeing is an oops on boot caused by the call->system pointer
> deference in event_create_dir(). The 'call' variable is of type 'struct
> ftrace_event_call'. 
> 
> What's going on is that the 'struct ftrace_event_call' is of size 168 bytes
> (sizeof(struct ftrace_event_call)) = 168 = 0xA8. However, in memory the
> structures are 16-byte aligned. Thus, the stride for walking through the
> pointers needs to be 176 (0xB0), but instead its 168 causing the oops.
> 
> I've only seen this issue while using gcc (GCC) 4.5.0 20090916, on a
> vanilla 2.6.31 kernel.
> 
> That said, I'm not sure the compiler is doing the wrong thing here. The
> 'struct ftrace_event_call' contains an embedded 'struct list_head' which
> is 16 bytes. According to the gcc docs, the aligned attribute, 'specifies a
> minimum alignment for the variable or structure field, measured in bytes'.
> Thus, at least according to the docs, gcc can increase the alignment of the
> 'struct ftrace_event_call', from its original specification of 4, to 16. Even
> in the case where we are working corectly the structures are 8-byte aligned.
> 
> Thus, I would reccommend the patch below as a preventive measure. Its
> the minimal patch I've found to resolve this issue. In general, if we
> are going to walk data structures embedded in a special elf section, I
> think the general rules needs to be to set the alignment to the power of
> two which is greater than or equal to the largest item in the structure.
> 
> thanks,
> 
> -Jason
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index a81170d..7182f03 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -124,7 +124,10 @@ struct ftrace_event_call {
>  	atomic_t		profile_count;
>  	int			(*profile_enable)(struct ftrace_event_call *);
>  	void			(*profile_disable)(struct ftrace_event_call *);
> -};
> +} __attribute__((aligned(16)));
> +
> +/* Align to the largest field in the data structure:
> + * sizeof(struct list_head) = 16 */

Is this true for i386?

I just tried this patch and it seems to work. Can you give it a try.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4ec5e67..044b70d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -133,7 +133,7 @@ struct ftrace_event_call {
 	atomic_t		profile_count;
 	int			(*profile_enable)(void);
 	void			(*profile_disable)(void);
-};
+} __attribute__((aligned(sizeof(struct list_head))));
 
 #define FTRACE_MAX_PROFILE_SIZE	2048
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc0d966..31e7637 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -501,7 +501,6 @@ static void ftrace_profile_disable_##call(void)				\
  * }
  *
  * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.system			= "<system>",
@@ -619,7 +618,6 @@ static int ftrace_raw_init_event_##call(void)				\
 }									\
 									\
 static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\


