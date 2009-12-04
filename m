Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZLDWP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZLDWP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZLDWP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:15:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52349 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZLDWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:15:56 -0500
Date: Fri, 4 Dec 2009 23:15:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
 verification
Message-ID: <20091204221553.GD32314@elf.ucw.cz>
References: <4A9CE0B2.5060608@intel.com>
 <4ABF2B50.6070106@intel.com>
 <20091004185801.GC1378@ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com>
 <20091204081933.GE1540@ucw.cz>
 <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-04 08:46:04, Cihula, Joseph wrote:
> > From: Pavel Machek [mailto:pavel@ucw.cz]
> > Sent: Friday, December 04, 2009 12:20 AM
> >
> > Hi!
> >
> > Please wrap mails at column 72 (or so).
> >
> > > > AFAICT, it verifies userspace _and_ kernel memory, that's why it does
> > > > magic stack switching. Why not verify everything in tboot?
> > > Because tboot only can access <4G mem without paging. And the memory is sparse. We
> > can't/needn't set unlimited sparse mem ranges to the MAC array with limited elements in the
> > shared page, in order to pass the parameters.
> > > On the other hand, it is reasonable for tboot to verify kernel, and kernel to verify
> > userspace memory.
> > >
> >
> > Are  you sure x86-64 kernel & modules is always below 4GB? I don't
> > think so.
> 
> The only part of the kernel that really needs to be below 4GB is what is used by the code on resume to do the MAC verification of the remainder of the memory.  This is all static code and variables.  The regions we pass to tboot for MAC'ing are:
> S3 real mode resume code:  acpi_wakeup_address, WAKEUP_SIZE
> AP trampoline code:  virt_to_phys(trampoline_base), TRAMPOLINE_SIZE
> kernel static code and data:  virt_to_phys(_text), _end - _text
> the stack we use (either new one or existing depending--see code):
>         virt_to_phys(new_stack), IRQ_STACK_SIZE
>         virt_to_phys(current_thread_info()), THREAD_SIZE
> 

Yes, so... what guarantees these actually are under 4GB? Perhaps you
should put them to spearate section and use linker magic?

You certainly should annotate them somehow so people modifying the
code know about this new requirement. 

> Can you post a .config and platform configuration for which the tboot, MAC, or do_suspend_lowlevel() are not within the regions above?  We'll be happy to address the issue once we understand the conditions.
> 

Can you prove that for all .config s on all machines they are under
4GB? On all future kernels, too? I thought so.

> > > >> +static vmac_t mem_mac;
> > > >> +static struct crypto_hash *tfm;
> > > >
> > > > Could these be automatic?
> > > Maybe, but I don't wish other files can access the variables and take tfm as an example, I'd
> > like to allocate memory to it once and then initialize it once in order to avoid impact of
> > memory change to MACing.
> > >
> >
> > You use stack, anyway.
> 
> Do you mean as static local variables?  If so, I'm not sure if that would be any better.
> 

Those two variables (mem_mac and tfm) are static. I do not think they
need to be, and code would be much nicer if they were not.

> > > > So I corrupt memory, but also corrupt tboot_enabled() to return 0....
> > > >
> > > > And... does panic kill the machine quickly enough that no 'bad stuff'
> > > > happens? (Whats bad stuff in this context, anyway?).
> >
> > I'd really like you to answer that.
> 
> "bad stuff" would be the execution of any code (or use of any data that affects execution) that was not verified by tboot.  As long as panic() is within the code ranges MAC'ed by tboot (see above), it would be covered.  Do you know of some panic() code paths that are outside of this?
> 

(Please wrap at column 72).

Yes, I know that panic() has problems.

> > > > Did you audit all code before sx_resume()? If it trusts  data not
> > > > checksummed by tboot, attacker may be able to hijack code execution
> > > > and bypass your protection, no?
> > > Yes, kernel code is audited by tboot before resume.
> >
> > So no, you did not audit do_suspend_lowlevel to make sure it does not
> > follow function pointers. Bad.
> 
> We aren't aware of any code or data used by the resume path that is outside of the tboot-MAC'ed regions above--if you can point out any then we will gladly address them.
>

I'm asking you to do the code audit, and you tell me to do it
myself. I'm not interested in doing your work. Yes, they are some
obvious places (like panic), that you missed. There are probably more.

Design your code properly so that it does not depend on details like
that. That means checksumming in tboot.

[Or do the auditing work. But don't try playing "we fixed all bugs
you told us about, so it must be perfect" game with me.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
