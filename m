Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbZA1VFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbZA1VFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZA1VFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:05:24 -0500
Received: from vena.lwn.net ([206.168.112.25]:50449 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZA1VFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:05:22 -0500
Date: Wed, 28 Jan 2009 14:05:18 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128140518.16d84a2b@bike.lwn.net>
In-Reply-To: <1233166427.5202.907.camel@calx>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
	<20090127165504.53ed7a2d.akpm@linux-foundation.org>
	<20090128031439.GA11025@redhat.com>
	<20090128173618.GA3174@infradead.org>
	<20090128104414.09aee3f9@bike.lwn.net>
	<20090128175541.GA7074@infradead.org>
	<1233166427.5202.907.camel@calx>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 12:13:47 -0600
Matt Mackall <mpm@selenic.com> wrote:

> Maybe we can just demote f_ep_lock to f_lock and share it? 

We'd have to move it out of the CONFIG_EPOLL ifdef, but that could be
done.  The bigger problem is that there is resistance to putting a lock
around accesses to f_flags.  I've tried that before...

It also doesn't solve the FASYNC atomicity problem unless we decide to
call ->fasync() with the lock held, and that opens yet another can of
worms.

> Or extend flags and have two independent bitlocks in it. This actually
> shrinks struct_file for most users.

That has some potential.  We'd only need one bitlock (for epoll).
Biggest problem might be preventing the regular file flags from
expanding into the lock bit, especially since those flags are defined
in a pile of architecture-dependent .h files.  I'll look into it.

(That's somebody's cue to tell me why this approach is all wrong
too...:)

Thanks,

jon
