Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbZFNA0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbZFNA0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbZFNA0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:26:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:25145 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbZFNA0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=leUFmwuzFQgB0t0rS5ixw06rkrodDuHEDPm8RcsySEeseukArtshGKh1SqEDOSo2sz
         WhjceAquwHmR4m/Z4uehIqD5mLwzDbeR5/IjUl5SKZBmLUJh8AndJp9M4TiTwK9dKC3C
         l7VUBA4QiJl9MEJ5waVAvHAyww62wPh7m0yxc=
MIME-Version: 1.0
In-Reply-To: <200906132318.19208.arnd@arndb.de>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> 
	<1244903447-23579-2-git-send-email-vapier@gentoo.org> <4A33E892.6010704@zytor.com> 
	<200906132318.19208.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 20:25:53 -0400
Message-ID: <8bd0f97a0906131725l214007fcpfa90e72b03cad2ac@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: hard_irqs: handle NR_IRQS > 256 
	automatically
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 17:18, Arnd Bergmann wrote:
> On Saturday 13 June 2009, H. Peter Anvin wrote:
>> Mike Frysinger wrote:
>> > If we're going to automatically set HARDIRQ_BITS for the arch, might as
>> > well be a little bit smart about it and set it to 9 automatically if
>> > NR_IRQS is larger than 8 bits.
>> >
>>
>> Why would the only possible values be 8 or 9?
>
> All architectures that define this either set it to 8 or 9, I chose
> 8 because it is the more common constant

right, i was going by what was in use -- there are no requirements
here, just defaults

> but I now realized that
> we also have (in include/linux/hardirq.h, last touched by Steven):
>
> #define MAX_HARDIRQ_BITS 10
> #ifndef HARDIRQ_BITS
> # define HARDIRQ_BITS   MAX_HARDIRQ_BITS
> #endif
> #if HARDIRQ_BITS > MAX_HARDIRQ_BITS
> #error HARDIRQ_BITS too high!
> #endif
>
> Not sure why we even need to make this overridable from the architecture,
> 10 still seems like a reasonable default that should always work.
>
> I'd suggest we either drop the definition for HARDIRQ_BITS from
> asm-generic/hardirq.h, or we use
>
>  #ifndef HARDIRQ_BITS
> -#define HARDIRQ_BITS   8
> +# if NR_IRQS > 255
> +#  define HARDIRQ_BITS 9
> +# elif NR_IRQS > 511
> +#  define HARDIRQ_BITS 10
> +# elif NR_IRQS > 1023
> +#  warning too many interrupts for HARDIRQ_BITS
> +# endif
>  #endif

is there any downsides to using a "too large" value ?  i.e. if my
system has less than 256, does it make any difference at all if it's
set to 10 ?
-mike
