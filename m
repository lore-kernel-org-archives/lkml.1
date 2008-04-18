Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYDRIy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYDRIy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYDRIyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:54:47 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:44439 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbYDRIyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=esRUtcC/+qKCF9hf5BRhctoNRfqPdeyFZ7k8lIChN/BaJqlSe8cgCtADzYtYJCJ2bjUmjVSEL4TI2fk/D9hZGhQcJ93jquutTZuj4FCSQUIuMfMUj2opHOjZ3oBfkGeQMlkCxYV5gomsd6lydeYBDim5e7t697cxVk9G9SNTRNU=
Message-ID: <a72f6a3c0804180154x28d0b528gc1cbd3d11279c4a1@mail.gmail.com>
Date: Fri, 18 Apr 2008 09:54:45 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: gettimeofday() in 2.6.24
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48079356.2090307@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804171031qbba17d6pb470119d5f2ff010@mail.gmail.com>
	 <48079356.2090307@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 7:13 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> Jack Harvard wrote:
>
>
> > http://lxr.linux.no/linux+v2.6.24/arch/arm/kernel/time.c#L240
> >  239#ifndef CONFIG_GENERIC_TIME
> >  240void do_gettimeofday(struct timeval *tv)
> >  241{
> >  242        unsigned long flags;
> >  243        unsigned long seq;
> >  244        unsigned long usec, sec;
> >  245
> >  246        do {
> >  247                seq = read_seqbegin_irqsave(&xtime_lock, flags);
> >  248                usec = system_timer->offset();
> >  249                sec = xtime.tv_sec;
> >  250                usec += xtime.tv_nsec / 1000;
> >  251        } while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
> >
>
>
>
> > but I haven't quite figured out how gettimeofday() actually gets time
> > from this added timer, also how xtime is updated?
> >
>
>
>  system_timer->offset() uses the added timer to return the number of usecs
> since the last timer tick.  It's potentially different for each specific
> type of arm blade, and the function often has "gettimeoffset" in the name.

>
>  "xtime" is updated in the core kernel code.

is "xtime" updated by the time tick clock timer, i.e., the timer which
generates interrupts every 1/HZ second to the kernel. Put it in
another way,
does gettimeofday get time in two parts 1) seconds from xtime.tv_sec,
updated by timer0, 2) microseconds from xtime.tv_nsec +
system_timer->offset(), updated by timer0 and timer3.

Do you mean the code here
"http://lxr.linux.no/linux+v2.6.24/kernel/time/timekeeping.c#L45"
