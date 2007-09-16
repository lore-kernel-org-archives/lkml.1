Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbXIPSbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbXIPSbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXIPSbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:31:39 -0400
Received: from lazybastard.de ([212.112.238.170]:58637 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXIPSbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:31:38 -0400
Date: Sun, 16 Sep 2007 20:21:37 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Andrea Arcangeli <andrea@suse.de>,
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
Message-ID: <20070916182136.GC2393@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random> <20070916174657.GA2393@lazybastard.org> <alpine.LFD.0.999.0709161112410.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0709161112410.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 September 2007 11:15:36 -0700, Linus Torvalds wrote:
> On Sun, 16 Sep 2007, Jörn Engel wrote:
> > 
> > I have been toying with the idea of having seperate caches for pinned
> > and movable dentries.  Downside of such a patch would be the number of
> > memcpy() operations when moving dentries from one cache to the other.
> 
> Totally inappropriate.
> 
> I bet 99% of all "dentry_lookup()" calls involve turning the last dentry 
> from having a count of zero ("movable") to having a count of 1 ("pinned").
> 
> So such an approach would fundamentally be broken. It would slow down all 
> normal dentry lookups, since the *common* case for leaf dentries is that 
> they have a zero count.

Why am I not surprised? :)

> So it's much better to do it on a "directory/file" basis, on the 
> assumption that files are *mostly* movable (or just freeable). The fact 
> that they aren't always (ie while kept open etc), is likely statistically 
> not all that important.

My approach is to have one for mount points and ramfs/tmpfs/sysfs/etc.
which are pinned for their entire lifetime and another for regular
files/inodes.  One could take a three-way approach and have
always-pinned, often-pinned and rarely-pinned.

We won't get never-pinned that way.

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
