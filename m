Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0CAVHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:07:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0CAVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:07:08 -0500
Date: Mon, 1 Mar 2010 16:05:22 -0500
From: Jason Baron <jbaron@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 08/12] syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
Message-ID: <20100301210522.GA2676@redhat.com>
References: <cover.1267214186.git.jbaron@redhat.com> <4aefea222db757a76ca70f20b6165e5084b99e8e.1267214186.git.jbaron@redhat.com> <20100228100902.GA2330@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228100902.GA2330@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 11:09:02AM +0100, Heiko Carstens wrote:
> On Fri, Feb 26, 2010 at 04:37:30PM -0500, Jason Baron wrote:
> > Add COMPAT_SYSCALL_DEFINE#N() macro define common compat syscalls that
> > are not arch specific. Prepends "compat_sys_" to the syscall name to identify
> > it.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > ---
> >  include/linux/syscalls.h |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index cd7b959..241a19c 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -228,6 +228,13 @@ struct perf_event_attr;
> >  #define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, arch_compat_sys_##name, __VA_ARGS__)
> >  #define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, arch_compat_sys_##name, __VA_ARGS__)
> > 
> > +#define COMPAT_SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, compat_sys_##name, __VA_ARGS__)
> > +#define COMPAT_SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, compat_sys_##name, __VA_ARGS__)
> > +#define COMPAT_SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, compat_sys_##name, __VA_ARGS__)
> > +#define COMPAT_SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, compat_sys_##name, __VA_ARGS__)
> > +#define COMPAT_SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, compat_sys_##name, __VA_ARGS__)
> > +#define COMPAT_SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, compat_sys_##name, __VA_ARGS__)
> > +
> 
> For architectures which select CONFIG_HAVE_SYSCALL_WRAPPERS this adds
> unnecessary sign extension code to each compat syscall.
> On the other hand we could get rid partly of the arch specific sign extension
> code but that would need some other changes before as well.
> For example this one:
> 
> asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
>                 struct timezone __user *tz)
> 
> should be converted to a function which takes two compat_uptr_t's and let
> the syscall code itself do the proper pointer conversion (compat_ptr()).
> 
> Besides that the syscall alias names for these compat calls do look a
> bit strange:
> 
> 000000000008b57c T SyScompat_sys_adjtimex
> 000000000008b57c T compat_sys_adjtimex
> 
> That needs to be fixed as well.
> Or simply add a 1:1 wrapper independent of CONFIG_HAVE_SYSCALL_WRAPPERS.

ok, the later suggestion seems simpler. Below I've re-spun patch #6 and
#8. how do they look?

thanks,

-Jason

patch 6/12:

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e601985..39cc67b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -141,7 +141,7 @@ struct perf_event_attr;
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
-		.name                   = "sys_enter"#sname,		\
+		.name                   = "enter_"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
@@ -163,7 +163,7 @@ struct perf_event_attr;
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
-		.name                   = "sys_exit"#sname,		\
+		.name                   = "exit_"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
@@ -181,7 +181,7 @@ struct perf_event_attr;
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
-		.name 		= "sys"#sname,			\
+		.name 		= #sname,			\
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
@@ -194,20 +194,20 @@ struct perf_event_attr;
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
+	SYSCALL_TRACE_ENTER_EVENT(sys_##sname);			\
+	SYSCALL_TRACE_EXIT_EVENT(sys_##sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta__##sname = {				\
+	  __syscall_meta_sys_##sname = {			\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
 		.ftrace_enter	= 0,				\
 		.ftrace_exit	= 0,				\
 		.perf_enter	= 0,				\
 		.perf_exit	= 0,				\
-		.enter_event	= &event_enter__##sname,	\
-		.exit_event	= &event_exit__##sname,		\
+		.enter_event	= &event_enter_sys_##sname,	\
+		.exit_event	= &event_exit_sys_##sname,	\
 	};							\
 	asmlinkage long sys_##sname(void)
 #else
@@ -221,6 +221,32 @@ struct perf_event_attr;
 #define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
+#ifdef CONFIG_COMPAT
+
+#define ARCH_COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, arch_compat_sys_##name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, arch_compat_sys_##name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, arch_compat_sys_##name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, arch_compat_sys_##name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, arch_compat_sys_##name, __VA_ARGS__)
+#define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, arch_compat_sys_##name, __VA_ARGS__)
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)			\
+	static const char *types_##sname[] = {			\
+		__SC_STR_TDECL##x(__VA_ARGS__)			\
+	};							\
+	static const char *args_##sname[] = {			\
+		__SC_STR_ADECL##x(__VA_ARGS__)			\
+	};							\
+	SYSCALL_METADATA(sname, x);				\
+	asmlinkage long sname(__SC_DECL##x(__VA_ARGS__))
+#else
+#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)			\
+	asmlinkage long sname(__SC_DECL##x(__VA_ARGS__))
+#endif
+
+#endif
+
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
 	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name "\n"	\
@@ -237,13 +263,13 @@ struct perf_event_attr;
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define SYSCALL_DEFINEx(x, sname, ...)				\
-	static const char *types_##sname[] = {			\
+	static const char *types_sys##sname[] = {		\
 		__SC_STR_TDECL##x(__VA_ARGS__)			\
 	};							\
-	static const char *args_##sname[] = {			\
+	static const char *args_sys##sname[] = {		\
 		__SC_STR_ADECL##x(__VA_ARGS__)			\
 	};							\
-	SYSCALL_METADATA(sname, x);				\
+	SYSCALL_METADATA(sys##sname, x);			\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 #else
 #define SYSCALL_DEFINEx(x, sname, ...)				\


patch 8/12:


diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 39cc67b..7b4c746 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -230,6 +230,13 @@ struct perf_event_attr;
 #define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, arch_compat_sys_##name, __VA_ARGS__)
 #define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, arch_compat_sys_##name, __VA_ARGS__)
 
+#define COMPAT_SYSCALL_DEFINE1(name, ...) COMPAT_SYSCALL_DEFINEx(1, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2(name, ...) COMPAT_SYSCALL_DEFINEx(2, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3(name, ...) COMPAT_SYSCALL_DEFINEx(3, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4(name, ...) COMPAT_SYSCALL_DEFINEx(4, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5(name, ...) COMPAT_SYSCALL_DEFINEx(5, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6(name, ...) COMPAT_SYSCALL_DEFINEx(6, compat_sys_##name, __VA_ARGS__)
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define COMPAT_SYSCALL_DEFINEx(x, sname, ...)			\
 	static const char *types_##sname[] = {			\
