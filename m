Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYDBWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYDBWx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbYDBWxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:53:16 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:52182 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbYDBWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:53:16 -0400
Date: Thu, 3 Apr 2008 00:53:14 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <alpine.LFD.1.00.0804021505160.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804030050290.15850@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
 <20080402150158.f366370f.akpm@linux-foundation.org>
 <alpine.LFD.1.00.0804021505160.14670@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Linus Torvalds wrote:

> 
> 
> On Wed, 2 Apr 2008, Andrew Morton wrote:
> > 
> > But then the test-and-set of an already-set flag would newly cause the
> > cacheline to be dirtied, requiring additional bus usage to write it back?
> > 
> > The CPU's test-and-set-bit operation could of course optimise that away in
> > this case.  But does it?
> 
> No, afaik no current x86 uarch will optimize away the write on a locked 
> instuction if it turns out to be unnecessary. 

No, it doesn't. Try this:

#include <string.h>
#include <pthread.h>
void *pth(void *p)
{
        int i;
        for (i = 0; i < 100000000; i++)
                __asm__ volatile ("lock;btsl $0, %0"::"m"(*(int 
*)p):"cc");
        return NULL;
}
int args[2000];
int main(void)
{
        pthread_t t1, t2, t3, t4;
        memset(args, -1, sizeof args);
        pthread_create(&t1, NULL, pth, &args[0]);
        pthread_create(&t2, NULL, pth, &args[16]);
        pthread_create(&t3, NULL, pth, &args[32]);
        pthread_create(&t4, NULL, pth, &args[48]);
        pthread_join(t1, NULL);
        pthread_join(t2, NULL);
        pthread_join(t3, NULL);
        pthread_join(t4, NULL);
        return 0;
}

--- when the &args[] indices are in a conflicting cacheline, I get 9 times 
slower execution. I tried it on 2 double-core Core 2 Xeons.

Mikulas

> Can somebody find a timing reason to have the ugly code?
> 
> 		Linus
> 
