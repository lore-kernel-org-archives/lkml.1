Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbZJGRqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbZJGRqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759696AbZJGRqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:46:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692AbZJGRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:46:32 -0400
Date: Wed, 7 Oct 2009 13:45:54 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andreas Mohr <andi@lisas.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
	to `__udivdi3' in menu governor)
Message-ID: <20091007174553.GC11702@bombadil.infradead.org>
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de> <4ACCA44B.3070706@linux.intel.com> <20091007173457.GA25415@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007173457.GA25415@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 07:34:58PM +0200, Andreas Mohr wrote:
> Nopeee.
> 
>         data->predicted_us = DIV_ROUND_CLOSEST((u32)
>                 data->expected_us * data->correction_factor[data->bucket],
>                 (u32)RESOLUTION * DECAY);
> 
> It did properly rebuild drivers/cpuidle/governors/menu.o.
> Still happening.
> IOW it must be somewhere inside the DIV_ROUND_CLOSEST macro or so.
> 

It's being a jerk and not realizing that RESOLUTION * DECAY is a power
of 2, so it can just do a shift...

I don't recall if gcc 3 had these magic builtins, but if it does,
something like this might help since it's the u64 case that's
problematic.

I probably noviced this in some trivial way, but it's a thought.
And in the most-annoying case (most of these u64 divisions are power of
2, that I've seen...) would sort things out.

regards, Kyle

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d3cd23f..4936eb6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -51,6 +51,9 @@ extern const char linux_proc_banner[];
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
 	typeof(divisor) __divisor = divisor;		\
+	if (__builtin_types_compatible_p(typeof(divisor), unsigned long long) &&	\
+		__builtin_popcountll(__divisor) == 1)			\
+		(((x) + ((__divisor) / 2) << __builtin_ffsll(__divisor)));	\
 	(((x) + ((__divisor) / 2)) / (__divisor));	\
 }							\
 )
