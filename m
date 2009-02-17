Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZBQMF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZBQMF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZBQMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:05:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:40514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZBQMFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:05:46 -0500
Subject: Re: set_page_dirty races (was: Re: [patch 2/4] vfs: add
 set_page_dirty_notag)
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
In-Reply-To: <20090217115532.GF26402@wotan.suse.de>
References: <18838.49922.215481.399653@edward.zelnet.ru>
	 <1234645893.4695.8.camel@laptop>
	 <18841.60432.329341.514726@edward.zelnet.ru>
	 <1234861781.4744.21.camel@laptop> <20090217093805.GB31323@wotan.suse.de>
	 <1234865116.4744.46.camel@laptop> <20090217102443.GA26402@wotan.suse.de>
	 <1234867200.4744.65.camel@laptop> <20090217112512.GD26402@wotan.suse.de>
	 <1234870772.4744.79.camel@laptop>  <20090217115532.GF26402@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 13:05:34 +0100
Message-Id: <1234872334.4744.95.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 12:55 +0100, Nick Piggin wrote:
> On Tue, Feb 17, 2009 at 12:39:32PM +0100, Peter Zijlstra wrote:
> > On Tue, 2009-02-17 at 12:25 +0100, Nick Piggin wrote:
> > 
> > > Introduce put_user_pages function.
> > > 
> > > In order to have more flexibility to deal with issues surrounding
> > > get_user_pages difficulties[*], introduce put_user_pages function
> > > intended to release pages acquired by get_user_pages. For now, just
> > > do the regular put_page thing. If all callers are converted, it could
> > > be used to help with such races. In the meantime, it will actually
> > > serve as a small extra piece of documentation for the code.
> > > 
> > > [*] eg. get_user_pages caller can bypass page_mkwrite calls into the
> > >     filesystem to notify of page dirty activity if the page gets cleaned
> > >     before the caller calls its final set_page_dirty).
> > 
> > Hmm, if we want to distinguish between .write=1 and .write=0, we would
> > have to pass .write to pup too, right?
> 
> Doh, yeah. I hand edited the patch to put that parameter in, but quilt
> refresh must have outsmarted me!
> 
> If nobody thinks it is insane, I'll resend to Andrew in a new thread.

Right, gup_fast() seems to also respect .write properly, so it would
also be used to balance that.

I guess gup_fast() would need to use trylock_page(), and fall back to
the slow path when we start taking PG_locked on .write.

I suppose we should start converting a few gup users over to pup before
handing the thing to Andrew, to have at least a few examples in-kernel.

