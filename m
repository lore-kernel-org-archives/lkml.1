Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbYAJT3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbYAJT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYAJT33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:29:29 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:5027 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYAJT32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:29:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cqy4BBI8dSVBlFKGetpIUFx6i86yfaKC3CCQokPlPoHxmdmCNJcfXvF2JhL+BAY09kHBpNemapqj6ExltPrZCkyKjeBI5u8NSYkJXr8PfGptAOoSdcyaQp4+shIvNsVmOoPDXl/PMHw30wsYjBb7uDmOCYyt0WoWMDPgOCci5zU=
Subject: Re: [PATCH] x86: Remove ifdef from step.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080110124041.GA15156@elte.hu>
References: <1199949482.19760.9.camel@brick>
	 <20080110124041.GA15156@elte.hu>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 11:29:24 -0800
Message-Id: <1199993365.19760.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-10 at 13:40 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > @@ -148,11 +148,7 @@ static void write_debugctlmsr(struct task_struct *child, unsigned long val)
> >  	if (child != current)
> >  		return;
> >  
> > -#ifdef CONFIG_X86_64
> > -	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
> > -#else
> >  	wrmsr(MSR_IA32_DEBUGCTLMSR, val, 0);
> > -#endif
> 
> doesnt this break 64-bit? 'val' is 64-bit, but wrmsr truncates it to 
> 32-bit? [while wrmsrl() kept the full 64 bits]
> 

I wasn't totally sure about this, but believe in this case that it is
OK.  If not, we'll have to add this #ifdef back to restore_btf() in
kprobes.c which was lost Masami's unification.

But looking at how this is called, there shouldn't ever be anything in
the high 32 bits being written to (32 bit always wrote zero anyway).
In any event, it's going to be safer to use wrsmrl instead as you'll
get the zero extension on 32 bit and won't effect 64 bit.

Patch to follow.

Harvey

