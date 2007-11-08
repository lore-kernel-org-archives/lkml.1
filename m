Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbXKHT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbXKHT0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbXKHT0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:26:03 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:18046 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbXKHT0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:26:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fVwtMASq7msViVAuaRaXoPveKD3MpuOKNkZPgD9o/ImW9yNsKPaKMpurNGXs7pNqH0H4WX5T8Y5Lxf4En7ijV33osaGBneTCZOxmr6z19w+kIHJXwGSIaHjF8SEihInhHIFO/2zLelDMgewVzGw12Qae8RtUV5KjT50OHB/b8hE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Date: Thu, 8 Nov 2007 19:25:52 +0000
User-Agent: KMail/1.9.1
Cc: paulus@samba.org, akpm@linux-foundation.org, lkml@davidb.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com, mtk-manpages@gmx.net
References: <20071107152833.6f302c2a.akpm@linux-foundation.org> <18226.27701.782268.375231@cargo.ozlabs.ibm.com> <20071107.180918.263752219.davem@davemloft.net>
In-Reply-To: <20071107.180918.263752219.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081925.52747.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 02:09, David Miller wrote:
> > I think the best thing would be to ignore any error from copy_to_user
> > and always return the number of clock ticks.  We should call
> > force_successful_syscall_return, and glibc on x86 should be taught not
> > to interpret negative values as an error.
> > 
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
> I agree with this analysis.
> 
> The Linux man page for times() explicitly lists (clock_t) -1 as a
> return value meaning error.
> 
> So even if we did make some effort to return errors "properly" (via
> force_successful_syscall_return() et al.) userspace would still be
> screwed because (clock_t) -1 would be interpreted as an error.
> 
> Actually I think this basically proves we cannot return (clock_t) -1
> ever because all existing userland (I'm not talking about inside
> glibc, I'm talking about inside of applications) will see this as an
> error.

What error? I'd argue it's perfectly sane for application to
assume that times() never fails.

        struct tms t;
        clock_t start = times(&t);
        ...
        clock_t end = times(&t);
        clock_t delta = end - start;

The only error form kernel POV is that passed pointer can be
invalid. But from application POV in the above example it
cannot be true and

        if (start == -1)
                 error("error in times!");

would be and exercise in wasting CPU cycles, producing dead code
and feeding one's paranoia.

> User applications have no other way to check for error.

And in all realistic scenarios it doesn't need to.

In this particular case, it makes sense to ignore standards and
never return an error. If user indeed passed invalid pointer,
just don't store anything there, but still return valid value.
--
vda
