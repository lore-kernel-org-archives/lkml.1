Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXIHI6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXIHI6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXIHI55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:57:57 -0400
Received: from ns.suse.de ([195.135.220.2]:44509 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXIHI54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:57:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
Date: Sat, 8 Sep 2007 10:57:50 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       jakub@redhat.com, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200709011207.58201.ak@suse.de> <46E1A8ED.8090104@redhat.com>
In-Reply-To: <46E1A8ED.8090104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081057.51144.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> In the vdso code:
> 
> static inline long vgetns(void)
> {
>         cycles_t (*vread)(void);
>         vread = gtod->clock.vread;
>         return ((vread() - gtod->clock.cycle_last) * gtod->clock.mult) >>
>                 gtod->clock.shift;
> }
> 
> 
> Looks like an open-coded version of this in the kernel timekeeping code:

vdso code needs to be all inlined because the vdso runs in ring 3 and cannot
access other kernel code.

It was opencoded it to have more control over the code (vdso requirements
are a bit peculiar).

> But the vdso version isn't doing any masking. And the mask is different for
> different clocksources, so it has to track the underlying kernel's clocksource
> when it gets changed.

vdso effectively only supports TSC and HPET (the other clock sources are not accessible
from ring 3)

TSC doesn't need a mask, but many HPETs need a 32bit mask; good point.

Does adding the mask to vgetns make the clock problems go away?

-Andi

