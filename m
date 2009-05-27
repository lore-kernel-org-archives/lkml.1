Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbZE0Eas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbZE0Eas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZE0Eah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:30:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54235 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZE0Eaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:30:35 -0400
Message-ID: <4A1CC1E0.2030300@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:30:24 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/31] x86: MCE: Fix EIPV behaviour with !PCC
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com> <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com> <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
In-Reply-To: <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> Impact: Spec compliance
> 
> When tolerant == 0, system should go panic instead of send SIGBUS even
> for a MCE with EPIV && !PCC on user space.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 3f158d7..e1271ac 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -485,7 +485,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		 * force_sig() takes an awful lot of locks and has a slight
>  		 * risk of deadlocking.
>  		 */
> -		if (user_space) {
> +		if (user_space && tolerant > 0) {
>  			force_sig(SIGBUS, current);
>  		} else if (panic_on_oops || tolerant < 2) {
>  			mce_panic("Uncorrected machine check",

Again, this patch is useless.

                if (m.status & MCI_STATUS_EN) {
                        /* if PCC was set, there's no way out */
                        no_way_out |= !!(m.status & MCI_STATUS_PCC);
                        /*
                         * If this error was uncorrectable and there was
                         * an overflow, we're in trouble.  If no overflow,
                         * we might get away with just killing a task.
                         */
                        if (m.status & MCI_STATUS_UC) {
                                if (tolerant < 1 || m.status & MCI_STATUS_OVER)
                                        no_way_out = 1;
                                kill_it = 1;
                        }
                } else {
 :
        if (no_way_out && tolerant < 3)
                mce_panic("Machine check", &panicm, mcestart);
 :
        if (kill_it && tolerant < 3) {
 :
                if (user_space) {
                        force_sig(SIGBUS, current);
                } else if (panic_on_oops || tolerant < 2) {
                        mce_panic("Uncorrected machine check",
                                &panicm, mcestart);
                }
        }

We never reach there with tolerant == 0.

And you will remove this code in your 25/31.


Thanks,
H.Seto

