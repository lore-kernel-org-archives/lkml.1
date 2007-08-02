Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXHBTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXHBTCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXHBTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:02:15 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:45111 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbXHBTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:02:14 -0400
Date: Thu, 2 Aug 2007 15:02:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Noah Watkins <nwatkins@ittc.ku.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: [patch 0/1] extending low-level markers
Message-ID: <20070802190211.GA12124@Krystal>
References: <20070801215723.GA10470@ittc.ku.edu> <20070802164437.GA27003@Krystal> <20070802183251.GA15216@ittc.ku.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070802183251.GA15216@ittc.ku.edu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:40:10 up 3 days, 18:59,  4 users,  load average: 1.55, 0.65, 0.52
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Noah Watkins (nwatkins@ittc.ku.edu) wrote:
> On 02/08/07 12:44 -0400, Mathieu Desnoyers wrote:
> > * nwatkins@ittc.ku.edu (nwatkins@ittc.ku.edu) wrote:
> > > Mathieu
> > > 
> > > I have been working with your Kernel Markers infrastructure now for some
> > > time and have run into an extendability issue.
> > 
> > Hi Noah,
> > 
> > Can you tell us a little bit more about what you are doing with the
> > markers ? I guess it could be useful to know so we can get a sense of
> > how it fits in the big picture.
> 
> We have been maintaining an in-house instrumentation framework. The
> instrumenation points we use differ from Kernel Markers in that the desired
> callback is attached at compile time. Other than this difference, they
> are implemented in much the same way. The biggest difference is that we
> have been implicitly encoding the 'type' of instrumenation point by
> assigning a particular callback. For example one type of instrumenation
> point in our framework has the form:
> 
> ds_event(name, int, size_t, void *);
> 
> Thus, a ds_event has a definite set of arguments, and some name, which
> is compatible with a trace_mark.
> 
> We would like to be able to construct a ds_event on top of the low-level
> kernel markers and be able to differentiate between a standard trace_mark in
> in the markers section, and a trace_mark which actually represents a
> ds_event, or another event type.
> 
> Granted we could simply match on compatible argument formats, its only
> that a separation between types would be nice in order to not touch
> markers which are of not interest to us, hence this notion of type.
> Our framework would have blindly attached some callback to all
> points which had matching argument formats, perhaps many that were not
> inserted using ds_event (or some other api built on top of markers).
> 

Hrm, what is wrong with :

trace_mark(ds_myevent, "%d %zu %p", arg1, arg2, arg3);

then ?

You could then attach your probe to all markers staring with a ds_
prefix. (we should keep a list of the used prefixes somewhere) You could
match with format strings to figure out which callback should be
connected to which marker (if you don't plan to have your callback
parsing the format string dynamically).


> The biggest problem we are facing now is with a set of points which
> cooperate together in the sense that one references the others (or some
> other connection topology). For example:
> 
> ds_point_start(NAME, params)
> ds_point_end(NAME, params)
> 
> In this situation ds_point_start collects some data, stashes it in its
> private data area,  and ds_point_end references the corresponding
> ds_point_start when it fires. The two points are wired up by our
> framework (using the marker's private data) and the NAME, in order to
> avoid lookups at logging time.
> 

I wonder how you do your locking there ? I guess you are writing data
that *should* reside on the stack into the private data, which is
somewhat static. A solution to this that would be both not too intrusive
for kernel code and fast enough would be to keep a buffer of such
saved/read data, indexed with a cookie that would be passed from _start
to _end. The only issue is that this cookie would have to be placed on
the kernel stack, its space being reserved even when markers are
disabled.


> So, in this case the names are the same which logically links them, but
> their functionality is different. The difference in functionality could
> again be encoded by the 'type' of point.
> 

if you differentiate them with names like:
ds_point_start and ds_point_end

and pass the cookie as write parameter to _start and read parameter to
_end:

void somefct()
{
  long cookie;

  trace_mark(ds_point_start, "%p %d %zu %p", &cookie, arg1, arg2, arg3);

  ...

  trace_mark(ds_point_end, "%lu %d %zu %p", cookie, arg1, arg2, arg3);
}
It should do the job ?
(note: if mutual exclusion access to a static variable is insured by
proper locking in the kernel, then you don't need to do such trick)

> > The current approach is to use the marker name as a way to specify
> > markers "group". If we go with a "flavor" enumeration instead, we would
> > have to add an enumeration of every markers users in marker.h, which I
> > am a bit reluctant to do.
> 
> This would have to be my biggest complaint with the 'flavor' concept as
> well. However, if all points in main-line always used no concept of
> flavor (or essentially the default flavor) then users wishing to use the
> flavor enumeration out of main-line development could do so?
> 

Hrm, the ideal thing would be to agree on an instrumentation set for a
given subsystem/driver and to get the said instrumentation integrated in
mainline. That would sound like a better way to stop reinventing the
wheel forever. And actually, if there are some features in your tracer
that you would like to add into a mainline tracer, I'll be glad to
discuss those with you. A lot of people out there are facing the same
issues as you are anyway :)

Ideally, a marker should express what the kernel code is doing and what
information we want to extract from it more than being tied to one
particular consumer (probe).

> Hope this helps portray more of what we are trying to do.
> 

It sure helps, thanks :)

Mathieu

> Noah

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
