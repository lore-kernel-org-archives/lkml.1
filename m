Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZLDQqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZLDQqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZLDQqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:46:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:48650 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbZLDQqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218900692"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Pavel Machek <pavel@ucw.cz>, "Wang, Shane" <shane.wang@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Date: Fri, 4 Dec 2009 08:46:04 -0800
Subject: RE: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Thread-Topic: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Thread-Index: Acp08fBXVuvABo7ISteOA0YGBETK+AAC2o9A
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com>
 <20091004185801.GC1378@ucw.cz>
 <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com>
 <20091204081933.GE1540@ucw.cz>
In-Reply-To: <20091204081933.GE1540@ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Friday, December 04, 2009 12:20 AM
>
> Hi!
>
> Please wrap mails at column 72 (or so).
>
> > > AFAICT, it verifies userspace _and_ kernel memory, that's why it does
> > > magic stack switching. Why not verify everything in tboot?
> > Because tboot only can access <4G mem without paging. And the memory is sparse. We
> can't/needn't set unlimited sparse mem ranges to the MAC array with limited elements in the
> shared page, in order to pass the parameters.
> > On the other hand, it is reasonable for tboot to verify kernel, and kernel to verify
> userspace memory.
> >
>
> Are  you sure x86-64 kernel & modules is always below 4GB? I don't
> think so.

The only part of the kernel that really needs to be below 4GB is what is used by the code on resume to do the MAC verification of the remainder of the memory.  This is all static code and variables.  The regions we pass to tboot for MAC'ing are:
S3 real mode resume code:  acpi_wakeup_address, WAKEUP_SIZE
AP trampoline code:  virt_to_phys(trampoline_base), TRAMPOLINE_SIZE
kernel static code and data:  virt_to_phys(_text), _end - _text
the stack we use (either new one or existing depending--see code):
        virt_to_phys(new_stack), IRQ_STACK_SIZE
        virt_to_phys(current_thread_info()), THREAD_SIZE


Can you post a .config and platform configuration for which the tboot, MAC, or do_suspend_lowlevel() are not within the regions above?  We'll be happy to address the issue once we understand the conditions.

> > >> +static vmac_t mem_mac;
> > >> +static struct crypto_hash *tfm;
> > >
> > > Could these be automatic?
> > Maybe, but I don't wish other files can access the variables and take tfm as an example, I'd
> like to allocate memory to it once and then initialize it once in order to avoid impact of
> memory change to MACing.
> >
>
> You use stack, anyway.

Do you mean as static local variables?  If so, I'm not sure if that would be any better.

> > > Why does 4G limit matter on 64-bit?
> > tboot can't access >4G, see above.
>
> Too bad, then its broken by design.

See above.

> > >> +        if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
> > >> +                panic("tboot: vmac generation failed\n");
> > >> +        else if (mac != mem_mac)
> > >> +                panic("tboot: memory integrity was lost on resume\n"); +        else
> > >> +                pr_info("memory integrity OK\n");
> > >
> > > So I corrupt memory, but also corrupt tboot_enabled() to return 0....
> > >
> > > And... does panic kill the machine quickly enough that no 'bad stuff'
> > > happens? (Whats bad stuff in this context, anyway?).
>
> I'd really like you to answer that.

"bad stuff" would be the execution of any code (or use of any data that affects execution) that was not verified by tboot.  As long as panic() is within the code ranges MAC'ed by tboot (see above), it would be covered.  Do you know of some panic() code paths that are outside of this?

> > >> @@ -244,7 +245,10 @@ static int acpi_suspend_enter(suspend_st
> > >> break;
> > >>
> > >>          case ACPI_STATE_S3:
> > >> +                tboot_switch_stack();
> > >>                  do_suspend_lowlevel();
> > >> +                tboot_sx_resume();
> > >> +                tboot_restore_stack();
> > >>                  break;
> > >>          }
> > >>
> > >
> > > Did you audit all code before sx_resume()? If it trusts  data not
> > > checksummed by tboot, attacker may be able to hijack code execution
> > > and bypass your protection, no?
> > Yes, kernel code is audited by tboot before resume.
>
> So no, you did not audit do_suspend_lowlevel to make sure it does not
> follow function pointers. Bad.

We aren't aware of any code or data used by the resume path that is outside of the tboot-MAC'ed regions above--if you can point out any then we will gladly address them.

>                                                                       Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
