Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbZCaCBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbZCaCBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbZCaCAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:00:49 -0400
Received: from THUNK.ORG ([69.25.196.29]:33517 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829AbZCaCAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:00:48 -0400
Date: Mon, 30 Mar 2009 21:58:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
Message-ID: <20090331015850.GY13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Jeff Garzik <jeff@garzik.org>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, David Rees <drees76@gmail.com>,
	Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	david@fromorbit.com
References: <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com> <20090330143343.GJ13356@mit.edu> <49D17162.1090207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D17162.1090207@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 10:26:58AM +0900, Tejun Heo wrote:
> 
> How about having something like blk_ensure_cache_flushed() which
> issues flush iff there hasn't been any write since the last flush?
> It'll be easy to implement and will filter out duplicate flushes in
> most cases.
> 

I thought about such a thing, but my concern is that while this might
suppress most unnecessary double flushes, some intervening write from
another process might slip in which doesn't need to be flushed out.
In other words "in most cases" means that "in some cases" we will take
a performance hit thanks to the duplicate flushes.  So this isn't
something we should depend upon, although if we do detect back-to-back
flushes, obviously we should filter them out.

So if we did something like this, it would be good if we had a
debugging option which would detect double flushes, and printk a
warning identifying where the call sites first and second flushes (by
function name and line number), so that filesystem developers could
detect the double flushes, and work to eliminate them.

Does that make sense?

              	   	  	       	    - Ted
