Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbYEOUua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbYEOUua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYEOUuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:50:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbYEOUuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:50:17 -0400
Date: Thu, 15 May 2008 13:49:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: geert@linux-m68k.org, torvalds@linux-foundation.org, zippel@linux-m68k.org,
       schwab@suse.de, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
Message-Id: <20080515134928.83b2d948.akpm@linux-foundation.org>
In-Reply-To: <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com>
References: <20080514154402.GF6902@cvg>
	<20080515105803.7c9ab8c7.akpm@linux-foundation.org>
	<20080515180528.GC7481@cvg>
	<Pine.LNX.4.64.0805152132530.22059@anakin>
	<aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 00:22:14 +0400
"Cyrill Gorcunov" <gorcunov@gmail.com> wrote:

> 
> On 5/15/08, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, 15 May 2008, Cyrill Gorcunov wrote:
> >> [Andrew Morton - Thu, May 15, 2008 at 10:58:03AM -0700]
> >> | On Wed, 14 May 2008 19:44:02 +0400 Cyrill Gorcunov <gorcunov@gmail.com>
> >> wrote:
> >> |
> >> | > This patch does fix build bug on m68k wich does not have strncat in
> >> straight way.
> >> | >
> >> | > What is more important - my previous patch
> >> | >
> >> | > commit e662e1cfd434aa234b72fbc781f1d70211cb785b
> >> | > Author: Cyrill Gorcunov <gorcunov@gmail.com>
> >> | > Date:   Mon May 12 14:02:22 2008 -0700
> >> | >
> >> | >     init: don't lose initcall return values
> >> | >
> >> | > has introduced potential buffer overflow by wrong calculation
> >> | > of string accumulator size.
> >> | >
> >> | > Many thanks Andreas Schwab and Geert Uytterhoeven for helping
> >> | > to catch and fix the bug.
> >> | >
> >> | > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> >> | > ---
> >> | >
> >> | > Index: linux-2.6.git/init/main.c
> >> | > ===================================================================
> >> | > --- linux-2.6.git.orig/init/main.c	2008-05-14 17:55:10.000000000 +0400
> >> | > +++ linux-2.6.git/init/main.c	2008-05-14 19:11:18.000000000 +0400
> >> | > @@ -702,7 +702,7 @@ static void __init do_initcalls(void)
> >> | >
> >> | >  	for (call = __initcall_start; call < __initcall_end; call++) {
> >> | >  		ktime_t t0, t1, delta;
> >> | > -		char msgbuf[40];
> >> | > +		char msgbuf[64];
> >> | >  		int result;
> >> | >
> >> | >  		if (initcall_debug) {
> >> | > @@ -729,11 +729,11 @@ static void __init do_initcalls(void)
> >> | >  			sprintf(msgbuf, "error code %d ", result);
> >> | >
> >> | >  		if (preempt_count() != count) {
> >> | > -			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
> >> | > +			strcat(msgbuf, "preemption imbalance ");
> >> | >  			preempt_count() = count;
> >> | >  		}
> >> | >  		if (irqs_disabled()) {
> >> | > -			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
> >> | > +			strcat(msgbuf, "disabled interrupts ");
> >> | >  			local_irq_enable();
> >> | >  		}
> >> | >  		if (msgbuf[0]) {
> >> |
> >> | umm, why can't m68k call strncat() from init/main.c??
> >> |
> >>
> >> there some problem with headers iirc, we have to declare it first or
> >> use some gcc option (as Adrian suggested). Actually I would prefer to use
> >
> > gcc turns the strncat() into an implicit call to strlen() and some form
> > of expanded memcpy(). E.g.
> >
> >
> > 	if (preempt_count() != count) {
> > 		strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
> > 		preempt_count() = count;
> > 	}
> >
> > becomes
> >
> >         cmp.l 884(%a2),%d6      | <variable>.thread.info.preempt_count,
> > count
> >         jeq .L61        |
> >         move.l %d7,-(%sp)       | tmp76,
> >         jbsr strlen     |
> >         addq.l #4,%sp   |,
> >         move.l %d7,%a0  | tmp76, tmp80
> >         add.l %d0,%a0   |, tmp80
> >         move.l #1886545253,(%a0)+       |,
> >         move.l #1836086377,(%a0)+       |,
> >         move.l #1869488233,(%a0)+       |,
> >         move.l #1835164012,(%a0)+       |,
> >         move.l #1634624357,(%a0)+       |,
> >         move.w #8192,(%a0)      |,* D.28541
> >         move.l %d6,884(%a2)     | count,
> > <variable>.thread.info.preempt_count
> > .L61:
> >
> > All other explicit calls to strlen() are inlined, as per
> > include/asm-m68k/string.h.
> >
> >> strlcat there but it seems it would fail to build too. Originally I've
> >> messed
> >> strlcat with strncat :(
> >
> > Actually it build and runs fine after s/strncat/strlcat/...
> >

(top-posting repaired)

> Could you please make an update to the patch? I can make it only
> tomorrow evening (ie not that fast)

Like this?


From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch fixes a build bug on m68k - gcc decides to emit a call to the
strlen library function, which we don't implement.  Use strlcat() instead.


What is more important - my previous patch

commit e662e1cfd434aa234b72fbc781f1d70211cb785b
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Mon May 12 14:02:22 2008 -0700

    init: don't lose initcall return values

Has introduced potential buffer overflow by wrong calculation of string
accumulator size.

Many thanks Andreas Schwab and Geert Uytterhoeven for helping
to catch and fix the bug.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/main.c~init-fix-building-bug-and-potential-buffer-overflow init/main.c
--- a/init/main.c~init-fix-building-bug-and-potential-buffer-overflow
+++ a/init/main.c
@@ -702,7 +702,7 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char msgbuf[40];
+		char msgbuf[64];
 		int result;
 
 		if (initcall_debug) {
@@ -729,11 +729,11 @@ static void __init do_initcalls(void)
 			sprintf(msgbuf, "error code %d ", result);
 
 		if (preempt_count() != count) {
-			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
+			strlcat(msgbuf, "preemption imbalance ", sizeof msgbuf);
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
+			strlcat(msgbuf, "disabled interrupts ", sizeof msgbuf);
 			local_irq_enable();
 		}
 		if (msgbuf[0]) {
_

(yeah, I normally parenthesise sizeof too, but this provided 80-col
salvation)

