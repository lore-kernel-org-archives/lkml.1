Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbYDZSzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbYDZSzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758998AbYDZSy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:54:57 -0400
Received: from sandeen.net ([209.173.210.139]:23264 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbYDZSy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:54:57 -0400
Message-ID: <48137A7E.4000202@sandeen.net>
Date: Sat, 26 Apr 2008 13:54:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
References: <200804261651.02078.vda.linux@googlemail.com>
In-Reply-To: <200804261651.02078.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi David,
> 
> This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> by moving part of its body into a helper function.
> 
> This results in some variables not taking stack space in
> xfs_bmap_btalloc() anymore.
> 
> The helper itself does not call anything stack-deep.
> Stack-deep call to xfs_alloc_vextent() happen
> in xfs_bmap_btalloc(), as before.
> 
> Compile tested only.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
> 

Looks like a very good approach, it pushes a lot of large local vars off
into the helper.

There is one build-time problem if DEBUG is turned on:

        if (args.fsbno != NULLFSBLOCK) {
                ap->firstblock = ap->rval = args.fsbno;
                ASSERT(nullfb || fb_agno == args.agno ||
                       (ap->low && fb_agno < args.agno));

in xfs_bmap_btalloc, which no longer has an fb_agno variable which the
ASSERT macro uses.

Thanks,

-Eric
