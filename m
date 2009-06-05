Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZFEGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZFEGYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFEGYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:24:14 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:33593 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZFEGYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gbD+IH0aDDPgQYGGuhm1DmONUt6Htcb7/QdlbVJketSURd5aLE4sksvsoOYiFSjXXb
         kKTF6rweDTPEPe4XI0iu/W+BTKHlaYZzILijzD7ww4gd4GrNCnGKplAq6NZyrqrDa6YS
         ngj1O25lzDYjLf0P6F5p+8/9luydMl1MBcn7g=
Date: Fri, 5 Jun 2009 14:26:19 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       andreas.herrmann3@amd.com, mingo@elte.hu
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-ID: <20090605062619.GA8171@cr0.nay.redhat.com>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp> <20090605023835.GA7933@cr0.nay.redhat.com> <20090604201733.746928c6.akpm@linux-foundation.org> <200906050339.n553d684048041@www262.sakura.ne.jp> <20090604205103.bbfe9af2.akpm@linux-foundation.org> <200906050400.n5540Sx0052981@www262.sakura.ne.jp> <20090604212018.b9e9f354.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604212018.b9e9f354.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 09:20:18PM -0700, Andrew Morton wrote:
>On Fri, 05 Jun 2009 13:00:28 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
>
>> > Perhaps it's this:
>> > 
>> > static void __init memtest(u64 pattern, u64 start_phys, u64 size)
>> > {
>> > 	u64 i, count;
>> > 	u64 *start;
>> > 	u64 start_bad, last_bad;
>> > 	u64 start_phys_aligned;
>> > 	size_t incr;
>> > 
>> > 	incr = sizeof(pattern);
>> > 	start_phys_aligned = ALIGN(start_phys, incr);
>> > 	count = (size - (start_phys_aligned - start_phys))/incr;
>> Bingo!
>
>OK, thanks.  We should fix this for 2.6.30.
>
>We could do the obvious:

Excellent!


>
>--- a/arch/x86/mm/memtest.c~a
>+++ a/arch/x86/mm/memtest.c
>@@ -8,6 +8,7 @@
> #include <linux/pfn.h>
> 
> #include <asm/e820.h>
>+#include <asm/div64.h>
> 
> static u64 patterns[] __initdata = {
> 	0,
>@@ -48,7 +49,8 @@ static void __init memtest(u64 pattern, 
> 
> 	incr = sizeof(pattern);
> 	start_phys_aligned = ALIGN(start_phys, incr);
>-	count = (size - (start_phys_aligned - start_phys))/incr;
>+	count = size - (start_phys_aligned - start_phys);
>+	do_div(count, incr);
> 	start = __va(start_phys_aligned);
> 	start_bad = 0;
> 	last_bad = 0;

This patch looks fine for me. :)


>_
>
>but I wonder why all those things are u64.  They all hold virtual
>addresses, don't they?  The code doesn't test highmem.  So shouldn't
>these all be unsigned longs?
>
>

It looks like no, since many other functions also use u64 instead
of unsigned long, e.g. find_e820_area_size().

Thanks.
