Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbZCaC0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbZCaC0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZCaC0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:26:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52175 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbZCaC0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:26:39 -0400
Message-ID: <49D17CA2.5060105@redhat.com>
Date: Mon, 30 Mar 2009 22:14:58 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 30 Mar 2009, Jens Axboe wrote:
>   
>>> It has _nothing_ to do with 'reckless'. It has everything to do with 'you 
>>> can't do anything about it'.
>>>       
>> No, but you better damn well inform of such a discovery!
>>     
>
> Well, if that's the issue, then just add a printk to that 
> 'blkdev_issue_flush()', and now you have that informational message in 
> _one_ place, instead of havign each filesystem having to do it over and 
> over again.
>
>   
>>> No. Returning an error just means that now the box is useless. Nobody can 
>>> do anything about it. Not the admin, not the driver writer, not anybody. 
>>>       
>> What, that's nonsense. The admin can certainly check whether it's an
>> issue or not, and he should.
>>     
>
> If it's just informational, then again - why should the filesystem care?
>
> Returning an error to the caller is never the right thing to do. The 
> caller can't do anything sane about it.
>
> If you argue that the admin wants to know, then sure, make that
>
>                 if (bio_flagged(bio, BIO_EOPNOTSUPP))
>         -               ret = -EOPNOTSUPP;
>         +               set_queue_noflush(q);
>
> "set_queue_noflush()" function print a warning message when it sets the 
> bit.
>
> Problem solved.
>
>   
>> That's different from handling it in the kernel or in the application, 
>> but you have to inform about it. I honestly cannot fathom why you don't 
>> think that is important.
>>     
>
> I cannot fathom why you can _possibly_ think that this is something that 
> can and must be done something about in the caller. When the caller 
> obviously has no real option except to ignore the error _anyway_.
>
> That was always my point. Returning an error is INSANE, because ther is no 
> valid thing that the caller can possibly do.
>
> If you want it logged, fine. But THAT DOES NOT CHANGE ANYTHING. It would 
> still be wrong to return the error, since the caller _still_ can't do 
> anything about it.
>
> 		Linus
>   

One thing the caller could do is to disable the write cache on the 
device. A second would be to stop using the transactions - skip the 
journal, just go back to ext2 mode or BSD like soft updates.

Basically, it lets the file system know that its data integrity building 
blocks are not really there and allows it (if it cares) to try and 
minimize the chance of data loss.

Ric

