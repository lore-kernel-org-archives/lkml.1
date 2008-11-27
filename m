Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYK0Req@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYK0Req (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYK0Reg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:34:36 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55069 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYK0Ref (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:34:35 -0500
Date: Thu, 27 Nov 2008 17:34:27 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
In-Reply-To: <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811271643250.9618@blonde.site>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com> 
 <200811270026.37941.rjw@sisk.pl>  <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
  <Pine.LNX.4.64.0811271349040.21910@blonde.site>
 <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Pekka Enberg wrote:
> On Thu, Nov 27, 2008 at 3:54 PM, Hugh Dickins <hugh@veritas.com> wrote:
> > I think you're looking at a 2.6.28-rc5 sprint_symbol() there:
> > the world has moved on since those days.  I changed it to use the
> > supplied "buffer" instead of local "namebuf" in 2.6.28-rc6, so we
> > have to wonder if my patch is to blame - though I don't see it.
> 
> Oh, right. I think I see where this is going. The buffer is coming
> from sysfs and is PAGE_SIZE long. In SLUB, we do check for overflows
> but list_locations() allows us to get as close as 100 bytes bytes from
> the edge of the page. Unfortunately, kallsyms_lookup() does:
> 
>   const char *kallsyms_lookup(unsigned long addr,
>                               unsigned long *symbolsize,
>                               unsigned long *offset,
>                               char **modname, char *namebuf)
>   {
>           namebuf[KSYM_NAME_LEN - 1] = 0;
>           namebuf[0] = 0;
> 
> where KSYM_NAME_LEN is 128 which will tip us over the page edge
> potentially triggering an oops.

Thanks for working that out.
Good find (yes, it was a find!) by Miles.

> The proper fix is probably to pass a
> length of namebuf to kallsyms_lookup() but it's probably best to
> revert the patch this late in the release cycle?

Several possibilities, I don't know which is the right one for now,
hope Andrew can judge.

I don't see passing the length of namebuf to kallsyms_lookup()
as called for: it could have been designed that way from the start,
but it wasn't, and I don't see this bug as any reason to change that.

Reverting my patch for now: that's certainly a reasonable possibility,
but leaves us with several other such bugs.  Suggested patch below,
but the ftrace part of it worries me a little, since it's within a
structure and maybe it's a bad idea to enlarge that at this point;
I've also not _really_ done the arithmetic needed for the slub one.

An alternative quick just-for-now fix might be to remove that
	namebuf[KSYM_NAME_LEN - 1] = 0;
from kallsyms_lookup(): as I understand it (please check), that
could only make sense in cases where the symbol is KSYM_NAME_LEN
long or longer - in which case, all of the places fixed in the
patch below would be causing corruption already, even without my
patch.  I think.  Maybe that "= 0" even serves no purpose at all?

Hugh

[PATCH] KSYM_SYMBOL_LEN fixes

Miles Lane tailing /sys files hit a BUG which Pekka Enberg has tracked to
my 966c8c12dc9e77f931e2281ba25d2f0244b06949 sprint_symbol(): use less stack
exposing a bug in slub's list_locations() - kallsyms_lookup() writes a 0
to namebuf[KSYM_NAME_LEN-1], but that was beyond the end of page provided.

The 100 slop which list_locations() allows at end of page looks roughly
enough for all the other stuff it might print after the symbol before
it checks again: break out KSYM_SYMBOL_LEN earlier than before.

Latencytop and ftrace and are using KSYM_NAME_LEN buffers where they need
KSYM_SYMBOL_LEN buffers, and vmallocinfo a 2*KSYM_NAME_LEN buffer where
it wants a KSYM_SYMBOL_LEN buffer: fix those before anyone copies them.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/proc/base.c         |    2 +-
 include/linux/ftrace.h |    2 +-
 kernel/latencytop.c    |    2 +-
 mm/slub.c              |    2 +-
 mm/vmalloc.c           |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- 2.6.28-rc6/fs/proc/base.c	2008-10-24 09:28:19.000000000 +0100
+++ linux/fs/proc/base.c	2008-11-27 16:39:26.000000000 +0000
@@ -371,7 +371,7 @@ static int lstats_show_proc(struct seq_f
 				task->latency_record[i].time,
 				task->latency_record[i].max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_NAME_LEN];
+				char sym[KSYM_SYMBOL_LEN];
 				char *c;
 				if (!task->latency_record[i].backtrace[q])
 					break;
--- 2.6.28-rc6/include/linux/ftrace.h	2008-11-02 23:17:56.000000000 +0000
+++ linux/include/linux/ftrace.h	2008-11-27 16:39:26.000000000 +0000
@@ -231,7 +231,7 @@ ftrace_init_module(unsigned long *start,
 
 struct boot_trace {
 	pid_t			caller;
-	char			func[KSYM_NAME_LEN];
+	char			func[KSYM_SYMBOL_LEN];
 	int			result;
 	unsigned long long	duration;		/* usecs */
 	ktime_t			calltime;
--- 2.6.28-rc6/kernel/latencytop.c	2008-07-13 22:51:29.000000000 +0100
+++ linux/kernel/latencytop.c	2008-11-27 16:39:26.000000000 +0000
@@ -191,7 +191,7 @@ static int lstats_show(struct seq_file *
 				latency_record[i].time,
 				latency_record[i].max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_NAME_LEN];
+				char sym[KSYM_SYMBOL_LEN];
 				char *c;
 				if (!latency_record[i].backtrace[q])
 					break;
--- 2.6.28-rc6/mm/slub.c	2008-10-24 09:28:26.000000000 +0100
+++ linux/mm/slub.c	2008-11-27 16:39:27.000000000 +0000
@@ -3595,7 +3595,7 @@ static int list_locations(struct kmem_ca
 	for (i = 0; i < t.count; i++) {
 		struct location *l = &t.loc[i];
 
-		if (len > PAGE_SIZE - 100)
+		if (len > PAGE_SIZE - KSYM_SYMBOL_LEN - 100)
 			break;
 		len += sprintf(buf + len, "%7ld ", l->count);
 
--- 2.6.28-rc6/mm/vmalloc.c	2008-11-21 11:09:24.000000000 +0000
+++ linux/mm/vmalloc.c	2008-11-27 16:39:27.000000000 +0000
@@ -1705,7 +1705,7 @@ static int s_show(struct seq_file *m, vo
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller) {
-		char buff[2 * KSYM_NAME_LEN];
+		char buff[KSYM_SYMBOL_LEN];
 
 		seq_putc(m, ' ');
 		sprint_symbol(buff, (unsigned long)v->caller);
