Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYI3IMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYI3IMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYI3IMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:12:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYI3IMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:12:13 -0400
Message-ID: <48E1DF2C.9050409@redhat.com>
Date: Tue, 30 Sep 2008 10:11:24 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>	 <48E15AC7.2080603@redhat.com> <1222734838.30247.102.camel@alok-dev1>
In-Reply-To: <1222734838.30247.102.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi Gerd,
> 
> I really fail to see your point here. Maybe you can point out what am i
> missing.
> Think about the current situation, whenever there is migration to such a
> tsc-is-different system , how does the guest come to know about the
> frequency change, either through a $event or if it reboots it runs the
> calibration algorithm.

Well, that should be clearly defined, that is my point.  When asking the
hypervisor for the tsc instead of running a calibration loop, then we
have a small bit of paravirtualization:  The guest is aware that it runs
on a hypervisor and just asks it directly.  So while we are at it we can
also define a way to communicate tsc freq changes between host and
guest, so the cost of trap'n'emulate tsc reads can be avoided.  Or we
define "tsc is constant" and leave it to the hypervisor to make sure it
actually appears being constant to the guest, even in case it changes on
the host.  But it must be defined one way or another, so the guest knows
whenever it should expect the tsc frequency change or not.  And in case
we allow tsc changes, we also need a way to signal that to the guest.

Is the tsc cpu leaf interface set in stone already (aka implemented in
vmware versions released to public)?

> What special things does Xen do at migration, which would be affected by
> this interface ?

paravirtualized xen guests have a paravirtual clock.  That is a struct
containing three pieces of information: system time, tsc counter for the
last system time update, tsc frequency.  The guest gets the current time
by reading the system time and adding a delta calculated from current
tsc, tsc of last systime update and tsc frequency.  Handling tsc
frequency changes is obviously trivial here, just update the field on
the next systime update ;)

cheers,
  Gerd
