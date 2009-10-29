Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZJ2OrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZJ2OrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZJ2OrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:47:10 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:37086 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZJ2OrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:47:09 -0400
MIME-Version: 1.0
Message-ID: <6137c066-3dfd-49dd-bbf2-7718f8542958@default>
Date: Thu, 29 Oct 2009 07:46:05 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
	implementation
In-Reply-To: <4AE986FE.3040104@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AE9AAB8.0101:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> 
> On 10/28/2009 07:47 PM, Jeremy Fitzhardinge wrote:
> >> Much better to have an API for this.  Life is hacky enough already.
> >>      
> > My point is that if an app cares about property X then it 
> should just
> > measure property X.  The fact that gettimeofday is a 
> vsyscall is just an
> > implementation detail that apps don't really care about.  
> What they care
> > about is whether gettimeofday is fast or not.
> >    
> 
> But we can not make a reliable measurement.
> 
> > If the environment has such unstable timing that the effect can't be
> > measured, then it is moot whether its a vsyscall or not (but in that
> > case its almost certainly better to use the standard API rather than
> > trying to roll your own timesource with rdtsc).
> >    
> 
> If you're interested in gettimeofday() for a global monotonic counter 
> you can fall back to atomic_fetch_and_add() which will be 
> faster than a 
> syscall even on large systems.  Maybe we should provide a 
> vsyscall for 
> global monotonic counters and implement it using a atomics or tsc 
> instead of these hacks (I'm assuming here that the 
> gettimeofday() calls 
> are used to implement an atomic counter - are they?)

No, the apps I'm familiar with (a DB and a JVM) need a timestamp
not a monotonic counter.  The timestamps must be relatively
accurate (e.g. we've been talking about gettimeofday generically,
but these apps would use clock_gettime for nsec resolution),
monotonically increasing, and work properly across a VM
migration.  The timestamps are taken up to a 100K/sec or
more so the apps need to ensure they are using the fastest
mechanism available that meets those requirements.

