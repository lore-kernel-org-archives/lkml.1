Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbYIANGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbYIANGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYIANG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:06:29 -0400
Received: from www.tglx.de ([62.245.132.106]:57993 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYIANG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:06:28 -0400
Date: Mon, 1 Sep 2008 15:06:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <mattjfleming@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ktime_set() does not check for nanoseconds > one second
In-Reply-To: <5ff4a1e50809010457l7051b7e8vc7f86d68ae42e529@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809011501450.3243@apollo.tec.linutronix.de>
References: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>  <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de> <5ff4a1e50809010457l7051b7e8vc7f86d68ae42e529@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Matt Fleming wrote:
> > Yeah, a check for this in ktime_set() might make sense. Currently it's
> > up to the programmer to provide sane values. :)
> >
> > Thanks,
> >
> >        tglx
> >
> 
> How about the attached patch?

Won't work with arbitrary numbers. i.e. >= 2* NSEC_PER_SEC. Looking at
it, I'm even less convinced that it is a good idea.

      tglx

> Matt
> 
> diff --git a/include/linux/ktime.h b/include/linux/ktime.h
> index ce59832..7c0ad35 100644
> --- a/include/linux/ktime.h
> +++ b/include/linux/ktime.h
> @@ -150,7 +150,19 @@ static inline ktime_t timeval_to_ktime(struct timeval tv)
>  /* Set a ktime_t variable to a value in sec/nsec representation: */
>  static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
>  {
> -       return (ktime_t) { .tv = { .sec = secs, .nsec = nsecs } };
> +       ktime_t res = { .tv = { .sec = secs, .nsec = nsecs }};;
> +
> +       /*
> +        * performance trick: the (u32) -NSEC gives 0x00000000Fxxxxxxx
> +        * so we subtract NSEC_PER_SEC and add 1 to the upper 32 bit.
> +        *
> +        * it's equivalent to:
> +        *   tv.nsec -= NSEC_PER_SEC
> +        *   tv.sec ++;
> +        */
> +       if (nsecs >= NSEC_PER_SEC)
> +               res.tv64 += (u32)-NSEC_PER_SEC;
> +       return res;
>  }
> 
>  /**
> 
