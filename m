Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbZJFOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbZJFOXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbZJFOXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:23:45 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:44406 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbZJFOXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:23:43 -0400
MIME-Version: 1.0
Message-ID: <711a958d-5a76-4f00-aa69-8e5889945992@default>
Date: Tue, 6 Oct 2009 07:19:51 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>, zach.brown@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>, chris.mason@oracle.com
Subject: RE: [PATCH 3/5] x86/pvclock: add vsyscall implementation
In-Reply-To: <4ACB0833.2050203@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ACB5276.0165:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jeremy Fitzhardinge [mailto:jeremy.fitzhardinge@citrix.com]
> With this in place, I can do a gettimeofday in about 100ns on a 2.4GHz
> Q6600.  I'm sure this could be tuned a bit more, but it is 
> already much better than a syscall.

To evaluate the goodness of this, we really need a full
set of measurements for:

a) cost of rdtsc (and rdtscp if different)
b) cost of vsyscall+pvclock
c) cost of rdtsc emulated
d) cost of a hypercall that returns "hypervisor system time"

On a E6850 (3Ghz but let's use cycles), I measured;

a == 72 cycles
c == 1080 cycles
d == 780 cycles

It may be partly apples and oranges, but it looks
like a good guess for b on my machine is

b == 240 cycles

Not bad, but is there any additional context switch
cost to support it?

> From: Avi Kivity [mailto:avi@redhat.com]
> Instead of using vgetcpu() and rdtsc() independently, you can 
> use rdtscp 
> to read both atomically.  This removes the need for the 
> preempt notifier.

Xen does not currently expose rdtscp and so does not emulate
(or context switch) TSC_AUX.  Context switching TSC_AUX
is certainly possible, but will likely be expensive.
If the primary reason for vsyscall+pvclock is to maximize
performance for gettimeofday/clock_gettime, this cost
would need to be added to the mix.

> preempt notifiers are per-thread, not global, and will upset 
> the cycle 
> counters.  I'd drop them and use rdtscp instead (and give up if the 
> processor doesn't support it).

Even if rdtscp is used, in the Intel processor lineup
only the very latest (Nehalem) supports rdtscp, so
"give up" doesn't seem like a very good option, at least
in the near future.
