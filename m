Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZBYD0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZBYD0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 22:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZBYD0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 22:26:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZBYD0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:26:06 -0500
Date: Tue, 24 Feb 2009 22:25:53 -0500
From: Kyle McMartin <kyle@infradead.org>
To: mingo@redhat.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [rfc] headers_check cleanups break the whole world
Message-ID: <20090225032553.GD6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[names omitted to protect the innocent, hpa@ on the CC wrt klibc maybe
  using these? ]

Hi,

Commits like

    headers_check fix: foo.h
    
    fix the following 'make headers_check' warnings:
      usr/include/linux/foo.h:29: include of <linux/types.h> is preferred
      usr/include/linux/foo.h:102: found __[us]{8,16,32,64} type without

have proved problematic...

I've had to point out at least two userspace fixes[1] for a variety of
reasons that these patches exacerbated. Note however that I didn't say
they were wrong.

The reason for this is you cannot intermix glibc header <sys/*.h>
includes with <linux/*.h> includes for most things without defining the
__KERNEL_STRICT_NAMES guard. If you fail to define this, you end up
with multiple definitions of things like dev_t.

Software was able to get by, because things that used the headers, dvb for
example were not getting <linux/types.h> into the include chain, because
they were using <asm/types.h> directly.

I propose we invert that logic, so the presumable libc that makes use of
the <linux/types.h> header can just define that it wants these types.
(test __KERNEL__ as well so the kernel doesn't need a pointless
#define.)

If this isn't tenable, how about moving the {,__}[su]{8,16,32,64}
integer types into their own header, so we can avoid this mess ever
occuring in the future. I'm sure the janitors can have a field day with
that... :)

That said, who exactly is the userspace consumer for those
	typedef __kernel_dev_t	dev_t;
defines? Can we just include them all in #ifdef __KERNEL__?

Thoughts?

cheers, Kyle

1. Ok, one of them was libcap playing utterly stupid games with
<linux/capability.h> and header guards, but it was exacerbated by a
similar patch...

