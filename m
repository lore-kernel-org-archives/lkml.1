Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYG3C2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYG3C2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYG3C1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:27:54 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:56457 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbYG3C1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:27:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiUFABduj0hMRKxB/2dsb2JhbACBW4lEpUY
Date: Tue, 29 Jul 2008 22:27:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] Module : call synchronize_sched() between module exit()
	and free.
Message-ID: <20080730022751.GA15866@Krystal>
References: <20080717155724.897537670@polymtl.ca> <20080729211543.GB17097@redhat.com> <20080729224115.GA5209@Krystal> <200807301140.59745.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200807301140.59745.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:56:41 up 55 days,  6:37,  4 users,  load average: 1.29, 1.03,
	1.02
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Mathieu,
> 
>    Yes: stop_machine is merely used to atomically check the module refcount 
> for zero and set the state so it can't be incremented again (ie. 
> try_module_get will fail).
> 
>    So placing a tracepoint or marker in a module does not bump the module 
> refcount?  If that's true, then there needs to be some kind of 
> remove_markers_from_module() call after module->exit(), which should do the 
> synchronize_sched() or whatever, right?
> 
> Rusty.

Actually, it's not placing a marker/tracepoint in a module which causes
a problem, this is a simple function call after all, and correctly dealt
with by current module.c code.

The problem comes from a probe function (the callback) that would be
registered to be called from a marker and would sit in an unloadable 
kernel module. I would not want to tie the refcount of the probe modules
to the fact that they are connected to a marker because it would then
become impossible to unload them due to the fact that unregistration is
done in module exit().

This is one of the reasons why I disable preemption around the marker
site (the function call) : to make sure I can can unregister the
callback, wait for a quiescent state (with synchronize_sched()) and then
free the module memory.

This would give the following supplementary guarantee about module
teardown : every function called with preemption off and unregistered in
the module exit() would reach a quiescent state before the module is
freed. Given this does apply to rarely used code (module unload), I
think it might be ok to simply add a call to synchronize_sched() before
the module memory is freed. Not tying this to markers/tracepoints would
keep the behavior consistant across various build options, which is IMHO
a good thing.

I could also just document that a mandatory "synchronize_sched()" should
be called at the end of the probe module exit() function which makes
sure the probes has reached a quiescent state.

I don't want to add a synchronize_sched() into the marker/tracepoint
probe unregistration code because I want to keep batch probe
unregistration fast enough so it does no take ~5 seconds to unload ~100
probes. (may take longer on a loaded SMP system)

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
