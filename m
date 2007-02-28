Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXB1VJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXB1VJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXB1VJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:09:50 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4873 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXB1VJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:09:49 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 13:09:47 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070228202156.GA15846@elte.hu>
Message-ID: <Pine.LNX.4.64.0702281259430.6806@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <20070228202156.GA15846@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > My point is, the syslet infrastructure is expensive for the kernel in 
> > terms of compat, [...]
> 
> it is not. Today i've implemented 64-bit syslets on x86_64 and 
> 32-bit-on-64-bit compat syslets. Both the 64-bit and the 32-bit syslet 
> (and threadlet) binaries work just fine on a 64-bit kernel, and they 
> share 99% of the infrastructure. There's only a single #ifdef 
> CONFIG_COMPAT in kernel/async.c:
> 
> #ifdef CONFIG_COMPAT
> 
> asmlinkage struct syslet_uatom __user *
> compat_sys_async_exec(struct syslet_uatom __user *uatom,
>                       struct async_head_user __user *ahu)
> {
>         return __sys_async_exec(uatom, ahu, &compat_sys_call_table,
>                                 compat_NR_syscalls);
> }
> 
> #endif

Did you hide all the complexity of the userspace atom decoding inside 
another function? :)
How much code would go away, in case we pick a simple/parallel 
sys_async_exec engine? Atoms decoding, special userspace variable access 
for loops, jumps/cond/... VM engine.



> Even mixed-mode syslets should work (although i havent specifically 
> tested them), where the head switches between 64-bit and 32-bit mode and 
> submits syslets from both 64-bit and from 32-bit mode, and at the same 
> time there might be both 64-bit and 32-bit syslets 'in flight'.
> 
> But i'm happy to change the syslet API in any sane way, and did so based 
> on feedback from Jens who is actually using them.

Wouldn't you agree on a simple/parallel execution engine like me and Linus 
are proposing (and threadlets, of course)?



- Davide


