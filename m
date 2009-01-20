Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZATHQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZATHQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZATHQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:16:00 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:39845 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZATHP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:15:59 -0500
Date: Tue, 20 Jan 2009 08:15:56 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Justin Madru <jdm64@gawab.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jesper Juhl <jj@chaosbits.net>, lkml <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [bisected] 2.6.29-rc1 Firefox crashing on page load
Message-ID: <20090120071555.GA6165@osiris.boeblingen.de.ibm.com>
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com> <49751BA0.1040004@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49751BA0.1040004@gawab.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 04:32:32PM -0800, Justin Madru wrote:
> Justin P. Mattock wrote:
>> Justin Madru wrote:
> Ok, finally bisected the bug, but the commit isn't related to networking!
> I did: git revert 4217458dafaa57d8e26a46f5d05ab8c53cf64191
> commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191
> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Date:   Fri Dec 5 17:17:09 2008 -0800
>
>    x86: signal: change type of paramter for sys_rt_sigreturn()
>
>    Impact: cleanup on 32-bit
>
>    Peter pointed this parameter can be changed.
>
>    Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> :040000 040000 f5fba48247ff200092c38a54e334f495917229d5  
> b901159897e5d85e0dc2a0c9d904d9a73c1d58a2 M      arch
>
>    arch/x86/include/asm/syscalls.h
>    arch/x86/kernel/signal.c
>
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index b1f4d34..b1cc6da 100644 (file)
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -642,11 +642,9 @@ badframe:
> }
>
> #ifdef CONFIG_X86_32
> -asmlinkage int sys_rt_sigreturn(unsigned long __unused)
> +asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
> {
> -       struct pt_regs *regs = (struct pt_regs *)&__unused;

This probably should have been converted to

asmlinkage long sys_rt_sigreturn(void)
{
	struct pt_regs *regs = task_pt_regs(current);
	[...]

> -
> -       return do_rt_sigreturn(regs);
> +       return do_rt_sigreturn(&regs);
> }
> #else /* !CONFIG_X86_32 */
> asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)

Also there's no reason to have different sys_rt_sigreturn implementations
for 32 and 64 bit. They just could be merged with do_rt_sigreturn.
