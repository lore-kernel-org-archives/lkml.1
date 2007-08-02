Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbXHBQos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbXHBQos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbXHBQok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:44:40 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:46422 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152AbXHBQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:44:39 -0400
Date: Thu, 2 Aug 2007 12:44:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: nwatkins@ittc.ku.edu, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: [patch 0/1] extending low-level markers
Message-ID: <20070802164437.GA27003@Krystal>
References: <20070801215723.GA10470@ittc.ku.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070801215723.GA10470@ittc.ku.edu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:27:06 up 3 days, 16:45,  3 users,  load average: 4.58, 2.05, 1.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* nwatkins@ittc.ku.edu (nwatkins@ittc.ku.edu) wrote:
> Mathieu
> 
> I have been working with your Kernel Markers infrastructure now for some
> time and have run into an extendability issue.

Hi Noah,

Can you tell us a little bit more about what you are doing with the
markers ? I guess it could be useful to know so we can get a sense of
how it fits in the big picture.

> 
> Essentially I am failing to find a way to extend the current
> __trace_mark macro with site-specific context. That is, I would like the
> ability to create different 'types' of instrumentation points by bulding
> upon the __trace_mark macro. A consumer of this marker could examine
> the type of marker, and attach an appropriate callback function /
> private data.
> 

You bring a good point. Actually, we have to consider a few things:

Currently, in order to keep things simple, only one callback can be
connected to a marker at any given time. I did it this way to keep is as
simple as possible. And it is always possible to create a multiplexer
callback if ever needed that would walk on a notifier list later to
support plugging multiple probes on a given marker. But I would not like
to see the critical path of a tracer be _required_ to use a notifier
chain when the typical case is to have a single callback connected.

The current approach is to use the marker name as a way to specify
markers "group". If we go with a "flavor" enumeration instead, we would
have to add an enumeration of every markers users in marker.h, which I
am a bit reluctant to do.

Also, what makes your markers unsuitable for other probes ?

There are cases where a "generic" callback will do 95% of the job, but
there are always subtile cases where more intelligent probes are needed.
It's the case of blktrace, which must test if some arguments are NULL in
order to know if they can be dereferenced and thus if the event must be
considered. We can deal with this in two ways:
- in the kernel code, inside an immediate_if(), surrounding the marker.
  Advantage: the test is done inline, so the event can be discarded
  inline. Disadvantage: it adds a few bytes to the kernel image when
  tracing modules and probes are not loaded.
- in the probe module connected to the marker.
  +: The code is not there if the probe module is not loaded
  -: we have to do a function call before we can test some conditions
     when the probe is connected.

In my following markers version, the format strings are checked by GCC
and it emits warnings if va args doesn't match. I hope your format
strings are consistent with the arguments..

Once we know more about what you are trying to do with the markers,
we'll be in better position to bring the discussion forward.

Regards,

Mathieu


> I have included a patch which adds a flavor field to the __trace_mark
> macro. This simplified example demonstrates the functionality I'm
> looking for:
> 
> #define __trace_mark(flavor, name, format, args...)
> 		<current macro plus the flavor field>
> 
> #define marker_flavor_XXX(name, format, args...)
> 		__trace_mark(XXX, name, format, args)
> 
> Here a marker of type XXX is build upon the __trace_mark macro. When a
> consumer of type XXX finds markers with the XXX flavor appropriate
> registration can take place.
> 
> Unless I don't fully understand all the use cases of the markers, I
> don't see any other way to do this except to encode the 'type'
> information in the name of the marker, and require the consumer to parse
> the string to determine the type. Restricting the names of the markers
> in this way seems like a bad solution.
> 
> Any help and feedback is greatly appreciated.
> 
> - Noah
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
