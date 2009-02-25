Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbZBYG2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbZBYG2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbZBYG2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:28:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZBYG2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:28:15 -0500
Message-ID: <49A4E425.5030204@zytor.com>
Date: Tue, 24 Feb 2009 22:24:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: mingo@redhat.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] headers_check cleanups break the whole world
References: <20090225032553.GD6690@bombadil.infradead.org>
In-Reply-To: <20090225032553.GD6690@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> 
> The reason for this is you cannot intermix glibc header <sys/*.h>
> includes with <linux/*.h> includes for most things without defining the
> __KERNEL_STRICT_NAMES guard. If you fail to define this, you end up
> with multiple definitions of things like dev_t.
> 
> Software was able to get by, because things that used the headers, dvb for
> example were not getting <linux/types.h> into the include chain, because
> they were using <asm/types.h> directly.
> 
> I propose we invert that logic, so the presumable libc that makes use of
> the <linux/types.h> header can just define that it wants these types.
> (test __KERNEL__ as well so the kernel doesn't need a pointless
> #define.)
> 

The Right Thing[TM] here is to change the exported headers so that
*only* the __kernel* names are exported, and then remove the
non-__KERNEL_STRICT_NAMES version of <linux/types.h>.  The *only* libc
for which non-__KERNEL_STRICT_NAMES ever made sense was for the
long-since-obsolete libc5.

This, by the way, is not frivolous work.  The work that has been done in
this area already has smoked out a number of bugs where exported headers
were using user space types, which meant they were using the *WRONG
TYPES* on glibc.  Completely.

> If this isn't tenable, how about moving the {,__}[su]{8,16,32,64}
> integer types into their own header, so we can avoid this mess ever
> occuring in the future. I'm sure the janitors can have a field day with
> that... :)
> 
> That said, who exactly is the userspace consumer for those
> 	typedef __kernel_dev_t	dev_t;
> defines? Can we just include them all in #ifdef __KERNEL__? 

That is exactly what we should do.

For what it's worth, not even klibc uses these types.

	-hpa	

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

