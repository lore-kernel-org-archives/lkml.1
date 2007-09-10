Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbXIKMzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbXIKMzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbXIKMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:55:31 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:25311 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756213AbXIKMza convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:55:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BnTY4+Vnvpurend5aN5qrUqJ6nd0AGB7jdJekgsNQ9cxmYus6yjRqQcSEDuKRbRbljNPWgkfQVM6Q1HmruqbT8rY7bOdbJLFv/BX9AuXNn99VN2cbrdNSoZelq1pOBmQYjMKa//wjHczno3WETO4pvLJZeiSBr9uXXXvmLAFSKs=  ;
X-YMail-OSG: V12bmKsVM1lInIWDTMA..OIG7V1M5AmimgJeKTSEwzIS93TbdvwJusHjcwrCWxFt0UnAGeqoQg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 07:13:54 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org>
In-Reply-To: <20070911121225.GE13132@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709110713.54781.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 22:12, Jörn Engel wrote:
> On Tue, 11 September 2007 04:52:19 +1000, Nick Piggin wrote:
> > On Tuesday 11 September 2007 16:03, Christoph Lameter wrote:
> > > 5. VM scalability
> > >    Large block sizes mean less state keeping for the information being
> > >    transferred. For a 1TB file one needs to handle 256 million page
> > >    structs in the VM if one uses 4k page size. A 64k page size reduces
> > >    that amount to 16 million. If the limitation in existing filesystems
> > >    are removed then even higher reductions become possible. For very
> > >    large files like that a page size of 2 MB may be beneficial which
> > >    will reduce the number of page struct to handle to 512k. The
> > > variable nature of the block size means that the size can be tuned at
> > > file system creation time for the anticipated needs on a volume.
> >
> > The idea that there even _is_ a bug to fail when higher order pages
> > cannot be allocated was also brushed aside by some people at the
> > vm/fs summit. I don't know if those people had gone through the
> > math about this, but it goes somewhat like this: if you use a 64K
> > page size, you can "run out of memory" with 93% of your pages free.
> > If you use a 2MB page size, you can fail with 99.8% of your pages
> > still free. That's 64GB of memory used on a 32TB Altix.
>
> While I agree with your concern, those numbers are quite silly.  The

They are the theoretical worst case. Obviously with a non trivially
sized system and non-DoS workload, they will not be reached.


> chances of 99.8% of pages being free and the remaining 0.2% being
> perfectly spread across all 2MB large_pages are lower than those of SHA1
> creating a collision.  I don't see anyone abandoning git or rsync, so
> your extreme example clearly is the wrong one.
>
> Again, I agree with your concern, even though your example makes it look
> silly.

It is not simply a question of once-off chance for an all-at-once layout
to fail in this way. Fragmentation slowly builds over time, and especially
if you do actually use higher-order pages for a significant number of
things (unlike we do today), then the problem will become worse. If you
have any part of your workload that is affected by fragmentation, then
it will cause unfragmented regions to eventually be used for fragmentation
inducing allocations (by definition -- if it did not, eg. then there would be
no fragmentation problem and no need for Mel's patches).

I don't know what happens as time tends towards infinity, but I don't think
it will be good.

At millions of allocations per second, how long does it take to produce
an unacceptable number of free pages before the ENOMEM condition?
Furthermore, what *is* an unacceptable number? I don't know. I am not
trying to push this feature in, so the burden is not mine to make sure it
is OK.

Yes, we already have some of these problems today. Introducing more
and worse problems and justifying them because of existing ones is much
more silly than my quoting of the numbers. IMO.

