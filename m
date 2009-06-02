Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZFBOdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZFBOdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZFBOd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:33:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:51066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZFBOd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:33:26 -0400
Date: Tue, 2 Jun 2009 16:33:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602143326.GA17448@wotan.suse.de>
References: <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601140553.GA1979@localhost> <20090601144050.GA12099@wotan.suse.de> <20090602111407.GA17234@localhost> <20090602121940.GD1392@wotan.suse.de> <20090602125134.GA20462@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602125134.GA20462@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 08:51:34PM +0800, Wu Fengguang wrote:
> On Tue, Jun 02, 2009 at 08:19:40PM +0800, Nick Piggin wrote:
> > On Tue, Jun 02, 2009 at 07:14:07PM +0800, Wu Fengguang wrote:
> > > On Mon, Jun 01, 2009 at 10:40:51PM +0800, Nick Piggin wrote:
> > > > But you just said that you try to intercept the IO. So the underlying
> > > > data is not necessarily corrupt. And even if it was then what if it
> > > > was reinitialized to something else in the meantime (such as filesystem
> > > > metadata blocks?) You'd just be introducing worse possibilities for
> > > > coruption.
> > > 
> > > The IO interception will be based on PFN instead of file offset, so it
> > > won't affect innocent pages such as your example of reinitialized data.
> > 
> > OK, if you could intercept the IO so it never happens at all, yes
> > of course that could work.
> > 
> > > poisoned dirty page == corrupt data      => process shall be killed
> > > poisoned clean page == recoverable data  => process shall survive
> > > 
> > > In the case of dirty hwpoison page, if we reload the on disk old data
> > > and let application proceed with it, it may lead to *silent* data
> > > corruption/inconsistency, because the application will first see v2
> > > then v1, which is illogical and hence may mess up its internal data
> > > structure.
> > 
> > Right, but how do you prevent that? There is no way to reconstruct the
> > most updtodate data because it was destroyed.
> 
> To kill the application ruthlessly, rather than allow it go rotten quietly.

Right, but you don't because you just do EIO in a lot of cases. See
EIO subthread.


> > > > You will need to demonstrate a *big* advantage before doing crazy things
> > > > with writeback ;)
> > > 
> > > OK. We can do two things about poisoned writeback pages:
> > > 
> > > 1) to stop IO for them, thus avoid corrupted data to hit disk and/or
> > >    trigger further machine checks
> > 
> > 1b) At which point, you invoke the end-io handlers, and the page is
> > no longer writeback.
> > 
> > > 2) to isolate them from page cache, thus preventing possible
> > >    references in the writeback time window
> > 
> > And then this is possible because you aren't violating mm
> > assumptions due to 1b. This proceeds just as the existing
> > pagecache mce error handler case which exists now.
> 
> Yeah that's a good scheme - we are talking about two interception
> scheme. Mine is passive one and yours is active one.

Oh, hmm, not quite. I had assumed your IO interception is based
on another MCE from DMA transfer (Andi said you get another exception
in that case).

If you are just hoping to get an MCE from CPU access in order to
intercept IO, then you may as well not bother because it is not
closing the window much (very likely that the page will never be
touched again by the CPU).

So if you can get an MCE from the DMA, then you would fail the
request, which will automatically clear writeback, so your CPU MCE
handler never has to bother with writeback pages.

