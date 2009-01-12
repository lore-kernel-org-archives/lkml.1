Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZALWDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZALWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZALWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:02:54 -0500
Received: from mail-gx0-f12.google.com ([209.85.217.12]:59314 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZALWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dAmZnFRdrVQQ7ik3L4oS3UuGOpDrVbS8Z1QbA4lIEyYnkHbfQ+mHGMNwqNJYi1mJG7
         J7nHEh5UMYExcUZ3cyDTWfhO997ZP9GoWxnr3+grrzVdK2WQ1DF+i7oCuyEBl0FYa/jb
         A/ZOwbuzahJOUN4Epfe3Mmc2MbUZWf6fch/TA=
Message-ID: <b3ece790901121402k4e84f8e7k7993b5fda90456cb@mail.gmail.com>
Date: Mon, 12 Jan 2009 14:02:51 -0800
From: "Tim Hockin" <thockin@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Cc: "Andi Kleen" <ak@linux.intel.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       priyankag@google.com, "Aaron Durbin" <adurbin@gmail.com>,
       "Duncan Laurie" <dlaurie@google.com>
In-Reply-To: <20081227155019.GA15493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081227155019.GA15493@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 7:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> We really need to get rid of /dev/mcelog. It's a quirky binary logging
> facility not available on 32-bit on current kernels and it has a couple of
> limitations:

It's not quirky, it's structured.  Until and unless there is a better,
structured interface, this needs to stay.

>  - it squeezes all MCE errors from the whole system into a small,
>    32-entry ringbuffer.

Yes 32 is small, but not really a big problem in practice.  The MCE daemon
(http://mcedaemon.googlecode.com) goes a long way towards making this
a non-issue.  Every distro should ship mced.

>  - it puts all the MCE logging info into an intermediary binary log
>    record format: 'struct mce' - just for userspace to in essence
>    printf out those entries with minimal post-processing. The fact that
>    we squeeze all information into a fixed-size binary record makes it
>    hard to extend and complicates the code needlessly.

This is not true, we do EXTENSIVE post-processing of MCEs.  Yes it is hard
to extend, but that's not the same as saying it is useless.

>  - these design aspects are also quite harmful to usability: by
>    default all MCEs are fatal currently (pre-Nehalem anyway), so
>    /dev/mcelog will only be used if a user goes out on a limb to
>    configure it and sets the tolerant flag.

Not true.  The vast vast vast majority of MCEs are corrected, as per our
experience, and I suspect we've got more experience with MCEs than just
about any other consumer.

> A far more useful design for handling MCE events would be to feed them
> into printk logging. So instead of printing such rather cryptic error
> messages:
>
>   MCE 0
>   HARDWARE ERROR. This is *NOT* a software problem!
>   Please contact your hardware vendor
>   CPU 0 BANK 6 MISC 202d ADDR ffeef740
>   This is not a software problem!
>   Run through mcelog --ascii to decode and contact your hardware vendor
>
> and expecting people to run mcelog, we should print plain-text something
> like:
>
>   MCE 0
>   HARDWARE ERROR. This is *NOT* a software problem!
>   Please contact your hardware vendor
>   CPU 1 4 northbridge TSC 89a560bb249
>   ADDR 1dfa49690
>     Northbridge Chipkill ECC error
>     Chipkill ECC syndrome = 2021
>          bit46 = corrected ecc error
>     bus error 'local node response, request didn't time out
>         generic read mem transaction
>         memory access, level generic'
>   STATUS 9410c00020080a13 MCGSTATUS 0

NO!  This moves in the completely wrong direction.  This output is just
about impossible to parse sanely.  And don't get me started about how much
of a pain it is to encode all of the vendor-centric and per-platform
specifics so that it decodes all the useful bits.

I promise you that there are things that are useful to us that the kernel
will not parse and print.

> straight from the kernel. This means that the MCEs will make a lot more
> sense at a glance - and the user can figure out the suspected trouble
> area, without having to find some other box to run mcelog on, etc. We can
> eliminate the user-space mcelog utility/daemon component altogether - it
> buys us little but needless complexity and inflexibility.

I disagree totally.  Putting the logic for decoding MCEs into the kernel
adds a large amount of complex, hard to maintain code precisely where it
is most destructive.  Any sort of decoding of this data in-kernel is
probably a mistake (yes, I am looking at you EDAC).

It would be much cleaner to instead make the kernel really good at
publishing errors and let userspace decode them.  A naive end user won't
know the difference - they will see a message on the syslog or the
console.  Power users will be able to do better things.

> If we want to enable userspace to capture MCE events, then it must be done
> in a way that benefits the whole kernel, not just x86: a structured
> logging facility that is in essence a printk variant and is ASCII driven.

I would be fine with this (though I disagree that it *must* be ASCII).  I
don't care how the raw data comes out of the kernel, just that it is the
raw data, not some half-assedly parsed data.

> Such event sources should be discoverable, and only 'aware' printouts
> should go into this new facility (not all printks). Demultiplexing should
> be easy and well-defined.

I agree 1000% with this - it is something I have wanted for a long time,
and that some of my team are starting to look at again.

> I.e. we could use this opportunity of the MCE code unification to bring
> the code to the next level - and not prolongue to broken concepts of the
> past.

Don't dicard the past until the present can stand on it's own.  Please.

> I'd be glad to help out with any portion of this, it should be easy to
> solve and it will clearly improve the code. For .29 we could just do a raw
> printk based approach with no decoding just yet, and layer smart decoding
> and structured logging for .30.

Please leave /dev/mcelog as a CONFIG option until such time as an
appropriate replacement is *done*.  We rely on it.

Tim
