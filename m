Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbYARJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbYARJWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYARJWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:22:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:9846 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbYARJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C4JX5WCFnN3Q+AWx4AUJwyEw9OgmpnZ2YBYmCFl+eITKt+PUdGLsASHOwedNphSQzMF0TwFuLRlKEYare1QDVLg2clGTBpvJDEcM44lTBaSComRBACQvwXrc+ij06jlBbFruZCnuZkKMDJQr/Qkvh8xyKYMbWznEeRstYI/gDbg=
Subject: Re: [PATCHv2] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080118091208.GE24337@elte.hu>
References: <1200615957.5724.75.camel@brick>
	 <20080118091208.GE24337@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 01:22:00 -0800
Message-Id: <1200648120.5724.131.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 10:12 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Use v8086_mode inline in fault_32.c, no functional change also ifdef 
> > the section for 32-bit only and add to fault_64.c
> 
> > -	if (regs->flags & VM_MASK) {
> > +	if (v8086_mode(regs)) {
> 
> > --- a/arch/x86/mm/fault_64.c
> > +++ b/arch/x86/mm/fault_64.c
> > @@ -551,6 +551,16 @@ good_area:
> >  		tsk->maj_flt++;
> >  	else
> >  		tsk->min_flt++;
> > +
> > +	/*
> > +	 * Did it hit the DOS screen memory VA from vm86 mode?
> > +	 */
> > +	if (v8086_mode(regs)) {
> > +		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
> > +		if (bit < 32)
> > +			tsk->thread.screen_bitmap |= 1 << bit;
> > +	}
> 
> hm, is there even vm86 mode in 64-bit? Anyway, gcc will eliminate it i 
> guess. I've applied your patch.
> 

No, it doesn't mean anything to 64-bit, but helps make the diff a little
bit smaller, getting pretty close now.

Still needs a bit of work to introduce oops_begin/end from 64-bit to
32-bit in traps_32.c and introduce a bad_pgtable-like function to
32bit, then we're down to small differences between 32/64 bit
do_page_fault and vmalloc_sync_all that should be relatively clean
to harmonize.

Got distracted with the ptrace stuff today, but patch coming soon.

Harvey

