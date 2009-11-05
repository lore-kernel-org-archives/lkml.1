Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZKEOzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZKEOzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbZKEOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:55:14 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59339 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbZKEOzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:55:13 -0500
MIME-Version: 1.0
Message-ID: <fb5e5ebd-6c3c-4031-b710-2deab63a98bb@default>
Date: Thu, 5 Nov 2009 06:52:38 -0800 (PST)
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
In-Reply-To: <4AF274E5.5080205@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AF2E712.015C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> 
> Within a process, yes.  Across processes, not without writable shared 
> memory.
> 
> That's why I'm trying to understand what the actual 
> requirements are.  
> Real monotonic, accurate, high resolution, low cost time sources are 
> hard to come by.

Hmmm... this has significant implications for the rdtsc
emulation discussion on xen-devel.  Since that's not
a Linux question, I'll start another thread on xen-devel
with a shorter cc list.

> > Actually, I think for many/most profiling applications,
> > just knowing a discontinuity occurred between two
> > timestamps is very useful as that one specific measurement
> > can be discarded.  If a discontinuity is invisible,
> > one clearly knows that a negative interval is bad,
> > but if an interval is very small or very large,
> > one never knows if it is due to a discontinuity or
> > due to some other reason.
> >
> > This would argue for a syscall/vsyscall that can
> > "return" two values: the "time" and a second
> > "continuity generation" counter.
> 
> I doubt it.  You should expect discontinuities in user space due to 
> being swapped out, scheduled out, migrated to a different 
> cpu, or your 
> laptop lid being closed.  There are no guarantees to a userspace 
> application.  Even the kernel can expect discontinuities due 
> to SMIs.  
> So an explicit notification about one type of discontinuity 
> adds nothing.

Good point.  I'm interested in enterprise apps that have more
control over the machine (and rarely suffer from laptop lid
closures :-) and would intend for all discontinuities visible
to a hypervisor or kernel to increment "AUX", but bare-metal-
kernel-invisible discontinuities such as SMI do throw a wrench
in the works.

Well, all this discussion has convince me that
my original proposals do make sense for enterprise apps to be
virtualization-aware and use rdtsc/p directly for timestamping
needs rather than OS APIs (with the hypervisor deciding
whether or not to emulate rdtsc/p based on the underlying
physical machine and whether or not migration is enabled
or has occurred).
