Return-Path: <linux-kernel-owner+w=401wt.eu-S966052AbXDKBr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052AbXDKBr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966056AbXDKBr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:47:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966052AbXDKBrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:47:55 -0400
Date: Tue, 10 Apr 2007 18:47:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mathieu.desnoyers@polymtl.ca, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       heiko.carstens@de.ibm.com
Subject: Re: link error : 2.6.21-rc6-mm1 for s390
Message-Id: <20070410184738.dc1c5943.akpm@linux-foundation.org>
In-Reply-To: <20070410.183629.57444787.davem@davemloft.net>
References: <20070411005616.GG15262@Krystal>
	<20070410182937.8169c672.akpm@linux-foundation.org>
	<20070410.183629.57444787.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 18:36:29 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 10 Apr 2007 18:29:37 -0700
> 
> > git-net.patch implements generic lib/div64.c, but s390 also has a
> > private one.  Presumably the appropriate fix is to remove s390's
> > private implementation within davem's tree.
> 
> The s390 version seems to be optimized in assembler for that
> processor, therefore we should probably instead elide the
> generic version on s390.

We're sure that it has the same API?

> How about something like this?
> 
> diff --git a/include/asm-s390/div64.h b/include/asm-s390/div64.h
> index 6cd978c..21aea15 100644
> --- a/include/asm-s390/div64.h
> +++ b/include/asm-s390/div64.h
> @@ -1 +1,2 @@
>  #include <asm-generic/div64.h>
> +#define HAVE_ARCH_DIV64_32
> diff --git a/lib/div64.c b/lib/div64.c
> index 74f0c8c..5b480fa 100644
> --- a/lib/div64.c
> +++ b/lib/div64.c
> @@ -23,6 +23,8 @@
>  /* Not needed on 64bit architectures */
>  #if BITS_PER_LONG == 32
>  
> +#ifndef HAVE_ARCH_DIV64_32
> +
>  uint32_t __div64_32(uint64_t *n, uint32_t base)
>  {
>  	uint64_t rem = *n;
> @@ -58,6 +60,8 @@ uint32_t __div64_32(uint64_t *n, uint32_t base)
>  
>  EXPORT_SYMBOL(__div64_32);
>  
> +#endif /* !(HAVE_ARCH_DIV64_32) */
> +
>  /* 64bit divisor, dividend and result. dynamic precision */
>  uint64_t div64_64(uint64_t dividend, uint64_t divisor)
>  {

attribute(weak) would give a nicer result?

We'd also need to remove s390's EXPORT_SYMBOL(__div64_32), so s390 ends up
using lib/div64.c's EXPORT_SYMBOL().

