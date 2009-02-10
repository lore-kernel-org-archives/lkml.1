Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZBJKI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZBJKI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZBJKIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:08:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57769 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZBJKIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:08:18 -0500
Date: Tue, 10 Feb 2009 11:08:16 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: lenb@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/1] x86_64: fix s3 fail path
Message-ID: <20090210100816.GA27018@atrey.karlin.mff.cuni.cz>
References: <1234190120-6268-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234190120-6268-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As acpi_enter_sleep_state can fail, take this into account in
> do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
> caller. This would break (currently) fpu status and preempt count.
> 
> Technically, this means use `call' instead of `jmp' and `jmp' to
> the `resume_point' after the `call' (i.e. if
> acpi_enter_sleep_state returns=fails). `resume_point' will handle
> the restore of fpu and preempt count gracefully.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Machek <pavel@suse.cz>

Acked-by: Pavel Machek <pavel@suse.cz>

> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/acpi/wakeup_64.S |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
> index b5dee6a..96258d9 100644
> --- a/arch/x86/kernel/acpi/wakeup_64.S
> +++ b/arch/x86/kernel/acpi/wakeup_64.S
> @@ -73,7 +73,9 @@ ENTRY(do_suspend_lowlevel)
>  	addq	$8, %rsp
>  	movl	$3, %edi
>  	xorl	%eax, %eax
> -	jmp	acpi_enter_sleep_state
> +	call	acpi_enter_sleep_state
> +	/* in case something went wrong, restore the machine status and go on */
> +	jmp	resume_point
>  
>  	.align 4
>  resume_point:

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
