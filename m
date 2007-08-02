Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbXHBTjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbXHBTjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbXHBTi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:38:57 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:64562 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbXHBTi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:38:56 -0400
Date: Thu, 2 Aug 2007 15:38:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Noah Watkins <nwatkins@ittc.ku.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: [patch 0/1] extending low-level markers
Message-ID: <20070802193851.GA15883@Krystal>
References: <20070801215723.GA10470@ittc.ku.edu> <20070802164437.GA27003@Krystal> <20070802183251.GA15216@ittc.ku.edu> <20070802190211.GA12124@Krystal> <20070802193106.GC15216@ittc.ku.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070802193106.GC15216@ittc.ku.edu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:35:14 up 3 days, 19:54,  5 users,  load average: 4.87, 4.61, 2.55
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Noah Watkins (nwatkins@ittc.ku.edu) wrote:
> > Hrm, what is wrong with :
> > 
> > trace_mark(ds_myevent, "%d %zu %p", arg1, arg2, arg3);
> > 
> > then ?
> > 
> > You could then attach your probe to all markers staring with a ds_
> > prefix. (we should keep a list of the used prefixes somewhere) You could
> > match with format strings to figure out which callback should be
> > connected to which marker (if you don't plan to have your callback
> > parsing the format string dynamically).
> 
> This has been what I considered the only way to accomplish the 'type'
> feature without adding another field to the struct, and is just fine,
> especially if prefixes are listed some where, or not. I was just
> interested in the possibility of adding types.
> 
> > 
> > 
> > > The biggest problem we are facing now is with a set of points which
> > > cooperate together in the sense that one references the others (or some
> > > other connection topology). For example:
> > > 
> > > ds_point_start(NAME, params)
> > > ds_point_end(NAME, params)
> > > 
> > > In this situation ds_point_start collects some data, stashes it in its
> > > private data area,  and ds_point_end references the corresponding
> > > ds_point_start when it fires. The two points are wired up by our
> > > framework (using the marker's private data) and the NAME, in order to
> > > avoid lookups at logging time.
> > > 
> > 
> > I wonder how you do your locking there ? I guess you are writing data
> > that *should* reside on the stack into the private data, which is
> > somewhat static. A solution to this that would be both not too intrusive
> > for kernel code and fast enough would be to keep a buffer of such
> > saved/read data, indexed with a cookie that would be passed from _start
> > to _end. The only issue is that this cookie would have to be placed on
> > the kernel stack, its space being reserved even when markers are
> > disabled.
> > 
> 
> The locking is internal to our framework and done on a per-type basis.
> The start/end example i mentioned could represent an interval. When the
> two points are wired up they both have their private data pointing at a
> kmalloc'd interval structure internal to our framework, which contains
> a lock.
> 

Then this lock is taken in _start and unlocked in _end ? What happens if
the _start and _end markers are enabled/disabled in a non-equilibrated
way while the kernel code is being executed ? Would it deadlock the next
time the lock is taken due to a missing unlock ?

> > 
> > > So, in this case the names are the same which logically links them, but
> > > their functionality is different. The difference in functionality could
> > > again be encoded by the 'type' of point.
> > > 
> > 
> > if you differentiate them with names like:
> > ds_point_start and ds_point_end
> > 
> > and pass the cookie as write parameter to _start and read parameter to
> > _end:
> > 
> > void somefct()
> > {
> >   long cookie;
> > 
> >   trace_mark(ds_point_start, "%p %d %zu %p", &cookie, arg1, arg2, arg3);
> > 
> >   ...
> > 
> >   trace_mark(ds_point_end, "%lu %d %zu %p", cookie, arg1, arg2, arg3);
> > }
> > It should do the job ?
> > (note: if mutual exclusion access to a static variable is insured by
> > proper locking in the kernel, then you don't need to do such trick)
> 
> The cookie approach would accomplish the functionality, though it does
> complicate the procedure of adding the instrumenation point. If the
> start and the end events are not in the same function/file then
> the linking of the cookie could be too instrusive.
> 
> In all of our cases the cookie would certainly be a void* pointing to
> internal data structures. What is the objection to using the marker's
> private data to point to the internal structures?
> 

SMP, preemption, all those things while requires locking around a static
variable. And the problem of non atomicity of connexion/disconnexion of
multiple probes vs unbalanced lock/unlock.

> Thanks for helping out. I realize the situations I'm describing are
> quite specialized to our particular situation. Many students here use
> the framework for learning systems programming, and as such it evolves
> often.
> 

No problem. I think some interesting things came come out of this.

Mathieu

> - Noah
> 
> > 
> > > > The current approach is to use the marker name as a way to specify
> > > > markers "group". If we go with a "flavor" enumeration instead, we would
> > > > have to add an enumeration of every markers users in marker.h, which I
> > > > am a bit reluctant to do.
> > > 
> > > This would have to be my biggest complaint with the 'flavor' concept as
> > > well. However, if all points in main-line always used no concept of
> > > flavor (or essentially the default flavor) then users wishing to use the
> > > flavor enumeration out of main-line development could do so?
> > > 
> > 
> > Hrm, the ideal thing would be to agree on an instrumentation set for a
> > given subsystem/driver and to get the said instrumentation integrated in
> > mainline. That would sound like a better way to stop reinventing the
> > wheel forever. And actually, if there are some features in your tracer
> > that you would like to add into a mainline tracer, I'll be glad to
> > discuss those with you. A lot of people out there are facing the same
> > issues as you are anyway :)
> > 
> > Ideally, a marker should express what the kernel code is doing and what
> > information we want to extract from it more than being tied to one
> > particular consumer (probe).
> > 
> > > Hope this helps portray more of what we are trying to do.
> > > 
> > 
> > It sure helps, thanks :)
> > 
> > Mathieu
> > 
> > > Noah
> > 
> > -- 
> > Mathieu Desnoyers
> > Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
