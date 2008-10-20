Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbYJTOkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbYJTOkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYJTOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:39:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYJTOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:39:57 -0400
Date: Mon, 20 Oct 2008 10:39:48 -0400
From: Neil Horman <nhorman@redhat.com>
To: Ivan Vecera <ivecera@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, nhorman@redhat.com, jmarchan@redhat.com
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in native_machine_halt
Message-ID: <20081020143948.GA13856@hmsendeavour.rdu.redhat.com>
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224504787-11403-1-git-send-email-ivecera@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:13:07PM +0200, Ivan Vecera wrote:
> Function machine_halt (resp. native_machine_halt) is empty for x86
> architectures. When command 'halt -f' is invoked, the message
> "System halted." is displayed but this is not really true because
> all CPUs are still running.
> There are also similar inconsistencies for other arches (some uses
> power-off for halt or forever-loop with IRQs enabled/disabled).
> IMO there should be used the same approach for all architectures
> OR what does the message "System halted" really mean?
> 
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  arch/x86/kernel/reboot.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index f4c93f1..15ad949 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -465,6 +465,14 @@ static void native_machine_restart(char *__unused)
>  
>  static void native_machine_halt(void)
>  {
> +	/* stop other cpus and apics */
> +	machine_shutdown();
> +
> +	/* stop this cpu */
> +	local_irq_disable();
> +	if (hlt_works(smp_processor_id()))
> +		for (;;) halt();
> +	for (;;);
>  }
>  
>  static void native_machine_power_off(void)
> -- 
> 1.5.6.3
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>

-- 
/***************************************************
 *Neil Horman
 *Senior Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
