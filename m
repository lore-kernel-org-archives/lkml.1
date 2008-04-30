Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbYD3SDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbYD3SDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYD3SDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:03:38 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:49985 "EHLO
	kirsi2.rokki.sonera.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754888AbYD3SDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:03:38 -0400
Date: Wed, 30 Apr 2008 21:03:35 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Improved Swapping Method In sort.c
Message-ID: <20080430180335.fcv7ft5lgbsbjmoj@m.safari.iki.fi>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <988568.21908.qm@web94102.mail.in2.yahoo.com> <alpine.LNX.1.10.0804301932160.5623@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804301932160.5623@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2008-03-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 19:33:42 +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2008-04-30 19:09, Soumyadip Das Mahapatra wrote:
> 
> >Hello everybody,
> >The swapping method (in function void u32_swap() line no.. 14 to 16) in lib/sort.c can be improved by using the following code
> >*(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a instead of the code given. This code
> >is not using third variable thus not consuming another memory. And I dont see any significance in
> >using *int size* argument. so the function should be
> >static void u32_swap(void *a, void *b)
> >{
> >    *(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a;
> >}
> 
> That proposal looks like buggy.
> 
> 19:32 yaguchi:/dev/shm > cat ui.c 
> #include <stdint.h>
> #include <stdio.h>
> 
> static void u32_swap(void *a, void *b)
> {
>         *(uint32_t *)b ^= *(uint32_t *)a 
>                         ^= *(uint32_t *)b
>                         ^= *(uint32_t *)a;
> }
> 
> int main(void)
> {
>         uint32_t x = 5, y = 7;
>         printf("%u %u\n", x, y);
>         u32_swap(&x, &y);
>         printf("%u %u\n", x, y);
> }
> 19:32 yaguchi:/dev/shm > ./a.out 
> 5 7
> 7 0

This happens because u32_swap has undefined behavior.

Try this instead:

static void u32_swap(void *a, void *b)
{
        *(uint32_t *)a ^= *(uint32_t *)b;
        *(uint32_t *)b ^= *(uint32_t *)a;
        *(uint32_t *)a ^= *(uint32_t *)b;
}

But still, this change to Linux is not necessary,
it actually generates worse code. 

-- 
Do what you love because life is too short for anything else.

