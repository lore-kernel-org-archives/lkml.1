Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYHMDno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYHMDno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYHMDnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:43:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56529 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbYHMDnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:43:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Huang Ying <ying.huang@intel.com>
Cc: Simon Horman <horms@verge.net.au>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
References: <1218589475.24951.59.camel@caritas-dev.intel.com>
	<20080813024701.GA19201@verge.net.au>
	<1218596715.24951.69.camel@caritas-dev.intel.com>
Date: Tue, 12 Aug 2008 20:40:19 -0700
In-Reply-To: <1218596715.24951.69.camel@caritas-dev.intel.com> (Huang Ying's
	message of "Wed, 13 Aug 2008 11:05:15 +0800")
Message-ID: <m1d4kdk2fw.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Huang Ying <ying.huang@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0360]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec jump: fix code size checking
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> On Wed, 2008-08-13 at 12:47 +1000, Simon Horman wrote:
>> On Wed, Aug 13, 2008 at 09:04:35AM +0800, Huang Ying wrote:
>> > Fix building issue when CONFIG_KEXEC=n. Thanks to Vivek Goyal for his
>> > reminding.
>> > 
>> > Signed-off-by: Huang Ying <ying.huang@intel.com>
>> > 
>> > ---
>> >  include/asm-x86/kexec.h |    3 +++
>> >  1 file changed, 3 insertions(+)
>> > 
>> > --- a/include/asm-x86/kexec.h
>> > +++ b/include/asm-x86/kexec.h
>> > @@ -43,6 +43,9 @@
>> >  
>> >  #ifdef CONFIG_X86_32
>> >  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
>> > +# ifndef CONFIG_KEXEC
>> > +#  define kexec_control_code_size	0
>> > +# endif
>> >  #endif
>> >  
>> >  #ifndef __ASSEMBLY__
>> 
>> Is it impossible to skip the linker check in the !CONFIG_KEXEC case?
>
> It is possible. I think there are several ways to do that.
>
> 1) use #ifdef in vmlinux_32.lds.S, such as:
>
> #ifdef CONFIG_KEXEC
> ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
>        "kexec control code size is too big")
> #endif
>
> 2) #define a macro for kexec check ld script in asm/kexec.h, such as:
>
> #define LD_CHECK_KEXEC() ASSERT(kexec_control_code_size <=
> KEXEC_CONTROL_CODE_MAX_SIZE, \
> 				       "kexec control code size is too big")
>
> and use that in vmlinux_32.lds.S.
>
> 3) #define kexec_control_code_size 0. So that the check can be passed
> always. And, code size = 0 is reasonable for no code (CONFIG_KEXEC=n).
>
>
> I think 3) is better. What do you think about?

4) Put the code is a special section .text.kexec? and have the linker
   always do the size comparison and the computation of the section size.

The fewer conditionals we have the less likely something is to break.

Eric
