Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZI1NVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZI1NVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZI1NVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:21:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZI1NU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:20:59 -0400
Subject: Re: [patch 04/33] fs: brlock vfsmount_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090927195619.GG6327@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065534.447753909@nick.local0.net>
	 <20090922151751.GM5858@ZenIV.linux.org.uk>
	 <20090927195619.GG6327@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 15:21:03 +0200
Message-Id: <1254144063.15795.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 21:56 +0200, Nick Piggin wrote:
> On Tue, Sep 22, 2009 at 04:17:51PM +0100, Al Viro wrote:
> > On Fri, Sep 04, 2009 at 04:51:45PM +1000, npiggin@suse.de wrote:
> > > Use a brlock for the vfsmount lock.
> > 
> > I like it, but I'd like to see how costly it becomes on heavily SMP boxen.
> > Creation/removal of bindings as load...
> 
> I could test that... Is there some realistic scenario I can try
> to implement that exercises this? (failing that, I'll happily
> do a microbenchmark).
> 
> I was thinking it *might* be possible to do RCU... but especially
> coming up with a scheme that avoids synchronize_rcu() in the
> umount path is not trivial, so perhaps the simple read/write
> annotations with brlock behind the scenes is a more reasonable step.
> 
> I do also actually owe you some documentation with this one too,
> which I will get around to adding.

The thing that worries me is that the write-side is very heavy and the
read sides are spinning on it, yielding rather large spin times on large
smp boxen.

It wouldn't nearly be as bad if the read sides could block..

FWIW, spin_lock_nested is limited to 8 subclasses, so your current
implementation will explode on anything larger than an 8-way.

