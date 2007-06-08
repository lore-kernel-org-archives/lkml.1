Return-Path: <linux-kernel-owner+w=401wt.eu-S1031169AbXFHSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031169AbXFHSHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761979AbXFHSHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:07:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3430 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbXFHSHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:07:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 Jun 2007 11:07:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Theodore Tso <tytso@mit.edu>
cc: Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608120746.GD12687@thunk.org>
Message-ID: <Pine.LNX.4.64.0706081034470.5519@alien.or.mcafeemobile.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Theodore Tso wrote:

> On Thu, Jun 07, 2007 at 03:40:14PM -0700, Davide Libenzi wrote:
> > Yes. Files with the CLOFORK and CLOEXEC flag do not count for fork and 
> > exec copies.
> > I was also planning on doing it in __put_unused_fd(), every time 
> > fmap->count goes to zero. But get_random_int() is not as cheap as I 
> > thought. If we use a cheaper (although less secure) function to mix pid & 
> > jiffies, we could do it even in there.
> 
> Um, how cheap do you need it?  get_random_int() is actually pretty
> cheep, since it was designed to be usable by the networking stack for
> sequence numbers for TCP packets; and it's not like sys_close() or
> sys_open() is a majorly critical path, is it?  If the concern is
> increasing the potential hold time, I suppose you could have the
> exactly two callers of __put_unused_fd() (sys_close() and
> put_unused_fd()) call get_random_int() before grabbing the
> current->files->file_lock spinlock,

I'm actually using get_random_int() in the slow path (fmap creation time). 
It does a few things get_random_int(), and one of those is an MD4 transform.
This does not need to be super secure (the Unix allocator has been 
exactly predicatble for years), so maybe a cheaper combination of the 
previous base (generated with get_random_int) together with jiffies and 
pid is enough. I really would not want to put something like an MD4 
transform in that path.


- Davide


