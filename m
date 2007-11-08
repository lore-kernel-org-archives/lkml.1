Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbXKHT1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbXKHT1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXKHT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:27:27 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:19466 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbXKHT10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uVBTwkjhdivzEbjmM6hILt+y/sIc19hLO3bpv8o6F6BWfMMcHzPXk5giuCcR+VcdHG/TDaRlz1H4MUGaGTIya22dmZCK7UOUoYsX0pfF+M3zIzQWBJI+pUs4rbbBhwHPkcGYf7QTTxHuxtaIgK1BDWgtLbvhpST9mtuJiKKwIws=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Date: Thu, 8 Nov 2007 19:27:19 +0000
User-Agent: KMail/1.9.1
Cc: Paul Mackerras <paulus@samba.org>, lkml@davidb.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com, mtk-manpages@gmx.net
References: <20071107224722.GA20204@old.davidb.org> <18226.27701.782268.375231@cargo.ozlabs.ibm.com> <20071107190714.9c404e28.akpm@linux-foundation.org>
In-Reply-To: <20071107190714.9c404e28.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081927.19394.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 03:07, Andrew Morton wrote:
> > On Thu, 8 Nov 2007 12:53:57 +1100 Paul Mackerras <paulus@samba.org> wrote:
> > Andrew Morton writes:
> > 
> > > Given all this stuff, the return value from sys_times() doesn't seem a
> > > particularly useful or reliable kernel interface.
> > 
> > I think the best thing would be to ignore any error from copy_to_user
> > and always return the number of clock ticks.  We should call
> > force_successful_syscall_return, and glibc on x86 should be taught not
> > to interpret negative values as an error.
> 
> Changing glibc might be hard ;)
> 
> > POSIX doesn't require us to return an EFAULT error if the buf argument
> > is bogus.  If userspace does supply a bogus buf pointer, then either
> > it will dereference it itself and get a segfault, or it won't
> > dereference it, in which case it obviously didn't care about the
> > values we tried to put there.
> > 
> > If we try to return an error under some circumstances, then there is
> > at least one 32-bit value for the number of ticks that will cause
> > confusion.  We can either change that value (or values) to some other
> > value, which seems pretty bogus, or we can just decide not to return
> > any errors.  The latter seems to me to have no significant downside
> > and to be the simplest solution to the problem.
> 
> "the latter" is what my protopatch does isn't it?  It wraps at 0x7fffffff.
> It appears that glibc treats all of 0x80000000-0xffffffff as an error.

The best solution is to change the kernel to never return an error
and to change glibc to never treat return as an error.
--
vda
