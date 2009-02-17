Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZBQMac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZBQMac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZBQMaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:30:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:52999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZBQMaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:30:21 -0500
Date: Tue, 17 Feb 2009 13:30:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: set_page_dirty races (was: Re: [patch 2/4] vfs: add set_page_dirty_notag)
Message-ID: <20090217123017.GG26402@wotan.suse.de>
References: <18841.60432.329341.514726@edward.zelnet.ru> <1234861781.4744.21.camel@laptop> <20090217093805.GB31323@wotan.suse.de> <1234865116.4744.46.camel@laptop> <20090217102443.GA26402@wotan.suse.de> <1234867200.4744.65.camel@laptop> <20090217112512.GD26402@wotan.suse.de> <1234870772.4744.79.camel@laptop> <20090217115532.GF26402@wotan.suse.de> <1234872334.4744.95.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234872334.4744.95.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:05:34PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 12:55 +0100, Nick Piggin wrote:
> > If nobody thinks it is insane, I'll resend to Andrew in a new thread.
> 
> Right, gup_fast() seems to also respect .write properly,

Phew! :)

> so it would
> also be used to balance that.
> 
> I guess gup_fast() would need to use trylock_page(), and fall back to
> the slow path when we start taking PG_locked on .write.

Yeah, you're right there. It might also be possible to have a flag
somewhere to avoid the lock if the underlying filesystem doesn't
have a page_mkwrite or doesn't account dirty... which could avoid
the overhead for the common case of anonymous or tmpfs memory.

For gup_fast that pretty much implies an extra page flag I think. But
let's not get too worried with details... I don't think put_user_pages
hurts, even if it only remains as put_page loop. Just to help reader
through the page refcounting. 
 
> I suppose we should start converting a few gup users over to pup before
> handing the thing to Andrew, to have at least a few examples in-kernel.

Could do. There are quite a few easy ones.
