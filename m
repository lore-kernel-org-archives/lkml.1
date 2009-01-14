Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZAND7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZAND7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZAND7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:59:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:50296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZAND7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:59:23 -0500
Message-ID: <496D6300.9070402@kernel.org>
Date: Wed, 14 Jan 2009 12:58:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>	<49649C65.6000706@kernel.org>	<200901101716.04220.rusty@rustcorp.com.au>	<Pine.LNX.4.64.0901121120280.30369@quilx.com>	<m1mydwxvtx.fsf@frodo.ebiederm.org> <496BE157.2000009@kernel.org>	<m1y6xfx62a.fsf@frodo.ebiederm.org> <496C071F.3000408@kernel.org> <m1k58zx305.fsf@frodo.ebiederm.org>
In-Reply-To: <m1k58zx305.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Jan 2009 03:59:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
>> I don't know.  I think it's a dangerous thing which can be avoided.
>> If there's no other solution, then we might have to live with it but I
>> don't see the winning benefit of such design over per-cpu virtual
>> mapping.
> 
> It isn't incompatible with a per-cpu virtual mapping.  It allows the
> possibility of each cpu reusing the same chunk of virtual address
> space for per cpu memory.
> 
> On x86_64 and other architectures with enough address space bits it allows
> us to share the large pages that we use for the normal memory mapping with
> the ones for per cpu access.
> 
> I definitely think the work of combining the pda and the percpu areas
> into a common area is worthwhile.

Yeah, it's gonna be necessary regardless of which way we go.

> I think it would be nice if the percpu area could grow and would not be
> a fixed size at boot time, I'm not particularly convinced it has to.

The main problem is that the area needs to be congruent which
basically mandates them to be contiguous.  The three alternatives on
table are...

1. Just reserve memory from the get-go.  Simplest.  No additional TLB
   pressure but memory is likely to be wasted and more importantly
   scalability suffers.

2. Reserve address space and map memory as necessary.  We can be much
   more generous about reserving address space especially on 64bit
   machines and probably can mostly forget about scalability issue
   there.  However, getting things just right for address space
   contrained 32bit might not be too easy but then again nothing
   really is scalable on 32bit these days, so we probably can live
   with boot time parameter or something.

   Another issue is added TLB pressure as it's likely to consume 4K
   TLB entries in addition to the default kernel mapping 2M TLB
   entries.  The TLB pressure can be mostly avoided if percpu area is
   sufficiently large to justify 2MB page allocation but it isn't.

3. Do realloc().  This doesn't impose scalability issues or add to TLB
   pressure but it does contrain how the percpu variables can be used
   and introduces certain amount of possibility for scary
   once-in-a-blue-moon never-reproducible bugs.  Maybe such
   possibility can be reduced by putting some restriction on the
   interface but I don't know.  It still scares me.

Hmm... IIUC, the biggest drawback of #2 is the added TLB pressure,
right?  What if we reserve percpu allocation by 2MB chunks?  ie. use
4k mapping but always allocate the percpu pages from aligned 2MB
chunks.  That way it won't waste 2MB per cpu and although it will use
additional 4K TLB entries, it will free up 2MB TLB entries.

Thanks.

-- 
tejun
