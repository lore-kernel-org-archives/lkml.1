Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbXLIJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbXLIJSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 04:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXLIJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 04:18:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:42069 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXLIJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 04:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SYnjZj1iOysoC4o80DwD8WBv33WeZyxbWw/lgtS1ZoQw7V7CF6iRGLAB8oxy1eSI99fqVYIUz3APQiEdU66Ekbl2rr8jeDVT4uaXgM+xsRly2cU32/4RWAfyyMJNoAgb8RMX5HcTG6QROoexW8XVwOidLCO289d/c96ThQgMaSU=
Message-ID: <84144f020712090118w27225592w8933ee2314db7556@mail.gmail.com>
Date: Sun, 9 Dec 2007 11:18:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20071209085030.GA14264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080340.49546.rjw@sisk.pl> <20071208163749.GI19691@waste.org>
	 <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
	 <20071208100950.a3547868.akpm@linux-foundation.org>
	 <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
	 <20071208195211.GA3727@elte.hu> <20071208202930.GA17934@elte.hu>
	 <84144f020712090020o5bdeb54fqaa9e6578bd066f29@mail.gmail.com>
	 <20071209085030.GA14264@elte.hu>
X-Google-Sender-Auth: 5f38d12d9285cf24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Dec 9, 2007 10:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
> yes, i understand the initial announcement (and the Kconfig entry still
> says the same), but that is not matched up by the reality i see in the
> actual code - SLUB clearly uses a queue/list of objects (as cited in my
> previous mail), for obvious performance reasons.
>
> unless i'm missing something obvious (and i easily might), i see SLUB as
> SLAB reimplemented with a different queueing model. Not "without
> queueing".

Sure, the emphasis is on "no *such* queues."

On Dec 9, 2007 10:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
> i'm curious about the real facts behind this "alien cache problem". I
> heard about it and asked around and was told that there's some sort of
> bad quadratic behavior of memory consumption on NUMA - but i cannot
> actually see that in the code.

I mostly live in the legacy 32-bit UMA/UP land still so I cannot verify this
myself but the kind folks at SGI claim the following (again from the
announcement):

"On our systems with 1k nodes / processors we have several gigabytes
 just tied up for storing references to objects for those queues  This does
 not include the objects that could be on those queues. One fears that the
 whole memory of the machine could one day be consumed by those
 queues."

The problem is that for each cache, you have an "per-node alien queues"
for each node (see struct kmem_cache nodelists -> struct kmem_list3 alien).
Moving slab metadata to struct page solves this but now you can only have
one "queue" thats part of the same struct.

                        Pekka
