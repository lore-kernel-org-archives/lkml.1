Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXK0NqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXK0NqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXK0NqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:46:01 -0500
Received: from ns.suse.de ([195.135.220.2]:42086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbXK0NqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:46:01 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Date: Tue, 27 Nov 2007 14:45:56 +0100
User-Agent: KMail/1.9.6
Cc: Neil Horman <nhorman@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       hbabu@us.ibm.com, vgoyal@in.ibm.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271445.56792.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

his is any less reliable that what we have currently.
> 
> It doesn't make things more reliable, and it adds code to a code path
> that already has to much code to be solid reliable (thus your
> problem). 
> 
> Putting the system back in PIC legacy mode on the kexec on panic path
> was supposed to be a short term hack until we could remove the need
> by always deliver interrupts in apic mode.
> 
> If you can't root cause your problem and figure out how the apics
> are misconfigured for legacy mode

Probably legacy mode always routes to CPU #0. Makes sense and is
not really a misconfiguration of legacy mode.

But if CPU #0 has interrupts disabled no interrupts get delivered.

So choices are:
- Move to CPU #0
- Do not use legacy mode during shutdown.
- Or do not rely on interrupts after enabling legacy mode
- Or do not disable interrupts on the other CPUs when they're
halted.

First and last option are probably unreliable for the kdump case.
Second or third sound best. 

I suspect the real fix would be to enable IOAPIC mode really
early and never use the timers in legacy mode. Then the kdump
kernel wouldn't care about the legacy mode pointing to the wrong CPU.

IIrc Eric even had  a patch for that a long time ago, but it broke some 
things so it wasn't included. But perhaps it should be revisited.

-Andi

