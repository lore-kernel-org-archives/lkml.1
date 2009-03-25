Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbZCYOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbZCYOrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbZCYOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:47:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34426 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbZCYOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:47:10 -0400
Date: Wed, 25 Mar 2009 10:47:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Hua Zhong <hzhong@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
In-Reply-To: <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org>  <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>  <009101c9ad20$1ae231c0$50a69540$@com>  <1237968394.30175.12.camel@penberg-laptop>
 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Pekka Enberg wrote:

> On Wed, 2009-03-25 at 01:02 -0700, Hua Zhong wrote:
> >> > But those are _error handling paths_ (at least supposed to be). I
> >> > wonder which call-sites are responsible for this. Can frtrace help us
> >> > here?
> >>
> >> I am not sure why you call these error paths.
> >>
> >> I submitted the same patch two years ago, and you are still holding the same
> >> argument.
> >>
> >> http://www.archivum.info/linux.kernel/2006-04/msg06042.html
> >>
> >> Have you used likely profiler? These are real numbers. If you insist on
> >> calling them error paths then error paths are obviously the norm.
> 
> On Wed, Mar 25, 2009 at 10:06 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > I am not denying the results, I am just saying that they don't make much
> > sense to me. Like I said, I would love to see the actual call-sites to
> > prove my argument wrong.
> 
> OK, so according to Steven, audit_syscall_exit() is one such call-site
> that shows up in the traces. I don't really understand what's going on
> there but if it is sane, maybe that warrants the removal of unlikely()
> from kfree(). Hmm?


After disabling AUDIT_SYSCALLS I have this:

 # cat /debug/tracing/trace | sort -u

record_nulls: ptr=(null) (ext3_get_acl+0x1e0/0x3f0 [ext3])
record_nulls: ptr=(null) (free_bitmap+0x29/0x70)
record_nulls: ptr=(null) (free_tty_struct+0x1d/0x40)
record_nulls: ptr=(null) (ftrace_graph_exit_task+0x1e/0x20)
record_nulls: ptr=(null) (inet_sock_destruct+0x1cb/0x2a0)
record_nulls: ptr=(null) (ip_cork_release+0x24/0x50)
record_nulls: ptr=(null) (keyctl_join_session_keyring+0x5a/0x70)
record_nulls: ptr=(null) (key_user_lookup+0x183/0x220)
record_nulls: ptr=(null) (kobject_set_name_vargs+0x43/0x50)
record_nulls: ptr=(null) (netlink_release+0x1a4/0x2f0)
record_nulls: ptr=(null) (release_sysfs_dirent+0x20/0xc0)
record_nulls: ptr=(null) (sysfs_open_file+0x1c8/0x3e0)
record_nulls: ptr=(null) (tty_write+0x16a/0x290)

I added a hook to only record when NULL is passed into kfree.

Also note, that after disabling AUDIT_SYSCALLS I now only have roughly 7% 
NULL hit rate. Still, unlikely is probably not a benefit here.

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  108129     8214   7 kfree                          slub.c               2796
 

And yes, this is a different kernel than the patch. This is running on tip 
and not 2.6.29, and also, you can see, uses slub.c not slab.c. The reason 
I changed was because:

 1) it has better tracing utilities
 2) included your trace point patch ;-)

The header is still messed up, because I'm using the kmemtrace branch and 
not the ftrace branch, but I had better go back and make sure they are 
fixed.

-- Steve

