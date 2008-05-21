Return-Path: <linux-kernel-owner+w=401wt.eu-S936591AbYEUSOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936591AbYEUSOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935044AbYEUSN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:13:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761768AbYEUSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:13:58 -0400
Date: Wed, 21 May 2008 11:12:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: iput() in reclaim context
Message-Id: <20080521111234.422aa707.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805211840200.13797@blonde.site>
References: <20080515231045.GY155679365@sgi.com>
	<Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
	<20080519054554.GY103491721@sgi.com>
	<Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
	<20080520002503.GC173056135@sgi.com>
	<20080520065622.GA13968@2ka.mipt.ru>
	<20080520214617.GU103491721@sgi.com>
	<20080520222505.GA23988@2ka.mipt.ru>
	<20080520231942.GX103491721@sgi.com>
	<20080520162816.e5dfeffa.akpm@linux-foundation.org>
	<20080521061531.GA27362@2ka.mipt.ru>
	<20080520232444.8bff5ccf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805211840200.13797@blonde.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 18:52:27 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 20 May 2008, Andrew Morton wrote:
> > On Wed, 21 May 2008 10:15:32 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > > On Tue, May 20, 2008 at 04:28:16PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > > > It's more than efficiency.  There are lots and lots of things we cannot
> > > > do in direct-reclaim context.
> > > > 
> > > > ...
> > > > 
> > > > c) Cannot run iput().  Or at least, we couldn't five or six years
> > > >    ago.  afaik nobody has investigated whether the situation is now
> > > >    better or worse.
> 
> I happened to notice your remark in the buffer heads defrag thread.
> Do you remember what that limitation was about?

Ages and ages ago.  I expect it was a deadlock thing.  iput_final() can
end up calling things like write_inode() which can want to do things
like opening a transaction against filesystem A while already having
one open against filesystem B.  Which is both deadlockable and BUGable.
It will take other embarrassing locks too, probably.

> Because just a few months ago I discovered a shmem race which I fixed
> by doing igrab+iput in shmem_writepage, in the reclaim context.  Feeling
> guilty now: I'd better investigate, but would welcome a starting pointer.
> 
> (If I'm lucky, it'll be that the generic code in vmscan.c cannot
> use iput, but particular filesystems might themselves be safe to.)

Yes, it was specific to the direct-reclaim calling context.
