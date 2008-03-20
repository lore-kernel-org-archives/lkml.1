Return-Path: <linux-kernel-owner+w=401wt.eu-S967876AbYCTAoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967876AbYCTAoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965250AbYCTAmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:42:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58477 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967718AbYCTAmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:42:39 -0400
Message-Id: <20080320002835.384758480@polymtl.ca>
References: <20080320002737.918213455@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 19 Mar 2008 20:27:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jon Masters <jcm@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 4/4] Markers Support for Proprierary Modules
Content-Disposition: inline; filename=markers-support-for-proprietary-modules.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 20 Mar 2008 00:28:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be good arguments for markers to support proprierary modules. So
I am throwing this one-liner in and let's see how people react. It only makes
sure that a module that has been "forced" to be loaded won't have its markers
used. It is important to leave this check to make sure the kernel does not crash
by expecting the markers part of the struct module by mistake in the case there
is an incorrect checksum.


Discussion so far :
http://lkml.org/lkml/2008/1/22/226

Jon Masters <jcm@redhat.com> writes:
I notice in module.c:

#ifdef CONFIG_MARKERS
      if (!mod->taints)
              marker_update_probe_range(mod->markers,
                      mod->markers + mod->num_markers, NULL, NULL);
#endif

Is this an attempt to not set a marker for proprietary modules? [...]

* Frank Ch. Eigler (fche@redhat.com) wrote:
I can't seem to find any discussion about this aspect.  If this is the
intent, it seems misguided to me.  There may instead be a relationship
to TAINT_FORCED_{RMMOD,MODULE}.  Mathieu?

- FChE

On Tue, 2008-01-22 at 22:10 -0500, Mathieu Desnoyers wrote:
On my part, its mostly a matter of not crashing the kernel when someone
tries to force modprobe of a proprietary module (where the checksums
doesn't match) on a kernel that supports the markers. Not doing so
causes the markers to try to find the marker-specific information in
struct module which doesn't exist and OOPSes.

Christoph's point of view is rather more drastic than mine : it's not
interesting for the kernel community to help proprietary modules writers,
so it's a good idea not to give them marker support. (I CC'ed him so he
can clarify his position).

* Frank Ch. Eigler (fche@redhat.com) wrote:
[...]
Another way of looking at this though is that by allowing/encouraging
proprietary module writers to include markers, we and their users get
new diagnostic capabilities.  It constitutes a little bit of opening
up, which IMO we should reward rather than punish.


* Vladis Ketnieks (Valdis.Kletnieks@vt.edu) wrote:
On Wed, 23 Jan 2008 09:48:12 EST, Mathieu Desnoyers said:

> This specific one is a kernel policy matter, and I personally don't
> have a strong opinion about it. I agree that you raise a good counter
> argument : it can be useful to proprietary modules users to be able to
> extract tracing information from those modules to argue with their
> vendors that their driver/hardware is broken (a tracer is _very_ useful
> in that kind of situation).

Amen, brother. Been there, done that, got the tshirt (not on Linux, but
other operating systems).

>                             However, it is also useful to proprieraty
> module writers who can benefit from the merged kernel/modules traces.
> Do we want to give them this ability ?

The proprietary module writer has the *source* for the kernel and their module.
There's no way you can prevent the proprietary module writers from using this
feature as long as you allow other module writers to use it.

>                                           It would surely help writing
> better proprieraty kernel modules.

The biggest complaint against proprietary modules is that they make it
impossible for *us* to debug.  And you want to argue *against* a feature that
would allow them to develop better code that causes less crashes, and therefor
less people *asking* for us to debug it?

Remember - when a user tries a Linux box with a proprietary module, and the
experience sucks because the module sucks, they will walk away thinking
"Linux sucks", not "That module sucks".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Jon Masters <jcm@jonmasters.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Jon Masters <jcm@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2008-03-14 08:52:12.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2008-03-14 08:54:10.000000000 -0400
@@ -2040,7 +2040,7 @@ static struct module *load_module(void _
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
 #ifdef CONFIG_MARKERS
-	if (!mod->taints)
+	if (!(mod->taints & TAINT_FORCED_MODULE))
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
