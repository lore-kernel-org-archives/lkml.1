Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZDTFda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZDTFda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDTFdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:33:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZDTFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:33:20 -0400
Date: Mon, 20 Apr 2009 07:36:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [1/28] x86: Fix panic with interrupts off (needed for MCE)
Message-ID: <20090420053640.GU14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <20090407150740.D95E51D046D@basil.firstfloor.org> <49EBC150.2020407@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EBC150.2020407@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 09:26:56AM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> > I put the reboot vector into the highest priority bucket
> > of the APIC vectors and moved the 64bit UV_BAU message
> > down instead into the next lower priority.
> 
> I had forgotten to point this...
> 
> > @@ -88,12 +88,14 @@
> >  #define THERMAL_APIC_VECTOR		0xfa
> >  
> >  #ifdef CONFIG_X86_32
> > -/* 0xf8 - 0xf9 : free */
> > +/* 0xf9 : free */
> >  #else
> >  # define THRESHOLD_APIC_VECTOR		0xf9
> > -# define UV_BAU_MESSAGE			0xf8
> >  #endif
> >  
> > +#define REBOOT_VECTOR			0xf8
> > +
> > +
> >  /* f0-f7 used for spreading out TLB flushes: */
> >  #define INVALIDATE_TLB_VECTOR_END	0xf7
> >  #define INVALIDATE_TLB_VECTOR_START	0xf0
> > @@ -116,6 +118,8 @@
> >   */
> >  #define GENERIC_INTERRUPT_VECTOR	0xed
> >  
> > +#define UV_BAU_MESSAGE			0xec
> > +
> >  /*
> >   * First APIC vector available to drivers: (vectors 0x30-0xee) we
> >   * start at 0x31(0x41) to spread out vectors evenly between priority
> 
> Does this change (=pulling down the priority of UV_BAU_VECTOR) not impact
> users of the UV_BAU_MESSAGE?

I don't think UV_BAU_MESSAGE is really critical in that the world
explodes if it gets processed a little later. AFAIK it's just
used for user space TLB flushes. So putting it in a lower bucket
is fine.

BTW these priorities don't make too much difference anyways, it only
helps slightly under livelock situations when a lot of messages
are pending in the APIC. They're not a full spl like scheme.

> I can see why REBOOT_VECTOR need to be highest priority.

In theory a NMI would be be even better, but that has the usual 
problems with broken systems that don't handle NMIs properly.

> Maybe you could pull down THERMAL_APIC_VECTOR/THRESHOLD_APIC_VECTOR
> instead.  Why you choose UV_BAU_MESSAGE?

Thermal should probably stay in the high bucket too, but yes THRESHOLD_APIC
could be used too.

-Andi

P.S.: This patch is imho a 2.6.30 candidate too, without it all panics
with interrupts off (including all machimne checks) print ugly backtraces.
This has been a regression since two releases or so.

-- 
ak@linux.intel.com -- Speaking for myself only.
