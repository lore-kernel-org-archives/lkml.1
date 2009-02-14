Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZBNUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZBNUWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZBNUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:22:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZBNUWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:22:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] x86_64: fix s3 fail path
Date: Sat, 14 Feb 2009 21:21:46 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: lenb@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>
References: <1234190120-6268-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1234190120-6268-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142121.46987.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Jiri Slaby wrote:
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
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

What kernel is this patch against?  It doesn't apply to the mainline.

Thanks,
Rafael


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
