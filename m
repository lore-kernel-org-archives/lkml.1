Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZA1VAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZA1VAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761043AbZA1UvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:51:24 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53245 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761030AbZA1UvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:51:22 -0500
Date: Thu, 29 Jan 2009 07:51:19 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128205119.GA8587@brong.net>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <20090128053204.GB8720@brong.net> <19f34abd0901280308w18407fd5rd4d7d95e3799cf60@mail.gmail.com> <alpine.DEB.1.10.0901280849340.20724@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901280849340.20724@alien.or.mcafeemobile.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 08:52:51AM -0800, Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Vegard Nossum wrote:
> 
> > On Wed, Jan 28, 2009 at 6:32 AM, Bron Gondwana <brong@fastmail.fm> wrote:
> > > That's clearly not happening here - so it seems that maybe our "happy
> > > medium" is actually in closer inspection of what's going on rather than
> > > a blanket low N to keep N^2 down.
> > 
> > Mh, could another solution to this all be to limit the number times
> > you can add a single epoll descriptor to another descriptor's set?
> 
> In the example that was posted, a single fd was added a single time inside 
> the other 1000+ fds. Epoll already has detection for too long chains and 
> closed loops, but you can't put those in the fast path. And epoll_ctl() is 
> one of those.

Not even if you're adding an epoll watcher inside another epoll watcher?

The problem I have here is that "a single fd was added a single time
inside the other 1000+ fds" is different behaviour to the daemons out
there.  They're pretty much all using flat layouts:

process 1:
 epoll_watcher:
  leaf fd
  leaf fd 2
  leaf fd 3
  leaf fd 4
  ...

process 2:
 epoll_watcher:
  ...

While the attack happens inside a single process.

Indeed, if you had a _per_process_ watcher limit, you would stop the
attack working while not breaking at least postfix and apache.  I'm not
sure what Java's doing under the hood, I have a feeling it's more
thready.

But most of all a way of detecting between a leaf fd and an epoll
watcher fd in epoll_ctl and doing deeper tests if it's an epoll watcher
that's being added would stop the attack.

Bron.

