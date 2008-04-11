Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYDKIun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYDKIun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbYDKIuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:50:35 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:58183 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833AbYDKIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=du8poAkJ8OaGYswT6440blIrfpRXL5Jv318Ckl3ucJCvAmyL2mHZjCYfhd07otntzjN9aQ9EYS6pDuLFjk8hJ/Vek46Ia9sJdwkOCd1ytLP1+b21GwWgENazzlrUyc8+piOkcR2BI/bHQO1yiKEC4aTtFLwAHqKostKjBMiZB2U=
Message-ID: <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:50:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411074145.GA4944@elte.hu>
	 <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
X-Google-Sender-Auth: 6fa7331f9dd1544e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
>  On Fri, Apr 11, 2008 at 10:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  >  our x86.git randconfig auto-qa found a mm/slab.c early-bootup crash in
>  >  mainline that got introduced since v2.6.24.
>  >
>  >   http://redhat.com/~mingo/misc/log-Thu_Apr_10_10_41_16_CEST_2008.bad
>  >   http://redhat.com/~mingo/misc/config-Thu_Apr_10_10_41_16_CEST_2008.bad
>  >
>  >  Note, the very same bzImage does not crash on other testboxes - only on
>  >  this 8-way box with 4GB of RAM.
>  >
>  >  i tried a "use v2.6.24's slab.c" revert (with a few API fixes needed for
>  >  it to build on .25) but that didnt solve the problem either.

On Fri, Apr 11, 2008 at 11:21 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>  As mentioned privately, I suspect it's the page allocator changes that
>  went into 2.6.24. Mel, Christoph, any ideas?

So I'm thinking it's probably related to this patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=523b945855a1427000ffc707c610abe5947ae607

As kmalloc_node() in setup_cpu_cache() returns NULL, it seems likely
to be due to the use of GFP_THISNODE in cache_alloc_refill() when
calling cache_grow() and that the semantics changed. No idea why page
allocator would think your UMA "local node" has no memory though.

                        Pekka
