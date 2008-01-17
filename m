Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYAQX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYAQX0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYAQX0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:26:31 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:40991 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbYAQX0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=liK48xBgKyhFcdZodhoca5aUmQ9rYOq6twa+r9Css7f6Erizv4IOus52S1U3wtOIkZEogZ8ckct0VOuf5dFuZcJfIiSiuTdi6QVgYwDb9U9Zz2sLNazSauFTdF+L2nOSNqGIGqJMtnv6rJw042ndJYhHsvppMtO2sj/xPOeJ3KM=
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <478FDE76.3070309@zytor.com>
References: <1200611078.5724.46.camel@brick>  <478FDE76.3070309@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:26:29 -0800
Message-Id: <1200612389.5724.63.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-17 at 18:02 -0500, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > Use v8086_mode inline in fault_32.c, no functional change
> > also ifdef the section for 32-bit only and add to fault_64.c
> 
> The #ifdef is unnecessary, since v8086_mode() is now a constant zero on 
> x86-64.  gcc will remove the if clause.
> 

Sorry, missed that detail in ptrace.h, I notice now.

Is there some better way this could be organized, would the following
be an improvement, as opposed to two long ifdef sections?

Patch will follow if you think it's a good idea.

static inline int user_mode(struct pt_regs *regs)
{
#ifdef CONFIG_X86_32
	return (regs->cs & SEGMENT_RPL_MASK) == USER_RPL;
#else
	return !!(regs->cs & 3);
#endif
}

static inline int user_mode_vm(struct pt_regs *regs)
{
#ifdef CONFIG_X86_32
	return ((regs->cs & SEGMENT_RPL_MASK) |
		(regs->flags & VM_MASK)) >= USER_RPL;
#else
	return user_mode(regs);
#endif
}

static inline int v8086_mode(struct pt_regs *regs)
{
#ifdef CONFIG_X86_32
	return (regs->flags & VM_MASK);
#else
	return 0;
#endif
}

/* OK, maybe this should just be deleted, and use
regs->ip directly in code*/
static inline unsigned long instruction_pointer(struct pt_regs *regs)
{
	return regs->ip;
}

/* OK, maybe this should just be deleted, and use
regs->bp directly in code*/
static inline unsigned long frame_pointer(struct pt_regs *regs)
{
	return regs->bp;
}

static inline unsigned long stack_pointer(struct pt_regs *regs)
{
#ifdef CONFIG_X86_32
	return (unsigned long)regs;
#else
	return regs->sp;
#endif
}

/* still need a define here, as one is long and one is unsigned long.
 * but this is another target for unification I guess. */
#define regs_return_value(regs) ((regs)->ax)

Harvey

