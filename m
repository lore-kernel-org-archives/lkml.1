Return-Path: <linux-kernel-owner+w=401wt.eu-S934057AbXHYM2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057AbXHYM2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 08:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXHYM1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 08:27:51 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:36522 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXHYM1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 08:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=YSeuIRsOL2NJXJaVNnX2eD9AMySWk6OIHbXp0ihPQ3YbVZsz4xQiyBfHcyuW9RMU8tb0LRmCqXWINDH0h3Lo+teu6pCg3c3jvqbaBAL3OATBeO5qxXleXqIKnmcMjlrzQ2tG2SCFPHfzMe6mhajSVaXqGzDEY/sot8LJ3kP0wf4=
Date: Sat, 25 Aug 2007 14:23:24 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, kraxel@redhat.com
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-ID: <20070825122324.GA6138@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <20070823145038.9895784f.akpm@linux-foundation.org> <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org> <20070824082249.GG31846@slug> <1188043649.20041.81.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188043649.20041.81.camel@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 10:07:29PM +1000, Rusty Russell wrote:
> On Fri, 2007-08-24 at 10:22 +0200, Frederik Deweerdt wrote:
> > [Added Gerd Hoffman and Rusty Russel to cc]
> > On Thu, Aug 23, 2007 at 11:46:52PM -0700, Jeremy Fitzhardinge wrote:
> > > Frederik Deweerdt wrote:
> > > > That means that even when you specify noreplace_smp, some replacing
> > > > takes place anyway. One of the consequences, besides noreplace_smp not
> > > > working as expected, is that lguest crashes when you feed it an SMP kernel
> > > > (I suspect that you can not replace alternatives for smp _and_ paravirt).
> > > >   
> > > 
> > > No, that should be fine.  Why does lguest crash?
> > It dies with:
> > [    0.131000] SMP alternatives: switching to UP code
> > lguest: bad stack page 0xc057a000
Hello Rusty,
> 
> How odd!  This means that the guest set the kernel to a stack which it
> hadn't mapped writable (or perhaps not mapped at all).  I always run SMP

I had time to investigate this a little further, it appears that in fact
0xc057a000 is the beginning of the __smp_locks section.

The crash responsible function call is in alternative_instructions():
		free_init_pages("SMP alternatives",
				(unsigned long)__smp_locks,
				(unsigned long)__smp_locks_end);

Ie, if I comment this out, I can boot lguest without passing
noreplace_smp.

BTW, to make things clear: the patch I sent does _not_ fix the
lguest/alternatives problem. It just makes noreplace_smp functional
again and hence allows working around the lguest/alternatives bug.

> kernels, and that seems a very strange side effect of a patching
> problem...
> 
> Nonetheless, I did have a previous problem with a bug in the patching
> code which didn't show up native and did show up under lguest.
> 
> Can you send your config? 
Here it is:
http://fdeweerdt.free.fr/lguest_smp/dot_config

> Do you need noreplace-smp even on 2.6.23-rc3,
> or only 2.6.23-rc3-mm1?
I'll try ASAP.

Thanks,
Frederik
