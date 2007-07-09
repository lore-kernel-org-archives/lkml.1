Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXGIC5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXGIC5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbXGIC5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:57:33 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:22830 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758651AbXGIC5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:57:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VIVX571Dk9XvJOsdjzq2Rv2EAT91PrldL1hVfLBkZ4zH5+NA7amJ1sMZL+Qejksj+OV/G3fAi5SkqWAB9p61P614AT6VLe/eW+ZnbVNKUf+UTD7X0aEQ3il3uwnnkiacUc0Wd64Frmjy9YceoDPtKD5WqpWk1Ue5uZqbFK/YO7U=  ;
X-YMail-OSG: G2WK7RsVM1lMvsb3KYAucSnDDvHth2Nc6lLI1Buv2qbpYdcUgd5R.PJmMIAvw.5vTQpkyl269g--
Message-ID: <4691A415.6040208@yahoo.com.au>
Date: Mon, 09 Jul 2007 12:57:25 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com>	<20070708035018.074510057@sgi.com>	<20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
In-Reply-To: <20070708110224.9cd9df5b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 8 Jul 2007 09:51:19 +0200 Ingo Molnar <mingo@elte.hu> wrote:

>>A year ago the -rt kernel defaulted to the SLOB for a few releases, and 
>>barring some initial scalability issues (which were solved in -rt) it 
>>worked pretty well on generic PCs, so i dont buy the 'it doesnt work' 
>>argument either.
>>
> 
> 
> I don't think a saving of a few k of text would justify slob's retention.

Probably not.


> A reason for retaining slob would be that it has some O(n) memory saving
> due to better packing, etc.  Indeed that was the reason for merging it in
> the first place.  If slob no longer retains that advantage (wrt slub) then
> we no longer need it.

SLOB contains several significant O(1) and also O(n) memory savings that
are so far impossible-by-design for SLUB. They are: slab external
fragmentation is significantly reduced; kmalloc internal fragmentation is
significantly reduced; order of magnitude smaller kmem_cache data type;
order of magnitude less code...

Actually with an unscientific test boot of a semi-stripped down kernel and
mem=16MB, SLOB (the version in -mm) uses 400K less than SLUB (or a full 50%
more RAM free after booting into bash as the init).

Now it's not for me to say that this is significant enough to make SLOB
worth keeping, or what sort of results it yields in the field, so I cc'ed
Denis who is the busybox maintainer, and Erik who is ulibc maintainer in
case they have anything to add.


> Guys, look at this the other way.  Suppose we only had slub, and someone
> came along and said "here's a whole new allocator which saves 4.5k of
> text", would we merge it on that basis?  Hell no, it's not worth it.  What
> we might do is to get motivated to see if we can make slub less porky under
> appropriate config settings.


In light of Denis's recent statement I saw "In busybox project people
can kill for 1.7K", there might be a mass killing of kernel developers
in Cambridge this year if SLOB gets removed ;)

Joking aside, the last time this came up, I thought we concluded that
removal of SLOB would be a severe regression for a significant userbase.


> Let's not get sentimental about these things: in general, if there's any
> reasonable way in which we can rid ourselves of any code at all, we should
> do so, no?

Definitely. And this is exactly what we said last time as well. If the
small memory embedded guys are happy for SLOB to go, then I'm happy too.
So, the relevant question is -- are most/all current SLOB users are now
happy to switch over to SLUB, in light of the recent advances to both
allocators?

-- 
SUSE Labs, Novell Inc.
