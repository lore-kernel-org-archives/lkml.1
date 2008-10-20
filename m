Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbYJTJZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbYJTJZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJTJY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:24:56 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:35467 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYJTJYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:24:55 -0400
Message-ID: <48FC4E0C.7050008@fr.ibm.com>
Date: Mon, 20 Oct 2008 11:23:24 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 08/10] Introduce functions to restart a process
References: <1224285098-573-1-git-send-email-major@openvz.org>	<1224285098-573-2-git-send-email-major@openvz.org>	<1224285098-573-3-git-send-email-major@openvz.org>	<1224285098-573-4-git-send-email-major@openvz.org>	<1224285098-573-5-git-send-email-major@openvz.org>	<1224285098-573-6-git-send-email-major@openvz.org>	<1224285098-573-7-git-send-email-major@openvz.org>	<1224285098-573-8-git-send-email-major@openvz.org> <1224285098-573-9-git-send-email-major@openvz.org>
In-Reply-To: <1224285098-573-9-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrey !


> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 109792b..a4848a3 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -225,6 +225,7 @@ ENTRY(ret_from_fork)
>  	GET_THREAD_INFO(%ebp)
>  	popl %eax
>  	CFI_ADJUST_CFA_OFFSET -4
> +ret_from_fork_tail:
>  	pushl $0x0202			# Reset kernel eflags
>  	CFI_ADJUST_CFA_OFFSET 4
>  	popfl
> @@ -233,6 +234,26 @@ ENTRY(ret_from_fork)
>  	CFI_ENDPROC
>  END(ret_from_fork)
>  
> +ENTRY(i386_ret_from_resume)
> +	CFI_STARTPROC
> +	pushl %eax
> +	CFI_ADJUST_CFA_OFFSET 4
> +	call schedule_tail
> +	GET_THREAD_INFO(%ebp)
> +	popl %eax
> +	CFI_ADJUST_CFA_OFFSET -4
> +	movl (%esp), %eax
> +	testl %eax, %eax
> +	jz    1f
> +	pushl %esp
> +	call  *%eax
> +	addl  $4, %esp
> +1:
> +	addl  $256, %esp
> +	jmp   ret_from_fork_tail
> +	CFI_ENDPROC
> +END(i386_ret_from_resume)

Could you explain why you need to do this  

	call  *%eax

is it related to the freezer code ? 

C.
