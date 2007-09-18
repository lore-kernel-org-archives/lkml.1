Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXIRRk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXIRRk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbXIRRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:40:21 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52721 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbXIRRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:40:20 -0400
Date: Tue, 18 Sep 2007 13:40:16 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
Message-ID: <20070918174016.GF18476@fieldses.org>
References: <46EE3724.80200@openvz.org> <1190037331.6700.14.camel@heimdal.trondhjem.org> <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org> <46EF7136.7080308@openvz.org> <20070918151957.GA18476@fieldses.org> <1190132095.6656.12.camel@heimdal.trondhjem.org> <20070918165220.GE18476@fieldses.org> <1190134496.6656.22.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190134496.6656.22.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 12:54:56PM -0400, Trond Myklebust wrote:
> On Tue, 2007-09-18 at 12:52 -0400, J. Bruce Fields wrote:
> > So currently there's nothing to prevent this:
> > 
> > 				- write passes locks_mandatory_area() checks
> > 	- get mandatory lock
> > 	- read old data
> > 				- write updates file data
> > 	- read new data
> > 
> > You can see the data change even while you hold a mandatory lock that
> > should exclude writes.
> > 
> > Similarly you might think that an application could prevent anyone from
> > seeing the intermediate state of a file while it performs a series of
> > writes under an exclusive mandatory lock, but actually there's nothing
> > to stop a read in progress from racing with acquisition of the lock.
> > 
> > Unless I'm missing something, that makes our mandatory lock
> > implementation pretty pointless.  I wish we could either fix it or just
> > ditch it, but I suppose either option would be unpopular.
> 
> It gets even better when you throw mmap() into the mix :-)

Hm.  Documentation/mandatory.txt claims that it mandatory locks and
mmap() with MAP_SHARED exclude each other, but I can't see where that's
enfoced.  That file doesn't make any mention of the above race.

So for now I think someone should update that file and fcntl(2) to
mention these problems and to recommend rather strongly against using
mandatory locking.

--b.
