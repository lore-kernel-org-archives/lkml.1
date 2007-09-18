Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXIRQzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXIRQzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759694AbXIRQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:55:09 -0400
Received: from pat.uio.no ([129.240.10.15]:60908 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbXIRQzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:55:08 -0400
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <20070918165220.GE18476@fieldses.org>
References: <46EE3724.80200@openvz.org>
	 <1190037331.6700.14.camel@heimdal.trondhjem.org>
	 <46EE8C52.80503@openvz.org>
	 <1190044850.6700.81.camel@heimdal.trondhjem.org>
	 <46EF7136.7080308@openvz.org> <20070918151957.GA18476@fieldses.org>
	 <1190132095.6656.12.camel@heimdal.trondhjem.org>
	 <20070918165220.GE18476@fieldses.org>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 12:54:56 -0400
Message-Id: <1190134496.6656.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.112)
X-UiO-Scanned: B265B4A091EB7184D66665452661F1BA21D5D271
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 756 total 3954310 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 12:52 -0400, J. Bruce Fields wrote:
> On Tue, Sep 18, 2007 at 12:14:55PM -0400, Trond Myklebust wrote:
> > Note also that strictly speaking, we're not even compliant with the
> > System V behaviour on read() and write(). See:
> > 
> >   http://www.unix.org.ua/orelly/networking_2ndEd/nfs/ch11_01.htm
> > and
> >   http://docs.sun.com/app/docs/doc/801-6736/6i13fom0a?l=en&a=view&q=mandatory+lock
> > 
> > According to these docs, we should be wrapping each and every read() and
> > write() syscall with a mandatory lock. The fact that we're not, and yet
> > still not seeing any complaints just goes to show how few people are
> > actually using and relying on this...
> 
> So currently there's nothing to prevent this:
> 
> 				- write passes locks_mandatory_area() checks
> 	- get mandatory lock
> 	- read old data
> 				- write updates file data
> 	- read new data
> 
> You can see the data change even while you hold a mandatory lock that
> should exclude writes.
> 
> Similarly you might think that an application could prevent anyone from
> seeing the intermediate state of a file while it performs a series of
> writes under an exclusive mandatory lock, but actually there's nothing
> to stop a read in progress from racing with acquisition of the lock.
> 
> Unless I'm missing something, that makes our mandatory lock
> implementation pretty pointless.  I wish we could either fix it or just
> ditch it, but I suppose either option would be unpopular.

It gets even better when you throw mmap() into the mix :-)

Trond

