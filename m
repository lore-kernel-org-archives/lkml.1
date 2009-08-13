Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZHMPqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZHMPqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZHMPqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:46:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbZHMPqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:46:43 -0400
Date: Thu, 13 Aug 2009 17:46:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Wang, Shane" <shane.wang@intel.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
Message-ID: <20090813154610.GB21002@elte.hu>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com> <20090813064634.GA12143@elte.hu> <4A842C5B.7050100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A842C5B.7050100@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/12/2009 11:46 PM, Ingo Molnar wrote:
> > * Wang, Shane <shane.wang@intel.com> wrote:
> > 
> >> Signed-off-by: Shane Wang <shane.wang@intel.com>
> >>
> >> diff -r 7358cf1b3090 arch/x86/kernel/tboot.c
> >> --- a/arch/x86/kernel/tboot.c   Wed Aug 12 03:04:23 2009 -0700
> >> +++ b/arch/x86/kernel/tboot.c   Wed Aug 12 18:06:21 2009 -0700
> >> @@ -169,6 +169,7 @@ void tboot_create_trampoline(void)
> >>
> >>  static void set_mac_regions(void)
> >>  {
> >> +#ifdef CONFIG_ACPI_SLEEP
> >>         tboot->num_mac_regions = 3;
> >>         /* S3 resume code */
> >>         tboot->mac_regions[0].start = PFN_PHYS(PFN_DOWN(acpi_wakeup_address));
> >> @@ -181,6 +182,7 @@ static void set_mac_regions(void)
> >>         tboot->mac_regions[2].start = PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> >>         tboot->mac_regions[2].size = PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
> >>                                      PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> >> +#endif
> > 
> > These #ifdefs are quite ugly. Why not add a 'depends on ACPI_SLEEP' 
> > rule to the INTEL_TXT Kconfig section?
> 
> I *strongly* disagree with that kind of false dependencies.  It 
> makes it seem like there is something magic going on, which 
> invites cargo cult programming in the future.  I also think those 
> particular #ifdefs are fairly innocuous... it's not like they're 
> hiding flow of control or major chunks of code.

no argument about that. But i'd rather have some extra dependency 
on a Kconfig than ugly #ifdefs.

and while it's certainly not the same kind of dependency as 
'depends on ACPI', it's not really a false dependency either, it's 
just a different technical dependency: 'the ACPI_SLEEP interfaces 
suck a bit and we could only offer !ACPI_SLEEP support by uglifying 
the .c code - so we'll opt for always having it'.

> However, I think the actual code to set the sections is ugly as 
> hell, which is probably why the #ifdef sticks in your eyes.

Yeah.

> Consider the attached instead patch, which abstracts some of the 
> (way more complex than it should be) open-coded stuff and 
> therefore makes it stick out less.

it's better, but why not put these:

> +#ifdef CONFIG_ACPI_SLEEP
>  	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
> +#endif

into a helper inline in a header file and let the #ifdefs be there, 
or something like that. That way the .c file stays readable.

I.e. we can cleanly support !ACPI_SLEEP case too, because it's 
encapsulated and abstracted away.

	Ingo
