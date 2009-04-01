Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZDABA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZDABA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZDABAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:00:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbZDABAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:00:11 -0400
Message-ID: <49D2BB63.3080706@kernel.org>
Date: Wed, 01 Apr 2009 09:54:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com> <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain> <20090331164312.GP5178@kernel.dk> <alpine.LFD.2.00.0903310953310.4093@localhost.localdomain> <20090331171900.GU5178@kernel.dk>
In-Reply-To: <20090331171900.GU5178@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 00:55:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jens Axboe wrote:
>> For example, if the drive doesn't support FUA, then you cannot do a 
>> serialized IO operation, but you can still mostly do a serialized op 
>> without any IO attached to it.
> 
> FUA we should be able to reliably detect, it's really the cache flush
> operation itself that has caused headaches in the past. The -EOPNOTSUPP
> really comes from the block layer, not from the device driver. That's
> mainly due to the fact that we only send down the actual barrier, if the
> driver already said it supported them. If they do fail them, we probably
> need to pick up the -EIO bits and pieces and pretend it didn't happen as
> well. So it definitely needs more looking into, auditing, and testing.
> I'll do that tomorrow.

Yeah, we need to implement some kind of fallback logic such that
filesystems get errors iff the underlying device actually failed to
flush.  For the most part, this shouldn't be too difficult.

There is a corner case for tag ordered requests in that retrying
might end up putting the barrier on the platter after writes following
it.  Well, the problem isn't specific to fallback tho.  The root
problem is that later command get issued before the previous ones are
finished and SCSI ordered tag doesn't mandate failure of earlier
request to abort all the following ones, so by the time block layer
knows about the failure, writes after the barrier might already be on
the platter.  I guess we'll have to ignore that for the time being.

Thanks.

-- 
tejun
