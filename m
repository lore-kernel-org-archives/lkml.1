Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbXJKN11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbXJKN11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXJKN1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:27:16 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:47774 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbXJKN1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:27:14 -0400
Date: Thu, 11 Oct 2007 09:27:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] Linux Kernel Markers - Samples
Message-ID: <20071011132712.GA3580@Krystal>
References: <20070928142845.795281397@polymtl.ca> <20070928143159.948108939@polymtl.ca> <20071011021355.53302c04.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071011021355.53302c04.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:07:08 up 73 days, 13:26,  2 users,  load average: 1.45, 1.56, 1.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 28 Sep 2007 10:28:49 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Module example showing how to use the Linux Kernel Markers.
> 
> s390:
> 
> samples/markers/marker-example.c: In function 'my_open':
> samples/markers/marker-example.c:22: warning: asm operand 0 probably doesn't match constraints
> samples/markers/marker-example.c:24: warning: asm operand 0 probably doesn't match constraints
> samples/markers/marker-example.c:22: error: impossible constraint in 'asm'
> samples/markers/marker-example.c:24: error: impossible constraint in 'asm'

Hrm, I have s390 gcc-4.1.1 here and cannot reproduce the problem with it.

What compiler are you using ?

This is clearly caused by the :
  asm volatile ("" : : "i" (&__mark_##name));

It is there to specify that the __mark_##name variable is used. In the
first implementations, I did not pass it as a parameter to the following
function call, so I had to find a way to tell gcc that it should not go
away. I first planned to use a "__used" attribute, but Jeremy said it
was buggy on some gcc versions. (http://lkml.org/lkml/2006/10/17/235)

He suggested the following:
  asm volatile("" : : "m" (thing));

But I guess it ended up not working so well, since I changed it for a
"i" operand. However, if some s390 gccs do not like it, it's better to
figure out another solution.

Well, as a very very simple solution, let's just remove the asm. It is
not needed anymore since the pointer is passed as parameter to the
called function.

The patch follows.

Mathieu


Linux Kernel Markers - Remove Unneeded asm

On s390 (with some compiler) :

> samples/markers/marker-example.c: In function 'my_open':
> samples/markers/marker-example.c:22: warning: asm operand 0 probably doesn't
> match constraints
> samples/markers/marker-example.c:24: warning: asm operand 0 probably doesn't
> match constraints
> samples/markers/marker-example.c:22: error: impossible constraint in 'asm'
> samples/markers/marker-example.c:24: error: impossible constraint in 'asm'

It is there to specify that the __mark_##name variable is used. In the
first implementations, I did not pass it as a parameter to the following
function call, so I had to find a way to tell gcc that it should not go
away. I first planned to use a "__used" attribute, but Jeremy said it
was buggy on some gcc versions. (http://lkml.org/lkml/2006/10/17/235)

He suggested the following:
  asm volatile("" : : "m" (thing));

But I guess it ended up not working so well, since I changed it for a
"i" operand. However, if some s390 gccs do not like it, it's better to
figure out another solution.

Well, as a very very simple solution, let's just remove the asm. It is
not needed anymore since the pointer is passed as parameter to the
called function.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-10-11 09:20:04.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-10-11 09:20:23.000000000 -0400
@@ -61,7 +61,6 @@ struct marker {
 		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
-		asm volatile ("" : : "i" (&__mark_##name));		\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			preempt_disable();				\
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
