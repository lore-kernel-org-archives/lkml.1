Return-Path: <linux-kernel-owner+w=401wt.eu-S1751450AbZIVSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbZIVSyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZIVSyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:54:31 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:61432 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZIVSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FJZRgxj4Nv/BC8wFwfKFenUrVXb2lhl+Gq3urWWoxNJxkFqqOlLhH4M15oa0w4L06Z
         MIx9xLsfk2YBCZ3Nc/3+Zc9008zv/SoPUSs2lJfWvAGxIMlWMS+2ZQVbxEAtwc3SW3Lo
         S3qBprrCfIybF1Ukizo/1tZcmCL++scFK8mhE=
MIME-Version: 1.0
In-Reply-To: <20090922135453.GF25965@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
	 <1253624054-10882-3-git-send-email-mel@csn.ul.ie>
	 <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com>
	 <20090922135453.GF25965@csn.ul.ie>
Date: Tue, 22 Sep 2009 21:54:33 +0300
X-Google-Sender-Auth: a78f499e358f177f
Message-ID: <84144f020909221154x820b287r2996480225692fad@mail.gmail.com>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a kmem_cache_cpu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, Sep 22, 2009 at 4:54 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> I don't understand how the memory leak happens from the above
>> description (or reading the code). page_to_nid() returns some crazy
>> value at free time?
>
> Nope, it isn't a leak as such, the allocator knows where the memory is.
> The problem is that is always frees remote but on allocation, it sees
> the per-cpu list is empty and calls the page allocator again. The remote
> lists just grow.
>
>> The remote list isn't drained properly?
>
> That is another way of looking at it. When the remote lists get to a
> watermark, they should drain. However, it's worth pointing out if it's
> repaired in this fashion, the performance of SLQB will suffer as it'll
> never reuse the local list of pages and instead always get cold pages
> from the allocator.

I worry about setting c->local_nid to the node of the allocated struct
kmem_cache_cpu. It seems like an arbitrary policy decision that's not
necessarily the best option and I'm not totally convinced it's correct
when cpusets are configured. SLUB seems to do the sane thing here by
using page allocator fallback (which respects cpusets AFAICT) and
recycling one slab slab at a time.

Can I persuade you into sending me a patch that fixes remote list
draining to get things working on PPC? I'd much rather wait for Nick's
input on the allocation policy and performance.

                        Pekka
