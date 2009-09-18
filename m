Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZIRUG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZIRUG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZIRUGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:06:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbZIRUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:06:22 -0400
Subject: Re: perf_copy_attr pointer arithmetic weirdness
From: Peter Zijlstra <peterz@infradead.org>
To: Ian Schram <ischram@telenet.be>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xiaoguangrong@cn.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4AB3DEE2.3030600@telenet.be>
References: <4AB3DEE2.3030600@telenet.be>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 21:57:48 +0200
Message-Id: <1253303868.10538.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 21:26 +0200, Ian Schram wrote:
> There is some -to me at least- weird code in per_copy_attr. Which supposedly
> checks that all bytes trailing a struct are zero.
> 
> It doesn't seem to get pointer arithmetic right. Since it increments
> an iterating pointer by sizeof(unsigned long) rather than 1.
> 
> I believe this has an impact on the exploitability of the recent buffer overflow
> in the perf_copy_attr function. I'm pretty sure I'm not the only one who noticed
> this, but i couldn't find it being mentioned. For some reason people prefer
> mmaping something at zero these days?
> 
> I have appended a patch locating the issue. The PTR_ALIGN stuff right above it
> doesn't seem to take any boundary conditions into account which is probably not
> a good thing either.

sizeof(struct perf_counter_attr) should always be a multiple of u64, and
we can indeed read beyond the tail boundary, but that should be ok,
worst that can happen is that we fail the read..

Ugh on the ptr arith, one wonders how many stupid bugs one can make in
such a piece of code... :/

> signed-of-by Ian Schram <ischram@telenet.be>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 8cb94a5..9c7590e 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -4208,7 +4208,7 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
>  		end  = PTR_ALIGN((void __user *)uattr + size,
>  				sizeof(unsigned long));
> 
> -		for (; addr < end; addr += sizeof(unsigned long)) {
> +		for (; addr < end; ++addr) {
>  			ret = get_user(val, addr);
>  			if (ret)
>  				return ret;

