Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYJHAks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYJHAks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYJHAk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:40:26 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:39045 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756421AbYJHAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:40:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Bc6HwZTq2uFKWe8d59o2OerG1ZWCqL7/F05Kn//yKq0grUsI3F8s2zGIpChq3aTimVG2voStMKFprRJ3alKbssovixc9ILbf4ZpqB/PWEMmKLKM2rj5is8O+/BrM8uKGm+qrZhZccm+Vea2IdQGkEaE21ETEKKCZn/Ez7HmkSEQ=  ;
X-YMail-OSG: T4X1aEkVM1m2CSju55qqKJhDF8cvS7sfOORyj04VL5CcmTrCbazMwsWyc.ho83UGN5hEmQKcpVRjJMvY5gKnQEYff29FoVfrIgKplT2e29ZomM7VqlpdIeZziyZMkAv8P81pmXa4gyy9uH0qRfv9SrEMF3GWobCoY2GUaK6RdoRrYwbiolU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 8 Oct 2008 11:40:14 +1100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <200810080327.44530.nickpiggin@yahoo.com.au> <20081007105056.16d9e785.akpm@linux-foundation.org>
In-Reply-To: <20081007105056.16d9e785.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081140.15382.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 04:50, Andrew Morton wrote:
> On Wed, 8 Oct 2008 03:27:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Tuesday 07 October 2008 21:29, Andi Kleen wrote:
> > > > Maybe cmpxchg8b is good for i486 or later x86, but i386 or other
> > > > architectures that do not have similar instruction needs some locking
> > > > primitive. I think lazy
> > >
> > > We have a cmpxchg emulation on 386. That works because only UP 386s are
> > > supported, so it can be done in software.
> > >
> > > > seqlock is one option for making file->f_pos access atomic.
> > >
> > > The question is if it's the right option. At least all the common
> > > operations on fds (read/write) are all writers, not readers.
> >
> > Common operations are read, do something, write. So seqlocks then cost
> > one atomic operation, a couple of memory barriers (all noops on x86),
> > and some predictable branches etc.
> >
> > cmpxchg based would require 2 lock ; cmpxchg8b on 32-bit. Fairly heavy.
> > Also I don't think we have generic accessors to do this, so I think
> > that is for another project.
> >
> > Anyway, I think importantly this creates some usable accessors for the
> > f_pos problem. I think we actually need to touch a _lot_ of code to
> > cover all f_pos accesses in the kernel, but I guess this gets the ball
> > rolling.
>
> Aneesh is proposing using using seqlocks to make percpu_counter.count
> atomic on 32-bit.
>
> This patch uses seqlocks to make file.f_pos atomic on 32-bit.
>
> I think we should come up with a common atomic 64-bit type.  We already
> partly have that: atomic64_t.  But for reasons which I don't recall,
> atomic64_t is 64-bit-only at present.
>
> If we generalise atomic64_t to all architectures then we can use it in
> both the above applications and surely in other places in the future.

seqlocks can't really make it a general 64-bit atomic type. Well, they
_could_, but then your actual type is much bigger than 64 bits, or you
map to a hash of seqlocks or something awful...

Anyway, my main point is that the bulk of the work will be in the changes
all over the kernel to use the accessors. How it works behind that is
obviously trivially changed by comparison (it could start off without
changing any code at all and just wrap the racy accessors).


> > So.. is everyone agreed that corrupting f_pos is a bad thing? (serious
> > question) If so, then we should get something like this merged sooner
> > rather than later.
>
> - two threads/processes sharing the same fd
>
> - both appending the same fd
>
> - both hit the small race window right around the time when the file
>   flips over a multiple of 4G.
>
> It's pretty damn improbable, and I think we can afford to spend the
> time to get this right in 2.6.29.

My question is: what is "right"? Do we actually care about this and
intend to fix it? Because there have been people in the past who have
said no...

