Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbYEUKtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbYEUKtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYEUKtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:49:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbYEUKtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:49:10 -0400
Subject: Re: [PATCH] consolidate all within() implementations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <OFC011E4F1.61EF5440-ONC1257450.0038CB52-C1257450.003A0375@de.ibm.com>
References: <OFC011E4F1.61EF5440-ONC1257450.0038CB52-C1257450.003A0375@de.ibm.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 12:48:52 +0200
Message-Id: <1211366932.6463.81.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 12:33 +0200, Peter 1 Oberparleiter wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote on 21.05.2008 12:04:26:
> > > +static inline int addr_within_len(const void *addr, const void 
> *start,
> > > +              size_t len)
> > > +{
> > > +   return ((unsigned long) addr >= (unsigned long) start) &&
> > > +          ((unsigned long) addr < ((unsigned long) start + len));
> > > +}
> > 
> > might be my braindamage, but I'd have written it like:
> > 
> > static inline int 
> > addr_within_len(const void *addr, const void *start, size_t len)
> > {
> >    return (unsigned long)addr - (unsigned long)start < len;
> > }
> 
> Definitely another way to put it. In my opinion the intention of the
> implementation is more easily understood though when spelling it out
> as (a>=b) && (a<c).

peter@lappy:~/tmp$ cat cmp.c

int within_len1(const void *addr, const void *start, unsigned long len)
{
        return (unsigned long)addr - (unsigned long)start < len;
}

int within1(const void *addr, const void *start, const void *end)
{
        return within_len1(addr, start,
                        (unsigned long)end - (unsigned long)start);
}
peter@lappy:~/tmp$ cat cmp2.c
int within_len2(const void *addr, const void *start, unsigned long len)
{
        return ((unsigned long) addr >= (unsigned long) start) &&
                ((unsigned long) addr < ((unsigned long) start + len));
}

int within2(const void *addr, const void *start, const void *end)
{
        return ((unsigned long) addr >= (unsigned long) start) &&
                ((unsigned long) addr < ((unsigned long) end));
}
peter@lappy:~/tmp$ gcc -S -Os cmp*.c
peter@lappy:~/tmp$ ls -la cmp*.o
-rw-r--r-- 1 peter peter 752 2008-05-21 12:43 cmp2.o
-rw-r--r-- 1 peter peter 743 2008-05-21 12:43 cmp.o


Also look at the .s output and notice mine doesn't have any additional
branches ;-)

> > static inline int
> > addr_within(const void *add, const void *start, const void *end)
> > {
> >    return addr_within_len(addr, start, 
> >          (unsigned long)end - (unsigned long)start);
> > }
> 
> For empty ranges (start > end), this produces different (less expected)
> results than the previous version.

agreed, do we care about those?

