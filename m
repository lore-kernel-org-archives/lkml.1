Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbYFNCQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbYFNCQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 22:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYFNCPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 22:15:51 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43674 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYFNCPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 22:15:50 -0400
Date: Sat, 14 Jun 2008 03:15:47 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [2/3] POHMELFS: Documentation.
Message-ID: <20080614021547.GC32232@shareable.org>
References: <20080613163700.GA25860@2ka.mipt.ru> <20080613164110.GB26166@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613164110.GB26166@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Fast and scalable multithreaded userspace server. Being in
>   userspace it works with any underlying filesystem and still is
>   much faster than async in-kernel NFS one.

That's interesting :-)

> POHMELFS uses novel asynchronous approach of data
> processing. Courtesy to transactions, it is possible to detouch
> reply from request, and if command requires data to be received,
> caller just sleeps waiting for it. Thus it is possible to issue
> multiple read commands to different servers and async threads will
> pick replies in parallel, find appropriate transactions in the
> system and put data where it belongs (like page or inode cache).

That sounds great, but what do you mean by 'novel'?  Don't other
modern network filesystems use asynchronous requests and replies in
some form?  It seems like the obvious thing.

> * Transactions support. Full failover for all operations.
>   Resending transactions to different servers on timeout or error.

By transactions, do you mean an atomic set of writes/changes?
Or do you trace read dependencies too?

> Main feature of the POHMELFS is writeback data and metadata cache.
> [...] Creation and removal of objects, as long as writing, are
> asynchronous and are sent to the server during system writeback.
> When server receives some request for given object in the system
> (like data reading, or file creation or whatever else), it stores
> appropriate client information in own cache, so when subsequent
> request comes from different client, all previous could be notified
> (for example when several clients read data from file, and then new
> client writes there, appropriate pages on clients will be
> invalidated, so subsequent write will force them to read page from
> the server). Because of this feature POHMELFS is extremely fast in
> metadata intensive workloads, and can fully utilize bandwidth to
> servers when doing bulk data transafers.

This is extremely cool, and obviously the right thing to do.  No sane
network filesystem would be without it, one naively hopes :-)

How is it different from NFSv4 leases and SMB oplocks?  Or are they
the same basic idea?

With all those asynchronous requests, are your writeback caches fully
coherent?  Example.  Client A reads file X (data: x0), then writes X
(new data: x1), then reads Y (data: y0), then writes Y (data: y1).
Client B reads Y then reads X.  Is it guaranteed that client B cannot
ever get data y1 and x0?  A fully coherent system (meaning behaves
like a local filesystem) does guarantee that.  If cache requests for
file X and file Y are independent, this is not guaranteed.

-- Jamie
