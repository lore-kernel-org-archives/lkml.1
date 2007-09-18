Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXIRQwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXIRQwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759554AbXIRQw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:52:28 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40839 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbXIRQw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:52:28 -0400
Date: Tue, 18 Sep 2007 12:52:20 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
Message-ID: <20070918165220.GE18476@fieldses.org>
References: <46EE3724.80200@openvz.org> <1190037331.6700.14.camel@heimdal.trondhjem.org> <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org> <46EF7136.7080308@openvz.org> <20070918151957.GA18476@fieldses.org> <1190132095.6656.12.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190132095.6656.12.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 12:14:55PM -0400, Trond Myklebust wrote:
> Note also that strictly speaking, we're not even compliant with the
> System V behaviour on read() and write(). See:
> 
>   http://www.unix.org.ua/orelly/networking_2ndEd/nfs/ch11_01.htm
> and
>   http://docs.sun.com/app/docs/doc/801-6736/6i13fom0a?l=en&a=view&q=mandatory+lock
> 
> According to these docs, we should be wrapping each and every read() and
> write() syscall with a mandatory lock. The fact that we're not, and yet
> still not seeing any complaints just goes to show how few people are
> actually using and relying on this...

So currently there's nothing to prevent this:

				- write passes locks_mandatory_area() checks
	- get mandatory lock
	- read old data
				- write updates file data
	- read new data

You can see the data change even while you hold a mandatory lock that
should exclude writes.

Similarly you might think that an application could prevent anyone from
seeing the intermediate state of a file while it performs a series of
writes under an exclusive mandatory lock, but actually there's nothing
to stop a read in progress from racing with acquisition of the lock.

Unless I'm missing something, that makes our mandatory lock
implementation pretty pointless.  I wish we could either fix it or just
ditch it, but I suppose either option would be unpopular.

--b.
