Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYGBQNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYGBQNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYGBQM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:12:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:52470 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYGBQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FcsT8/Df13TU3xoLUCnPIhg+skzLY67gFRKuk+tYHhxBpk4/brbEMN1A3R5Ep9zMmG
         jpOUbe8zxgICHEB+zNYsqT5Il+2sn2RFpJB5N045MAyPQIWe9/Y7gpilBzmb6uVOtrsh
         2BGZ45fvAtPs7uU4107sSV6nIa5MS5prueA/Y=
Date: Wed, 2 Jul 2008 20:12:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: traps_xx: modify default_do_nmi
Message-ID: <20080702161220.GA7003@cvg>
References: <20080701193643.GA29695@mailshack.com> <20080701233227.GF29903@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701233227.GF29903@mailshack.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Wed, Jul 02, 2008 at 01:32:28AM +0200]
|  - local caching of smp_processor_id()
| 
| Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| ---
|  arch/x86/kernel/traps_32.c |   12 ++++++++----
|  arch/x86/kernel/traps_64.c |    3 ++-
|  2 files changed, 10 insertions(+), 5 deletions(-)
| 
| diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
| index 68e800f..14fe3cd 100644
| --- a/arch/x86/kernel/traps_32.c
| +++ b/arch/x86/kernel/traps_32.c
| @@ -790,12 +790,16 @@ void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
|  	do_exit(SIGSEGV);
|  }
|  
| -static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
| +static notrace __kprobes void
| +default_do_nmi(struct pt_regs *regs)
|  {
|  	unsigned char reason = 0;
| +	int cpu;
| +
| +	cpu = smp_processor_id();
|  
| -	/* Only the BSP gets external NMIs from the system: */
| -	if (!smp_processor_id())
| +	/* Only the BSP gets external NMIs from the system. */
| +	if (!cpu)
|  		reason = get_nmi_reason();
|  
|  	if (!(reason & 0xc0)) {
| @@ -809,7 +813,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
|  		 */
|  		if (nmi_watchdog_tick(regs, reason))
|  			return;
| -		if (!do_nmi_callback(regs, smp_processor_id()))
| +		if (!do_nmi_callback(regs, cpu))
|  			unknown_nmi_error(reason, regs);
|  #else
|  		unknown_nmi_error(reason, regs);
| diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
| index 677b4e5..2f8d87d 100644
| --- a/arch/x86/kernel/traps_64.c
| +++ b/arch/x86/kernel/traps_64.c
| @@ -832,7 +832,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
|  
|  /* Runs on IST stack. This code must keep interrupts off all the time.
|     Nested NMIs are prevented by the CPU. */
| -asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
| +asmlinkage notrace __kprobes void
| +default_do_nmi(struct pt_regs *regs)
|  {
|  	unsigned char reason = 0;
|  	int cpu;
| -- 
| 1.5.4.3
| 
| 

Hi Alexander, good done, thanks! But why did you split default_do_nmi
definition by two lines? I think it would be better to keep them as it
was before, ie by a single line

	static notrace __kprobes void default_do_nmi(struct pt_regs *regs)

		- Cyrill -
