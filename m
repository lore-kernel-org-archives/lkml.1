Return-Path: <linux-kernel-owner+w=401wt.eu-S1031252AbXFHTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031252AbXFHTok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967008AbXFHToN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:44:13 -0400
Received: from mail.suse.de ([195.135.220.2]:56228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbXFHToM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:44:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Date: Fri, 8 Jun 2007 21:42:21 +0200
User-Agent: KMail/1.9.6
Cc: "Jan Glauber" <jan.glauber@de.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>
References: <20070208203210.GB9798@osiris.ibm.com> <1171025838.5349.14.camel@localhost.localdomain> <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
In-Reply-To: <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706082142.21449.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 16:07:04 Satyam Sharma wrote:
> Hi,
> 
> I'm about six months late here(!), but I noticed this bug in
> arch/x86_64/kernel/smp.c while preparing another related
> patch today and then found this thread during Googling ...
> 
> On 2/9/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > On i386/x86_64 smp_call_function_single() takes call_lock with
> > spin_lock_bh(). To me this would imply that it is legal to call
> > smp_call_function_single() from softirq context.
> > It's not since smp_call_function() takes call_lock with just
> > spin_lock(). We can easily deadlock:
> >
> > -> [process context]
> > -> smp_call_function()
> > -> spin_lock(&call_lock)
> > -> IRQ -> do_softirq -> tasklet
> > -> [softirq context]
> > -> smp_call_function_single()
> > -> spin_lock_bh(&call_lock)
> > -> dead
> 
> You're absolutely right, and this bug still exists in the latest -git.

bug is definitely too strong a word. It might be unnecessary to disable bhs, 
but I don't see any bug in here as long as you can't show a case where
the smp_call_function() is called from BHs.

There was a patch floating around to use it from sysrq to display state
of all CPUs (and sysrq is softirq), but I don't think that ever
made it mainline.

And smp_call_function() can be called from panic which can violate
quite some assumptions, but some deadlock possibility there is ok.

I also don't like making it soft/hard irq save because that would
make it much more intrusive to the machine for no good reason
(e.g. slab can call it quite often in some cases)

The _bh should be probably just removed and possibly a WARN_ON added.

-Andi
