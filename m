Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbXIPSSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbXIPSSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXIPSSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:18:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbXIPSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:18:33 -0400
Date: Sun, 16 Sep 2007 11:15:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Andrea Arcangeli <andrea@suse.de>,
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
In-Reply-To: <20070916174657.GA2393@lazybastard.org>
Message-ID: <alpine.LFD.0.999.0709161112410.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org>
 <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random>
 <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random>
 <20070916174657.GA2393@lazybastard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Sep 2007, Jörn Engel wrote:
> 
> I have been toying with the idea of having seperate caches for pinned
> and movable dentries.  Downside of such a patch would be the number of
> memcpy() operations when moving dentries from one cache to the other.

Totally inappropriate.

I bet 99% of all "dentry_lookup()" calls involve turning the last dentry 
from having a count of zero ("movable") to having a count of 1 ("pinned").

So such an approach would fundamentally be broken. It would slow down all 
normal dentry lookups, since the *common* case for leaf dentries is that 
they have a zero count.

So it's much better to do it on a "directory/file" basis, on the 
assumption that files are *mostly* movable (or just freeable). The fact 
that they aren't always (ie while kept open etc), is likely statistically 
not all that important.

			Linus
