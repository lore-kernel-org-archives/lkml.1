Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbYLKW2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbYLKW2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYLKW16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:27:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488AbYLKW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:27:57 -0500
Date: Thu, 11 Dec 2008 14:26:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert.Uytterhoeven@sonycom.com, viro@zeniv.linux.org.uk,
       dhowells@redhat.com, miltonm@bga.com, wd@denx.de, dzu@denx.de,
       yanok@emcraft.com
Subject: Re: Re[2]: [PATCH][v2] fork_init: fix division by zero
Message-Id: <20081211142611.1790a62a.akpm@linux-foundation.org>
In-Reply-To: <483237973.20081212012232@emcraft.com>
References: <200812101950.51958.yur@emcraft.com>
	<20081211121635.ff58193f.akpm@linux-foundation.org>
	<483237973.20081212012232@emcraft.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 01:22:32 +0300
Yuri Tikhonov <yur@emcraft.com> wrote:

> > so how about avoiding the nasty ifdefs and doing
> 
>  I'm OK with the approach below, but, leading resulting to the same, 
> this involves some overhead to the code where there was no this 
> overhead before this patch: e.g. your implementation is finally boils 
> down to ~5 times more processor instructions than there were before,
> plus operations with stack for the 'm' variable.
> 
>  On the other hand, my approach with nasty (I agree) ifdefs doesn't 
> lead to overheads to the code which does not need this: i.e. the most 
> common situation of small PAGE_SIZEs. Big PAGE_SIZE is the exception, 
> so I believe that the more common cases should not suffer because of 
> this.

yes, but...

> > --- a/kernel/fork.c~fork_init-fix-division-by-zero
> > +++ a/kernel/fork.c
> > @@ -69,6 +69,7 @@
> >  #include <asm/mmu_context.h>
> >  #include <asm/cacheflush.h>
> >  #include <asm/tlbflush.h>
> > +#include <asm/div64.h>
> >  
> >  /*
> >   * Protected counters by write_lock_irq(&tasklist_lock)
> > @@ -185,10 +186,15 @@ void __init fork_init(unsigned long memp

This is __init code and it gets thrown away after bootup.
