Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXA1RU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXA1RU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXA1RU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:20:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:42745 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXA1RU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:20:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eFEvgE5urgKS/+lzoPooP7ke5TAISo5koJEnAtqS5Kq6mYqdGdhTN4BVnFViWYgD1Y8dWvT64xEEsmf84zb9qM3Tf/KMeHmDfopc8VUwmEI1L/vh4IZfu8BpVtAkiIuDMKzEvUNW6apws0Be1sv6MAwrUAbc4Lj1ItC/GkVtfu4=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Sun, 28 Jan 2007 18:18:16 +0100
User-Agent: KMail/1.8.2
Cc: 7eggert@gmx.de, Michael Tokarev <mjt@tls.msk.ru>,
       Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
References: <7BYkO-5OV-17@gated-at.bofh.it> <200701271514.31203.vda.linux@googlemail.com> <45BCC17A.9090302@tmr.com>
In-Reply-To: <45BCC17A.9090302@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701281818.17007.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 January 2007 16:30, Bill Davidsen wrote:
> Denis Vlasenko wrote:
> > On Saturday 27 January 2007 15:01, Bodo Eggert wrote:
> >> Denis Vlasenko <vda.linux@googlemail.com> wrote:
> >>> On Friday 26 January 2007 19:23, Bill Davidsen wrote:
> >>>> Denis Vlasenko wrote:
> >>>>> On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
> >>>>>> But even single-threaded I/O but in large quantities benefits from
> >>>>>> O_DIRECT significantly, and I pointed this out before.
> >>>>> Which shouldn't be true. There is no fundamental reason why
> >>>>> ordinary writes should be slower than O_DIRECT.
> >>>>>
> >>>> Other than the copy to buffer taking CPU and memory resources.
> >>> It is not required by any standard that I know. Kernel can be smarter
> >>> and avoid that if it can.
> >> The kernel can also solve the halting problem if it can.
> >>
> >> Do you really think an entropy estamination code on all access patterns in the
> >> system will be free as in beer,
> > 
> > Actually I think we need this heuristic:
> > 
> > if (opened_with_O_STREAM && buffer_is_aligned
> > 		&& io_size_is_a_multiple_of_sectorsize)
> > 	do_IO_directly_to_user_buffer_without_memcpy
> > 
> > is not *that* compilcated.
> > 
> > I think that we can get rid of O_DIRECT peculiar requirements
> > "you *must* not cache me" + "you *must* write me directly to bare metal"
> > by replacing it with O_STREAM ("*advice* to not cache me") + O_SYNC
> > ("write() should return only when data is written to storage, not sooner").
> > 
> > Why?
> > 
> > Because these O_DIRECT "musts" are rather unusual and overkill. Apps
> > should not have that much control over what kernel does internally;
> > and also O_DIRECT was mixing shampoo and conditioner on one bottle
> > (no-cache and sync writes) - bad API.
> 
> What a shame that other operating systems can manage to really support 
> O_DIRECT, and that major application software can use this api to write 
> portable code that works even on Windows.
> 
> You overlooked the problem that applications using this api assume that 
> reads are on bare metal as well, how do you address the case where 
> thread A does a write, thread B does a read? If you give thread B data 
> from a buffer and it then does a write to another file (which completes 
> before the write from thread A), and then the system crashes, you have 
> just put the files out of sync.

Applications which syncronize their data integrity
by keeping data on hard drive and relying on
"read goes to bare metal, so it can't see written data
before it gets written to bare metal". Wow, this is slow.
Are you talking about this scenario:

Bad:
	fd = open(..., O_SYNC);
	fork()
	write(fd, buf); [1]
        ....                   read(fd, buf2); [starts after write 1 started]
        ....                   write(somewhere_else, buf2);
        ....                   (write returns)
        .... <---- crash point
        (write returns)

This will be *very* slow - if you use O_DIRECT and do what
is depicted above, you write data, then you read it back,
whic is slow. Why do you want that? Isn't it
much faster to just wait for write to complete, and allow
read to fetch (potentially) cached data?

Better:
	fd = open(..., O_SYNC);
	fork()
	write(fd, buf); [1]
        ....                   (wait for write to finish)
        ....
        ....
        .... <---- crash point
        (write returns)
        ....                   read(fd, buf2); [starts after write 1 started]
        ....                   write(somewhere_else, buf2);
        ....                   (write returns)

> So you may have to block all i/o for all  
> threads of the application to be sure that doesn't happen.

Not all, only related i/o.
--
vda
