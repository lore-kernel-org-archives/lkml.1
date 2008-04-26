Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYDZKCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYDZKCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 06:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYDZKCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 06:02:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:31586 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYDZKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 06:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=tIvyZfduKQvlLffTx8boSLVLbNA3p3hNveCeGKtEyqUYOCKd4ePMuC9a6s9HZbjc0Qi2cA94YCRCnFmRftZRlZ42b97dg3CQr19jrnbRpAlGNIphAF+P6egKB8D6hZaXoPr1gSW4+uJ5oxaasR3Bg0s5etlYa1Rzwhx7Nr3Ak7s=
Date: Sat, 26 Apr 2008 18:01:12 +0800 (CST)
Message-Id: <20080426.180112.184545994.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/19] UML - Tidy stub management code
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080425175606.GA11174@c2.user-mode-linux.org>
References: <20080425175606.GA11174@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Fri, 25 Apr 2008 13:56:06 -0400
> Restructure the stub management code to make it simpler.
> 
> syscall_stub_done is extracted from do_syscall_stub.
> 
> The counters are gone since I never looked at them.
> 
> The common code in run_syscall_stub and syscall_stub_data is extracted
> into flush_syscalls.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  arch/um/os-Linux/skas/mem.c |  162 +++++++++++++++++++++++---------------------
>  1 file changed, 85 insertions(+), 77 deletions(-)
> 
> Index: linux-2.6-git/arch/um/os-Linux/skas/mem.c
> ===================================================================
> --- linux-2.6-git.orig/arch/um/os-Linux/skas/mem.c	2008-04-25 11:36:59.000000000 -0400
> +++ linux-2.6-git/arch/um/os-Linux/skas/mem.c	2008-04-25 11:39:07.000000000 -0400
> @@ -40,35 +40,69 @@ static unsigned long syscall_regs[MAX_RE
>  
>  static int __init init_syscall_regs(void)
>  {
> +	unsigned long *stub_entry;
> +
>  	get_safe_registers(syscall_regs);
> +	stub_entry = &batch_syscall_stub;
> +
>  	syscall_regs[REGS_IP_INDEX] = STUB_CODE +
> -		((unsigned long) &batch_syscall_stub -
> +		((unsigned long) stub_entry -
>  		 (unsigned long) &__syscall_stub_start);
>  	return 0;
>  }
>  
>  __initcall(init_syscall_regs);
>  
> -extern int proc_mm;
> +static int syscall_stub_done(unsigned long stack)
> +{
> +	unsigned long *syscall, *data, offset;
> +	int ret, n;
> +
> +	/*
> +	 * When the stub stops, we find the following values on the
> +	 * beginning of the stack:
> +	 * (long) return_value
> +	 * (long) offset to failed sycall data (0 if no error)
> +	 */
> +	ret = *((unsigned long *) stack);


I am afraid the value will be truncated on 64bit machine, since
'ret' is 'int' while 'stack' points to an 'unsigned long'.

Is this expected?

Thanks.
