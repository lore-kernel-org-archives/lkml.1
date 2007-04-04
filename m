Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbXDDU4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbXDDU4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXDDU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:56:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56129 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXDDU4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:56:42 -0400
Date: Wed, 4 Apr 2007 13:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
Message-Id: <20070404135618.d39f98f4.akpm@linux-foundation.org>
In-Reply-To: <4613E9AF.3030802@redhat.com>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<20070403144948.fe8eede6.akpm@linux-foundation.org>
	<20070403160231.33aa862d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com>
	<20070404110406.c79b850d.akpm@linux-foundation.org>
	<4613E9AF.3030802@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 14:08:47 -0400
Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> > There are other ways of doing it - I guess we could use a new page flag to
> > indicate that this is one-of-those-pages, and add new code to handle it in
> > all the right places.
> 
> That's what I did.  I'm currently working on the
> zap_page_range() side of things.

Let's try to avoid consuming another page flag if poss, please.  Perhaps
use PAGE_MAPPING_ANON's neighbouring bit?

> > One thing which we haven't sorted out with all this stuff: once the
> > application has marked an address range (and some pages) as
> > whatever-were-going-call-this-feature, how does the application undo that
> > change? 
> 
> It doesn't have to do anything.  Just access the page and the
> MMU will mark it dirty/accessed and the VM will not reclaim
> it.

um, OK.  I suspect it would be good to clear the page's
PageWhateverWereGoingToCallThisThing() state when this happens.  Otherwise
when the page gets clean again (ie: added to swapcache then written out)
then it will look awfully similar to one of these new types of pages and
things might get confusing.  We'll see.

