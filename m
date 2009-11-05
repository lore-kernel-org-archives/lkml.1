Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZKEArR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZKEArR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZKEArQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:47:16 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:60019 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZKEArP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:47:15 -0500
MIME-Version: 1.0
Message-ID: <36e12dba-7580-4a9c-9fac-9e8d810e5a7c@default>
Date: Wed, 4 Nov 2009 16:45:04 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
In-Reply-To: <1257379338.10811.152.camel@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AF2202F.0190:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, possibly of interest.  But does it work with CONFIG_NO_HZ?
> > (I'm expecting that over time NO_HZ will become widespread
> > for VM OS's, though interested in if you agree.)
> 
> It should work, with CONFIG_NO_HZ, as soon as we come out of 
> a long idle
> (likely due to a timer tick), the timekeeping code will accumulate all
> the skipped ticks.
> 
> If we ever get to non-idle NOHZ, we'll need some extra work here
> (probably lazy accumulation done conditionally in the read path), but
> that's also true for filesystem timestamps. 

OK, sounds good.

> > Also very interested in your thoughts about a variation
> > that returns something similar to a TSC_AUX to notify
> > caller that the underlying reference clock has/may have
> > changed.
> 
> I haven't been following that closely. Personally, experience makes me
> skeptical of workarounds for unsynced TSCs. But I'm sure 
> there's sharper
> folks out there that might make it work. The kernel just requires that
> it *really really* works, and not "mostly" works. :)

This is less a workaround for unsynced TSCs than it
is for VM migration (and maybe also time where a
VM is out-of-context or moved to a different pcpu)
though it could probably
be made to work on unsynced TSC boxes also.
Basically an application needing hi-res profiling
info would do:

nsec1 = clock_gettime2(MONOTONIC,&aux1);
  (time passes)
nsec2 = clock_gettime2(MONOTONIC,&aux2);
if (aux1 != aux2)
   discard_measurement();
else
   use_measurement(nsec2-nsec1);

and system software (hypervisor or kernel or
both) is responsible for ensuring aux value
monotonically increases whenever a different
crystal is used.

Without something like this as a vsyscall,
apps will just use rdtscp (which must be emulated
to work properly across a migration).
