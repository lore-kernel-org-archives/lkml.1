Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZJTHVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZJTHVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZJTHVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:21:40 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:40352 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZJTHVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:21:40 -0400
Message-ID: <4ADD64FC.3070006@gmail.com>
Date: Tue, 20 Oct 2009 09:21:32 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: adjust ia32entry branches for better static	
 prediction
References: <4ADD7E6C020000780001AD73@vpn.id2.novell.com>
In-Reply-To: <4ADD7E6C020000780001AD73@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 20 Oct 2009 09:21:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich a écrit :
> Swap branch pairs so that the static branch prediction logic would
> consider the syscall-number-in-range case the taken path.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/ia32/ia32entry.S |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> --- linux-2.6.32-rc5/arch/x86/ia32/ia32entry.S	2009-10-19 13:12:43.000000000 +0200
> +++ 2.6.32-rc5-x86_64-ia32-syscall-trace-branch-dir/arch/x86/ia32/ia32entry.S	2009-10-19 09:36:39.000000000 +0200
> @@ -249,9 +249,9 @@ sysenter_tracesys:
>  	call	syscall_trace_enter
>  	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
>  	RESTORE_REST
> -	cmpl	$(IA32_NR_syscalls-1),%eax
> -	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
> -	jmp	sysenter_do_call
> +	cmpl	$IA32_NR_syscalls,%eax
> +	jb	sysenter_do_call
> +	jmp	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
>  	CFI_ENDPROC

on cmov enabled build, we could use cmov instruction to load eax with number
that calls enosys_syscall(), to avoid loading -ENOSYS,RAX
and these branches...

