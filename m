Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbXKDXYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbXKDXYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXKDXYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:24:46 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:44118 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbXKDXYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:24:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HABLkLUdMROHU/2dsb2JhbACBWw
Date: Sun, 4 Nov 2007 18:24:42 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Mike Mason <mmlnx@us.ibm.com>
Cc: ltt-dev@shafik.org, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: [to-be-posted-soon] Multiple handlers per marker
Message-ID: <20071104232442.GA32320@Krystal>
References: <472A345C.2010208@us.ibm.com> <20071101221530.GC19700@Krystal> <20071102033654.GA1301@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071102033654.GA1301@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:17:28 up 1 day,  4:22,  5 users,  load average: 0.65, 0.23,
	0.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Mike Mason (mmlnx@us.ibm.com) wrote:
> > > Hi Mathieu,
> > > 
> > > Are you aware of any working being done to allow multiple handlers to be 
> > > attached to a marker?  Something like what kprobes allows.  I've started to 
> > > look into this and don't want to duplicate efforts.
> > > 
> > 
> > Nope, but I know we will have to address this.
> > 
> > Something along the lines of walking an RCU list of function pointers,
> > calling them.
> > 
> > The only downside I see is that we will have to pass a va_list * instead
> > of real va args. The could make the marker site a little bit bigger and
> > will change the probe callback arguments.
> > 
> > What do you think about these ideas ?
> > 
> > If we can find a way to make the common case (only one probe connected)
> > _ultra_ fast, and yet architecture independent, that would be awesome. A
> > simple call is kind of hard to beat though.. So we may have to think
> > about a design with :
> > 
> > - One call at the marker site
> > - if 1 probe is installed :
> >   - If the format string is empty, connect a probe without va args.
> >   - If the format string is not empty, connect a "stage 1" probe that takes
> >     the va args, starts/ends the va_list and calls _one_ function (let's
> >     call it "stage 2" probe), that takes va_list as parameter.
> > - if more than 1 probe is installed :
> >   - The stage 1 probe creates the va_list and passes it to each function
> >     connected, iterated with an RCU list.
> > 
> > What do you think ?
> > 
> > Mathieu
> >
> 
> I'm working on an implementation.
> 

It's ready for testing. Please grab
http://ltt.polymtl.ca/lttng/patch-2.6.24-rc1-git13-lttng-0.10-pre18.tar.bz2
patch name :

markers-support-multiple-probes.patch

It still need to go through patchcheck.pl and some polishing, but it
seems to work fine for me with multiple probes (the sample marker,
sample probe and multiple instances of my lttng probes can
connect/disconnect without problem).

Currently, the "connect/disconnect" and "arm/disarm" operations are
separate. However, they could be merged. Any comment/preference on this?
Being separate, a probe provider can wait until the very last moment
before it activates its markers, with a minimalistic impact on the
system, but it is not such a strong argument.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
