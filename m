Return-Path: <linux-kernel-owner+w=401wt.eu-S1763812AbXHXGJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812AbXHXGJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXHXGJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:09:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:61133 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbXHXGI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=rRIiX2yywaUHbj2F95w8/Iw7LxCRwMlJ9Ie+LpuagBV5AMimfDLfe5z6O/YRPjO91GzkNbUPZRv/uktC4qKzF8zdl5N033Xas5h/sfoLv9hLTpMhGJRLk8AmnsIUz6onfxQT38edTIKsS2W51/ag5VLjc+nyr7Vhn62pcNVUh3U=
Date: Fri, 24 Aug 2007 08:04:39 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-ID: <20070824060438.GE31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <20070823145038.9895784f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823145038.9895784f.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 02:50:38PM -0700, Andrew Morton wrote:
> On Wed, 22 Aug 2007 22:25:51 +0200
> Frederik Deweerdt <deweerdt@free.fr> wrote:
> 
> > On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > > 
> > Hi Jeremy,
> > 
> > arch/i386/kernel/alternative.c:alternative_instructions() doesn't
> > check for noreplace-smp before setting capability bits and freeing the
> > __smp_locks section.
> 
> umm, so?  What happens then?  What bug is being fixed here, and what are
> its consequences?
That means that even when you specify noreplace_smp, some replacing
takes place anyway. One of the consequences, besides noreplace_smp not
working as expected, is that lguest crashes when you feed it an SMP kernel
(I suspect that you can not replace alternatives for smp _and_ paravirt).
> 
> > Every call to alternatives_smp_unlock() checks for noreplace-smp
> > beforehand, so remove the check from there.
> > 
> > Boot tested on i386 with UP+noreplace-smp (lguest) and SMP (real hardware)
> > 
> > Regards,
> > Frederik
> > 
> > Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> > 
> > diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
> > index 9f4ac8b..7c5af80 100644
> > --- a/arch/i386/kernel/alternative.c
> > +++ b/arch/i386/kernel/alternative.c
> > @@ -221,9 +221,6 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
> >  	u8 **ptr;
> >  	char insn[1];
> >  
> > -	if (noreplace_smp)
> > -		return;
> > -
> >  	add_nops(insn, 1);
> >  	for (ptr = start; ptr < end; ptr++) {
> >  		if (*ptr < text)
> > @@ -406,7 +403,7 @@ void __init alternative_instructions(void)
> >  #endif
> >  
> >  #ifdef CONFIG_SMP
> > -	if (smp_alt_once) {
> > +	if (smp_alt_once && !noreplace_smp) {
> >  		if (1 == num_possible_cpus()) {
> >  			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
> >  			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
> 
> You refer to rc3-mm1 and this is described as a "-mm patch" but it seems to
> also be applicable to mainline?
> 
Hmm yes, my bad.

Regards,
Frederik
