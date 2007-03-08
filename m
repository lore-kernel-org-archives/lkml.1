Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXCHFfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXCHFfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXCHFfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:35:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45345 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXCHFfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:35:06 -0500
Date: Thu, 8 Mar 2007 11:04:59 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 15/20] Move swsusp __pa() dependent code to arch portion
Message-ID: <20070308053459.GI6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <20070307071850.GP23412@in.ibm.com> <20070307224740.GF5956@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307224740.GF5956@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:47:40PM +0100, Pavel Machek wrote:
> Hi!
> 
> > o __pa() should be used only on kernel linearly mapped virtual addresses
> >   and not on kernel text and data addresses.
> > 
> > o Hibernation code needs to determine the physical address associated
> >   with kernel symbol to mark a section boundary which contains pages which
> >   don't have to be saved and restored during hibernate/resume operation.
> > 
> > o Move this piece of code in arch dependent section. So that architectures
> >   which don't have kernel text/data mapped into kernel linearly mapped
> >   region can come up with their own ways of determining physical addresses
> >   associated with a kernel text.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> 
> ...hmm, but that means 3 copies of same code. Can we put the
> 

Actually it is not exactly same code. i386 and x86_64 use __pa_symbol()
and powerpc uses __pa() for determining physical address associated with
a kernel text symbol. That's the precise intent here. Leave it to arch
code to decide how to calculate physical address associated with a kernel
symbol.

> > +/*
> > + *	pfn_is_nosave - check if given pfn is in the 'nosave' section
> > + */
> > +
> > +int pfn_is_nosave(unsigned long pfn)
> > +{
> > +	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
> > +	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
> > +	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> > +}
> 
> ...in asm-generic/suspend.h (or something) and then just include it?
> 									Pavel

As code is not exactly same, we can't put it in asm-generic/suspend.h.

Thanks
Vivek
