Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXC0IwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXC0IwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXC0IwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:52:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXC0Iv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:51:59 -0400
Date: Tue, 27 Mar 2007 00:51:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070327005150.9177ae02.akpm@linux-foundation.org>
In-Reply-To: <E1HW72O-0003ZB-00@dorka.pomaz.szeredi.hu>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
	<20070326234957.6b287dda.akpm@linux-foundation.org>
	<E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu>
	<20070327001834.04dc375e.akpm@linux-foundation.org>
	<E1HW72O-0003ZB-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 10:28:16 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > But Peter Staubach says a RH custumer has files written thorugh mmap,
> > > which are not being backed up.
> > 
> > Yes, I expect the backup problem is the major real-world hurt arising from
> > this bug.
> > 
> > But I expect we could adequately plug that problem at munmap()-time.  Or,
> > better, do_wp_page().  As I said - half-assed.
> > 
> > It's a question if whether the backup problem is the only thing which is hurting
> > in the real-world, or if people have other problems.
> > 
> > (In fact, what's wrong with doing it in do_wp_page()?
> 
> It's rather more expensive, than just toggling a bit.

It shouldn't be, especially for filesystems which have one-second timestamp
granularity.

Filesystems which have s_time_gran=1 might hurt a bit, but no more than
they will with write().

Actually, no - we'd only update the mctime once per page per writeback
period (30 seconds by default) so the load will be small.  It'll be more
often if the user is doing a lot of pte-cleaning via msync() or fsync(),
but then the m/ctime writes will be the least of their problems. 

I'd have thought there were more substantial problems with something that
crude?
