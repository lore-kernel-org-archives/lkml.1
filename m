Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZDXA2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZDXA2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZDXA2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:28:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53573 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZDXA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:28:10 -0400
Message-ID: <49F1077A.5030801@jp.fujitsu.com>
Date: Fri, 24 Apr 2009 09:27:38 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
References: <20090407506.675031434@firstfloor.org>	 <20090407150657.61C4E1D046E@basil.firstfloor.org> <1240479838.6842.555.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240479838.6842.555.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Add some description for the patch, hope that to be more clear.
> 
> Best Regards,
> Huang Ying
> -------------------------------------------------->
> Impact: Spec compliance
> 
> Tolerant level 0 means: always panic on uncorrected errors, that is,
> panic even for recoverable uncorrected errors. This is a useful option
> for someone think panic is the better hardware error containment
> mechanism than trying to recover.
> 
> Current implementation does not comply with the tolerant == 0 spec,
> that is, it tries to recover (by killing related processes) for
> recoverable uncorrected errors (errors triggered in userspace) when
> tolerant == 0. This patch fixes this by going panic for that case.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kernel/cpu/mcheck/mce_64.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
> @@ -400,7 +400,7 @@ void do_machine_check(struct pt_regs * r
>  		 * force_sig() takes an awful lot of locks and has a slight
>  		 * risk of deadlocking.
>  		 */
> -		if (user_space) {
> +		if (user_space && tolerant > 0) {
>  			force_sig(SIGBUS, current);
>  		} else if (panic_on_oops || tolerant < 2) {
>  			mce_panic("Uncorrected machine check",
> 

Wait, I want confirmation.

Given:
 * Tolerant levels:
 *   0: always panic on uncorrected errors, log corrected errors

Let's walk do_machine_check():

    266 void do_machine_check(struct pt_regs * regs, long error_code)
    267 {
	:
    302         for (i = 0; i < banks; i++) {
	:
    311                 rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
    312                 if ((m.status & MCI_STATUS_VAL) == 0)
    313                         continue;
	:
    319                 if ((m.status & MCI_STATUS_UC) == 0)
    320                         continue;
	:
# Now we start checking status with VAL and UC
	:
    329                 if (m.status & MCI_STATUS_EN) {
    330                         /* if PCC was set, there's no way out */
    331                         no_way_out |= !!(m.status & MCI_STATUS_PCC);
    332                         /*
    333                          * If this error was uncorrectable and there was
    334                          * an overflow, we're in trouble.  If no overflow,
    335                          * we might get away with just killing a task.
    336                          */
    337                         if (m.status & MCI_STATUS_UC) {
    338                                 if (tolerant < 1 || m.status & MCI_STATUS_OVER)
    339                                         no_way_out = 1;
    340                                 kill_it = 1;
    341                         }
    342                 } else {
    343                         /*
    344                          * Machine check event was not enabled. Clear, but
    345                          * ignore.
    346                          */
    347                         continue;
    348                 }
	:
# Humm, second UC check should be removed...
# Anyway, in case of tolerant == 0, no_way_out == 1 if the event is enabled.
# And kill_it == 1 unless there are no event enabled.
# Therefore, in case of tolerant == 0, always "no_way_out == kill_it".
	:
    364                 }
    365         }
	:
    376         if (no_way_out && tolerant < 3)
    377                 mce_panic("Machine check", &panicm, mcestart);
	:
# in case of tolerant == 0, we usually hit here.
	:
    385         if (kill_it && tolerant < 3) {
    386                 int user_space = 0;
    387
    388                 /*
    389                  * If the EIPV bit is set, it means the saved IP is the
    390                  * instruction which caused the MCE.
    391                  */
    392                 if (m.mcgstatus & MCG_STATUS_EIPV)
    393                         user_space = panicm.ip && (panicm.cs & 3);
    394
    395                 /*
    396                  * If we know that the error was in user space, send a
    397                  * SIGBUS.  Otherwise, panic if tolerance is low.
    398                  *
    399                  * force_sig() takes an awful lot of locks and has a slight
    400                  * risk of deadlocking.
    401                  */
    402                 if (user_space) {
    403                         force_sig(SIGBUS, current);
    404                 } else if (panic_on_oops || tolerant < 2) {
    405                         mce_panic("Uncorrected machine check",
    406                                 &panicm, mcestart);
    407                 }
    408         }
	:
# Then, when we enter here with tolerant == 0 ?
	:
    421 }

Or, should this patch be applied after committing some of Andi's patches?
It means this patch targets a bug in Andi's patch set and the bug is not
in 2.6.30-rc* yet.


Thanks,
H.Seto

