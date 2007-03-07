Return-Path: <linux-kernel-owner+w=401wt.eu-S1030739AbXCGARb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030739AbXCGARb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030771AbXCGARb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:17:31 -0500
Received: from ozlabs.org ([203.10.76.45]:53009 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030739AbXCGARa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:17:30 -0500
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070306131041.GB9031@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <1173186107.4644.41.camel@localhost.localdomain>
	 <1173186214.4644.44.camel@localhost.localdomain>
	 <20070306131041.GB9031@elte.hu>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:12:30 +1100
Message-Id: <1173226350.4644.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 14:10 +0100, Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Currently x86 (similar to x84-64) has a special per-cpu structure 
> > called "i386_pda" which can be easily and efficiently referenced via 
> > the %fs register.  An ELF section is more flexible than a structure, 
> > allowing any piece of code to use this area.  Indeed, such a section 
> > already exists: the per-cpu area.
> > 
> > So this patch
> > (1) Removes the PDA and uses per-cpu variables for each current member.
> 
> hmm ... i very much like this, but its needs performance and kernel-size 
> testing before it can move from -mm into mainline. We are now exposing 
> wide ranges of the kernel to segment prefixes again. (Btw., i'd expect 
> there to be a kernel size reduction.)

Hi Ingo,

	Thanks!  There are some interesting issues.  Because __get_cpu_var()
returns an lvalue, we don't use the %fs:value directly, but calculate
offset (%fs:this_cpu_off + &value).  So previously there was only a tiny
code reduction.

	If we used __thread, then gcc could do this optimization for us when it
knows an rvalue is needed, however:

1) gcc wants to use %gs, not %fs, which is measurably slower for the
kernel,
2) gcc wants to use huge offsets to store the address of the per-cpu
space, and this breaks Xen (and current lguest, but new lguest no longer
uses segments for protection)

One solution would be to expose x86_read_percpu() as read_percpu() and
implement it in asm-generic/percpu.h as well, then use it in places
where only an rvalue is required.

Cheers!
Rusty.


