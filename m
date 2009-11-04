Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbZKDUbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbZKDUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbZKDUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:31:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:18596 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbZKDUbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:31:32 -0500
MIME-Version: 1.0
Message-ID: <284e5d6c-7b31-4284-bd2d-c1d2ded1bc72@default>
Date: Wed, 4 Nov 2009 12:30:11 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
	implementation
In-Reply-To: <4AEFBBA2.4040907@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AF1E46B.015B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
> implementation
> 
> On 11/02/2009 05:46 PM, Dan Magenheimer wrote:
> >>> I don't have any public data available for this DB usage,
> >>>        
> >> Sorry, that doesn't explain anything.
> >>      
> > Well for now just consider the DB usage as another use
> > of profiling.  But one can easily draw scenarios where
> > a monotonic timestamp is also used to guarantee transaction
> > ordering.
> >    
> 
> In this case we should provide a facility for this.  
> Providing a global 
> monotonic counter may be easier than providing a monotonic 
> clock.  Hence 
> my question.

Maybe I'm misunderstanding something, but enterprise
apps can do this entirely on their own without any
kernel help, correct?  Or are you trying to provide
it across guests, e.g. for clusters or something?

> >> For profiling work fast timestamping is of course great, but surely
> >> there is no monotonicity requirement?
> >>      
> > Yes and no.  Monotonicity is a poor substitute for a more
> > generic mechanism that might provide an indication that a
> > discontinuity has occurred (forward or backward); if an app
> > could get both the timestamp AND some kind of "continuity
> > generation counter" (basically a much more sophisticated
> > form of TSC_AUX that changes whenever the timestamp is
> > coming from a different source), perhaps all problems could 
> be solved.   
> 
> I doubt it.  A discontinuity has occured, but what do we know 
> about it? nothing.

Actually, I think for many/most profiling applications,
just knowing a discontinuity occurred between two
timestamps is very useful as that one specific measurement
can be discarded.  If a discontinuity is invisible,
one clearly knows that a negative interval is bad,
but if an interval is very small or very large,
one never knows if it is due to a discontinuity or
due to some other reason.

This would argue for a syscall/vsyscall that can
"return" two values: the "time" and a second
"continuity generation" counter.

> >> I don't think we'll be able to provide monotonicity with 
> vsyscall on
> >> tsc-broken hosts, so we'll be limited to correcting the 
> tsc frequency
> >> after migration for good-tsc hosts.
> >>      
> > True, though clock_gettime(CLOCK_MONOTONIC) can provide
> > the monotonicity where it is required. 
> 
> We have that already.  The question is how to implement it in 
> a vsyscall.

Oh, I see.  I missed that very crucial point.

So, just to verify/clarify... There is NO WAY for
a vsyscall to ensure monotonicity (presumably because
the previous reading can't be safely stored?).  So
speed and "correctness" are mutually exclusive?

If true, yes, that's a potentially significant problem\
though an intelligent app can layer monotonicity
on top of the call I suppose.
