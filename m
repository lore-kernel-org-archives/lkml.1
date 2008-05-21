Return-Path: <linux-kernel-owner+w=401wt.eu-S936656AbYEUR7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936656AbYEUR7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935400AbYEUR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:59:13 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44641 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933984AbYEUR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:59:12 -0400
Date: Wed, 21 May 2008 21:58:58 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: iput() in reclaim context
Message-ID: <20080521175858.GA2548@2ka.mipt.ru>
References: <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru> <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru> <20080520231942.GX103491721@sgi.com> <20080520162816.e5dfeffa.akpm@linux-foundation.org> <20080521061531.GA27362@2ka.mipt.ru> <20080520232444.8bff5ccf.akpm@linux-foundation.org> <Pine.LNX.4.64.0805211840200.13797@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805211840200.13797@blonde.site>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh.

On Wed, May 21, 2008 at 06:52:27PM +0100, Hugh Dickins (hugh@veritas.com) wrote:
> I happened to notice your remark in the buffer heads defrag thread.
> Do you remember what that limitation was about?
> 
> Because just a few months ago I discovered a shmem race which I fixed
> by doing igrab+iput in shmem_writepage, in the reclaim context.  Feeling
> guilty now: I'd better investigate, but would welcome a starting pointer.
> 
> (If I'm lucky, it'll be that the generic code in vmscan.c cannot
> use iput, but particular filesystems might themselves be safe to.)

If we are talking about the same things, its waiting for pages to be
synced (wither written back or truncated) when inode is about to be
destroyed. Thus reclaim can sleep wating for pages to be synced, which
it is about to move somewhere itself. Deadlock. The same for writepage -
if we drop inode there it can wait for pages to be synced, which inturn
requires writeback, where we are sleeping already...

-- 
	Evgeniy Polyakov
