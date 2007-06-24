Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXFXNyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXFXNyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 09:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbXFXNyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 09:54:24 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24418 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbXFXNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 09:54:23 -0400
Date: Sun, 24 Jun 2007 09:51:26 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070624135126.GA10077@think.oraclecorp.com>
References: <20070624014528.GA17609@wotan.suse.de> <467DE00A.9080700@garzik.org> <20070624034755.GA3292@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624034755.GA3292@wotan.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 05:47:55AM +0200, Nick Piggin wrote:
> On Sat, Jun 23, 2007 at 11:07:54PM -0400, Jeff Garzik wrote:
> 
> > >- Large block support. I can mount and run an 8K block size minix3 fs on
> > >  my 4K page system and it didn't require anything special in the fs. We
> > >  can go up to about 32MB blocks now, and gigabyte+ blocks would only
> > >  require  one more bit in the fsblock flags. fsblock_superpage blocks
> > >  are > PAGE_CACHE_SIZE, midpage ==, and subpage <.
> > 
> > definitely useful, especially if I rewrite my ibu filesystem for 2.6.x, 
> > like I've been planning.
> 
> Yeah, it wasn't the primary motivation for the rewrite, but it would
> be negligent to not even consider large blocks in such a rewrite, I
> think.

I'll join the cheering here, thanks for starting on this.

>  
> > My gut feeling is that there are several problem areas you haven't hit 
> > yet, with the new code.
> 
> I would agree with your gut :)
> 

Without having read the code yet (light reading for monday morning ;),
ext3 and reiserfs use buffers heads for data=ordered to help them do
deadlock free writeback.  Basically they need to be able to write out
the pending data=ordered pages, potentially with the transaction lock
held (or if not held, while blocking new transactions from starting).

But, writepage, prepare_write and commit_write all need to start a
transaction with the page lock already held.  So, if the page lock were
used for data=ordered writeback, there would be a lock inversion between
the transaction lock and the page lock.

Using buffer heads instead allows the FS to send file data down inside
the transaction code, without taking the page lock.  So, locking wrt
data=ordered is definitely going to be tricky.

The best long term option may be making the locking order
transaction -> page lock, and change writepage to punt to some other
queue when it needs to start a transaction.

-chris
