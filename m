Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZJ2QRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZJ2QRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZJ2QRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:17:07 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33712 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZJ2QRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:17:06 -0400
MIME-Version: 1.0
Message-ID: <f14ec444-c388-4275-8f9d-e873d1e6ea40@default>
Date: Thu, 29 Oct 2009 09:15:26 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: dan.magenheimer@oracle.com, Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, Glauber Costa <glommer@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       Ingo Molnar <mingo@redhat.com>, chris.mason@oracle.com
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
In-Reply-To: <ffdfacb2-bc41-40b3-8a35-550fd441d77b@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AE9BFD6.0062:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a related note, though some topic drift, many of
the problems that occur in virtualization due to migration
could be better addressed if Linux had an architected
interface to allow it to be signaled if a migration
occurred, and if Linux could signal applications of
the same.  I don't have any cycles (pun intended) to
think about this right now, but if anyone else starts
looking at it, I'd love to be cc'ed.

Thanks,
Dan

> -----Original Message-----
> From: Dan Magenheimer 
> Sent: Thursday, October 29, 2009 9:56 AM
> To: Avi Kivity
> Cc: Jeremy Fitzhardinge; Jeremy Fitzhardinge; Kurt Hackel; Glauber
> Costa; the arch/x86 maintainers; Linux Kernel Mailing List; Glauber de
> Oliveira Costa; Xen-devel; Keir Fraser; Zach Brown; Ingo Molnar; Chris
> Mason
> Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
> implementation
> 
> 
> > From: Avi Kivity [mailto:avi@redhat.com]
> > Sent: Thursday, October 29, 2009 9:07 AM
> > To: Dan Magenheimer
> > Cc: Jeremy Fitzhardinge; Glauber Costa; Jeremy Fitzhardinge; Kurt
> > Hackel; the arch/x86 maintainers; Linux Kernel Mailing List; 
> > Glauber de
> > Oliveira Costa; Xen-devel; Keir Fraser; Zach Brown; Chris 
> Mason; Ingo
> > Molnar
> > Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
> > implementation
> > 
> > 
> > On 10/29/2009 04:46 PM, Dan Magenheimer wrote:
> > > No, the apps I'm familiar with (a DB and a JVM) need a timestamp
> > > not a monotonic counter.  The timestamps must be relatively
> > > accurate (e.g. we've been talking about gettimeofday generically,
> > > but these apps would use clock_gettime for nsec resolution),
> > > monotonically increasing, and work properly across a VM
> > > migration.  The timestamps are taken up to a 100K/sec or
> > > more so the apps need to ensure they are using the fastest
> > > mechanism available that meets those requirements.
> > 
> > Out of interest, do you know (and can you relate) why those 
> apps need 
> > 100k/sec monotonically increasing timestamps?
> 
> I don't have any public data available for this DB usage, but 
> basically
> assume it is measuring transactions at a very high throughput, some
> of which are to a memory-resident portion of the DB.  Anecdotally, 
> I'm told the difference between non-vsyscall gettimeofday
> and native rdtsc (on a machine with Invariant TSC support) can
> affect overall DB performance by as much as 10-20%.
> 
> I did find the following public link for the JVM: 
> 
> http://download.oracle.com/docs/cd/E13188_01/jrockit/tools/int
ro/jmc3.html

Search for "flight recorder".  This feature is intended to
be enabled all the time, but with non-vsyscall gettimeofday
the performance impact is unacceptably high, so they are using
rdtscp instead (on those machines where it is available).  With
rdtscp, the performance impact is not measureable.

Though the processor/server vendors have finally fixed the
"unsynced TSC" problem on recent x86 platforms, thus allowing
enterprise software to obtain timestamps at rdtsc performance,
the problem comes back all over again with virtualization
because of migration.  Jeremy's vsyscall+pvclock is a great 
solution if the app can ensure that it is present; if not,
the apps will instead continue to use rdtsc as even emulated
rdtsc is 2-3x faster than non-vsyscall gettimeofday.

Does that help?

_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xensource.com
http://lists.xensource.com/xen-devel
