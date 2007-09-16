Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbXIPWvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbXIPWvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXIPWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:51:14 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:49010 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbXIPWvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:51:12 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, Andrea Arcangeli <andrea@suse.de>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <alpine.LFD.0.999.0709161128350.16478@woody.linux-foundation.org>
	(Linus Torvalds's message of "Sun, 16 Sep 2007 11:44:09 -0700 (PDT)")
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070915155100.GA21861@v2.random>
	<87tzpvy9cb.fsf@informatik.uni-tuebingen.de>
	<20070915223032.GA6708@v2.random>
	<20070916174657.GA2393@lazybastard.org>
	<alpine.LFD.0.999.0709161112410.16478@woody.linux-foundation.org>
	<20070916182136.GC2393@lazybastard.org>
	<alpine.LFD.0.999.0709161128350.16478@woody.linux-foundation.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
Date: Mon, 17 Sep 2007 00:51:06 +0200
Message-ID: <87ps0i442t.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, 16 Sep 2007, Jörn Engel wrote:
>> 
>> My approach is to have one for mount points and ramfs/tmpfs/sysfs/etc.
>> which are pinned for their entire lifetime and another for regular
>> files/inodes.  One could take a three-way approach and have
>> always-pinned, often-pinned and rarely-pinned.
>> 
>> We won't get never-pinned that way.
>
> That sounds pretty good. The problem, of course, is that most of the time, 
> the actual dentry allocation itself is done before you really know which 
> case the dentry will be in, and the natural place for actually giving the 
> dentry lifetime hint is *not* at "d_alloc()", but when we "instantiate" 
> it with d_add() or d_instantiate().
>
> But it turns out that most of the filesystems we care about already use a 
> special case of "d_add()" that *already* replaces the dentry with another 
> one in some cases: "d_splice_alias()".
>
> So I bet that if we just taught "d_splice_alias()" to look at the inode, 
> and based on the inode just re-allocate the dentry to some other slab 
> cache, we'd already handle a lot of the cases!
>
> And yes, you'd end up with the reallocation overhead quite often, but at 
> least it would now happen only when filling in a dentry, not in the 
> (*much* more critical) cached lookup path.
>
> 			Linus

You would only get it for dentries that live long (or your prediction
is awfully wrong) and then the reallocation amortizes over time if you
will. :)

MfG
        Goswin
