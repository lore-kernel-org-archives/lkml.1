Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXLIIUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXLIIUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 03:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXLIIUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 03:20:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:49080 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXLIIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 03:20:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=R1iqbPmOJUULBADxP0+JHJJYSFF9b42zPgnK/hOQzgABcOD69Kyue+2PUaVwoFpVyCTXb/EyfREImNDMVlVTcGhAFInQnN3+fmfjUGn7+Fd1ramamLKj0Gg5Z3BF35b/DmyAB7rR/8oP1vMtwTDL41uixIpQiCB+PRcqHU14Fbs=
Message-ID: <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
Date: Sun, 9 Dec 2007 10:20:19 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20071208202930.GA17934@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
	 <20071208163749.GI19691@waste.org>
	 <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
	 <20071208100950.a3547868.akpm@linux-foundation.org>
	 <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
	 <20071208195211.GA3727@elte.hu> <20071208202930.GA17934@elte.hu>
X-Google-Sender-Auth: a2461580aefa0f80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Dec 8, 2007 10:29 PM, Ingo Molnar <mingo@elte.hu> wrote:
> so it has a "free list", which is clearly per cpu. Hang on! Isnt that
> actually a per CPU queue? Which SLUB has not, we are told? The "U" in
> SLUB. How on earth can an allocator in 2007 claim to have no queuing
> (which is in essence caching)? Am i on crack with this? Did i miss
> something really obvious?

I think you did. The difference is explained in Christoph's announcement:

"A particular concern was the complex management of the numerous
object queues in SLAB. SLUB has no such queues. Instead we dedicate a
slab for each allocating CPU and use objects from a slab directly
instead of queueing them up."

Which, I think, is where SLUB gets its name from (the "unqueued" part).

Now, while SLAB code is "pleasant and straightforward code" (thanks,
btw) for UMA, it's really hairy for NUMA plus the "alien caches" eat
tons of memory (which is why Christoph wrote SLUB in the first place,
the current code in SLAB is mostly unfixable due to its *queuing*
nature).

I don't object changing the default to CONFIG_SLAB but it's not really
a long term strategy unless we want to have three kmalloc's in the
kernel: one for embedded, one for UMA, and one NUMA.

                        Pekka
