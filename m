Return-Path: <linux-kernel-owner+w=401wt.eu-S967936AbXFHDwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967936AbXFHDwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967372AbXFHDwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:52:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525AbXFHDwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:52:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=B5/XNO6ymT5U6I8LXCX2O7/T/RW01UwuXO8sdxo9w0lKhS8BQBDnN9yvoL3GN5Sbn
	W6CMLrDf3FhABLpXnYEZw==
Message-ID: <4517d1380706072050r218941b2m7eeb79700ed9edb0@mail.gmail.com>
Date: Thu, 7 Jun 2007 20:50:53 -0700
From: "Masoud Sharbiani" <masouds@google.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH] Make i386 kernel show the segfaults in kernel dmesg, like x86_64.
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4668B939.1070304@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.FB3wQKN6ltiEi81XcB14YVcLGgE@ifi.uio.no>
	 <4668B939.1070304@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Masoud Asgharifard Sharbiani wrote:
> > Hello,
> > This patch makes the i386 behave the same way that x86_64 does when a
> > segfault happens. A line gets printed to the kernel log so that tools
> > that need to check for failures can behave more uniformly between
> > different kernels. Like x86_64, it can be disabled by setting
> > debug.exception-trace sysctl variable to 0 (or by doing
> > echo 0 > /proc/sys/debug/exception-trace)
> >
> > Same behaviour can be extended to other architectures, if needed.
> > cheers,
> > Masoud.
> >
> > Signed-off-by: Masoud Sharbiani <masouds@google.com>
> >
> > diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
> > index 29d7d61..6aa56db 100644
> > --- a/arch/i386/mm/fault.c
> > +++ b/arch/i386/mm/fault.c
> > @@ -283,6 +283,8 @@ static inline int vmalloc_fault(unsigned long address)
> >       return 0;
> >  }
> >
> > +int exception_trace = 1;
> > +
> >  /*
> >   * This routine handles page faults.  It determines the address,
> >   * and the problem, and then passes it off to one of the appropriate
> > @@ -464,7 +466,14 @@ bad_area_nosemaphore:
> >                */
> >               if (is_prefetch(regs, address, error_code))
> >                       return;
> > -
> > +             if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
> > +                     printk(
> > +                    "%s%s[%d]: segfault at %08lx eip %08lx esp %08lx error %lx\n",
> > +                                     tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
> > +                                     tsk->comm, tsk->pid, address, regs->eip,
> > +                                     regs->esp, error_code);
>
> Shouldn't we use printk_ratelimit() here, to prevent some nasty person
> from creating some rapidly-segfaulting process that floods the kernel
> logs? (Same with the x86_64 version if it doesn't already..)

Good call.

Masoud

> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
>
