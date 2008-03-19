Return-Path: <linux-kernel-owner+w=401wt.eu-S938250AbYCSXbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938250AbYCSXbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765909AbYCSWDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:03:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52011 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964849AbYCSWDb (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:03:31 -0400
Date: Thu, 20 Mar 2008 09:03:18 +1100
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] A deadlock free and best try version of drop_caches()
Message-ID: <20080319220318.GK155407@sgi.com>
References: <20080318112843.GJ95344431@sgi.com> <E1JbwS9-0008Gq-7h@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JbwS9-0008Gq-7h@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 07:27:29PM +0800, Fengguang Wu wrote:
> On Tue, Mar 18, 2008 at 10:28:44PM +1100, David Chinner wrote:
> > Looks like everything is backed up on the inode_lock.  Why? Looks
> > like drop_pagecache_sb() is doing something ..... suboptimal.
......
> > Anyone know the reason why drop_pagecache_sb() uses such a brute-force
> > mechanism to free up clean page cache pages?
> 
> Because extensive use of it(out of testings) is discouraged? ;-)
> 
> I have been running a longer but safer version, let's merge it?

So you walk the inode hash to find inodes? Seems like a nice idea on
the surface.... Won't it need to hold the iprune_mutex to prevent
races with prune_icache() and invalidate_list()?

Hmmmm - what about unhashed inodes? We'll never see them with this
method of traversal. I ask because I'm working on some prototype
patches for XFS that avoid using the inode hash altogether and drive
inode lookup from the multitude of radix trees we have per filesystem
(for parallelised and lockless inode lookup).

The above scanning method would not work at all with that sort of
filesystem structure. Perhaps combining the bulk get/put with Jan's
get/put method for walking the sb inode list would be sufficient?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
