Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZBCWzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZBCWzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZBCWy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:54:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbZBCWy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:54:58 -0500
Date: Tue, 3 Feb 2009 14:53:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mpm@selenic.com, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       davidel@xmailserver.org, davem@davemloft.net, hch@lst.de,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Message-Id: <20090203145346.8df40277.akpm@linux-foundation.org>
In-Reply-To: <20090203153740.363d0a04@bike.lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	<1233598811-6871-3-git-send-email-corbet@lwn.net>
	<20090203133942.2ecec281.akpm@linux-foundation.org>
	<4988BD4E.8080206@cosmosbay.com>
	<20090203140543.6e915f97.akpm@linux-foundation.org>
	<1233699722.3243.127.camel@calx>
	<20090203153740.363d0a04@bike.lwn.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 15:37:40 -0700
Jonathan Corbet <corbet@lwn.net> wrote:

> On Tue, 03 Feb 2009 16:22:02 -0600
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > But that re-opens the question of what to do about poor Jon's quest.
> >
> > I got confused halfway through as he went from using a global fasync
> > spinlock to a non-locked but atomic flag bit. Not sure why using a
> > per-file or per-inode lock doesn't work for the fasync code.
> 
> No per-file lock because (1) there is resistance to growing struct
> file, and (2) lockless algorithms are all the rage now.  Additionally,
> solving the fasync-atomicity problem with locks requires the use of a
> mutex (or the BKL) rather than a spinlock.  I suppose we could combine
> a global f_flags lock with the set-FASYNC-in-fasync_helper() bits.
> 
> At this point Poor Jon sees a fork in the road as he contemplates the
> future of his quest:
> 
> - Go with this patch set, perhaps with a bit of cleanup as suggested by
>   Andrew.
> 
> - Go back to the global lock.
> 
> - Go away, leave the BKL in place, and wait for somebody smarter to
>   attack the problem.

Well.  We _could_ whack part of this nut with my usual hammer: protect
f_flags with file->f_dentry->d_inode->i_lock.  IIRC there was some
objection to that - performance?

One problem here seems to be that we're trying to change multiple
things at the same time.  We can blame the BKL for that.

Can we break the problem into manageable chunks?  Your patchset did
that, I guess.  What were those chunks again? ;)
