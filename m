Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZLDO4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZLDO4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZLDO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:56:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39273 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610AbZLDO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:56:05 -0500
Date: Fri, 4 Dec 2009 09:19:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Message-ID: <20091204081933.GE1540@ucw.cz>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Please wrap mails at column 72 (or so).

> > AFAICT, it verifies userspace _and_ kernel memory, that's why it does
> > magic stack switching. Why not verify everything in tboot?
> Because tboot only can access <4G mem without paging. And the memory is sparse. We can't/needn't set unlimited sparse mem ranges to the MAC array with limited elements in the shared page, in order to pass the parameters.
> On the other hand, it is reasonable for tboot to verify kernel, and kernel to verify userspace memory.
>

Are  you sure x86-64 kernel & modules is always below 4GB? I don't
think so.

 
> >> +static vmac_t mem_mac;
> >> +static struct crypto_hash *tfm;
> > 
> > Could these be automatic?
> Maybe, but I don't wish other files can access the variables and take tfm as an example, I'd like to allocate memory to it once and then initialize it once in order to avoid impact of memory change to MACing.
>

You use stack, anyway.

> > Why does 4G limit matter on 64-bit?
> tboot can't access >4G, see above.

Too bad, then its broken by design.

> >> +	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
> >> +		panic("tboot: vmac generation failed\n");
> >> +	else if (mac != mem_mac)
> >> +		panic("tboot: memory integrity was lost on resume\n"); +	else
> >> +		pr_info("memory integrity OK\n");
> > 
> > So I corrupt memory, but also corrupt tboot_enabled() to return 0....
> > 
> > And... does panic kill the machine quickly enough that no 'bad stuff'
> > happens? (Whats bad stuff in this context, anyway?).

I'd really like you to answer that.


> >> @@ -244,7 +245,10 @@ static int acpi_suspend_enter(suspend_st 
> >> break; 
> >> 
> >>  	case ACPI_STATE_S3:
> >> +		tboot_switch_stack();
> >>  		do_suspend_lowlevel();
> >> +		tboot_sx_resume();
> >> +		tboot_restore_stack();
> >>  		break;
> >>  	}
> >> 
> > 
> > Did you audit all code before sx_resume()? If it trusts  data not
> > checksummed by tboot, attacker may be able to hijack code execution
> > and bypass your protection, no?
> Yes, kernel code is audited by tboot before resume.

So no, you did not audit do_suspend_lowlevel to make sure it does not
follow function pointers. Bad.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
