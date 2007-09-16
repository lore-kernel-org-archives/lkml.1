Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXIQN0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXIQN0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXIQNZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:25:58 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:44216 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753320AbXIQNZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:25:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GUn9v1RDQSpUa4henYg3mj56FMzyZfOiR61ctbdgAfDvrbnLazNkunqOdB0bSGrejQ7Pn5Yom6lTqBWAkbTnDZFjZo5Z5nW5mc4ngKwc6csdSLsyTp3LGthOXvrO/AKRt2Tkm6GZ4dmwuDxeyy31Z8RDEl6t5E6+hZHbTUOFed8=  ;
X-YMail-OSG: QogbW.oVM1mqCWE.dHrhL6WPxetNTgUPilUvYhUMrlPkzqZyoqcNzsE1fOa7i2XDf4dnH1enkg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Mon, 17 Sep 2007 07:13:30 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709140648.56184.nickpiggin@yahoo.com.au> <20070917040710.GA23367404@sgi.com>
In-Reply-To: <20070917040710.GA23367404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170713.31945.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 14:07, David Chinner wrote:
> On Fri, Sep 14, 2007 at 06:48:55AM +1000, Nick Piggin wrote:

> > OK, the vunmap batching code wipes your TLB flushing and IPIs off
> > the table. Diffstat below, but the TLB portions are here (besides that
> > _everything_ is probably lower due to less TLB misses caused by the
> > TLB flushing):
> >
> >       -170   -99.4% sn2_send_IPI
> >       -343  -100.0% sn_send_IPI_phys
> >     -17911   -99.9% smp_call_function
> >
> > Total performance went up by 30% on a 64-way system (248 seconds to
> > 172 seconds to run parallel finds over different huge directories).
>
> Good start, Nick ;)

I didn't have the chance to test against a 16K directory block size to find
the "optimal" performance, but it is something I will do (I'm sure it will be
still a _lot_ faster than 172 seconds :)).


> >      23012  54790.5% _read_lock
> >       9427   329.0% __get_vm_area_node
> >       5792     0.0% __find_vm_area
> >       1590  53000.0% __vunmap
>
> ....
>
> _read_lock? I though vmap() and vunmap() only took the vmlist_lock in
> write mode.....

Yeah, it is a slight change... the lazy vunmap only has to take it for read.
In practice, I'm not sure that it helps a great deal because everything else
still takes the lock for write. But that explains why it's popped up in the
profile.


> > Next I have some patches to scale the vmap locks and data
> > structures better, but they're not quite ready yet. This looks like it
> > should result in a further speedup of several times when combined
> > with the TLB flushing reductions here...
>
> Sounds promising - when you have patches that work, send them my
> way and I'll run some tests on them.

Still away from home (for the next 2 weeks), so I'll be going a bit slow :P
I'm thinking about various scalable locking schemes and I'll definitely
ping you when I've made a bit of progress.

Thanks,
Nick
