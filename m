Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZLISzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZLISzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZLISzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:55:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbZLISzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:55:12 -0500
Message-ID: <4B1FF27E.8030701@zytor.com>
Date: Wed, 09 Dec 2009 10:54:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org> <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 10:47 AM, Linus Torvalds wrote:
> 
> NOTE NOTE NOTE! Totally untested. Is the second argument even in %edx? I 
> don't remember, I didn't check, I'm just throwing this out as a "hey, 
> maybe something _like_ this can work" patch, and will be immediately 
> removing it from my machine after sending this email.
> 

The second argument is in %edx, but unlike 64 bits, it is not loaded
into that register a priory ("asmlinkage" means arguments are on the stack.)

As such, we need something looking like:

#define PTREGSCALL0(name)	\
ptregs_##name:			\
	leal	4(%esp),%eax;	\
	jmp sys_##name

#define PTREGSCALL1(name)	\
ptregs_##name:			\
	movl	4(%esp),%eax;	\
	leal	4(%esp),%edx;	\
	jmp sys_##name

#define PTREGSCALL2(name)	\
ptregs_##name:			\
	movl	4(%esp),%eax;	\
	movl	8(%esp),%edx;	\
	leal	4(%esp),%ecx;	\
	jmp sys_##name

If we need more than two arguments + pt_regs, then we have to set up a
temporary stack frame.

[Sorry, I'm sitting in a meeting so I can't actually write up a real patch]

	-hpa
