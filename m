Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbZANWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbZANWRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZANWRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:17:04 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:65230 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbZANWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:17:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQCANPwbUl5LDnlgWdsb2JhbACTfgEBFiK7AYVv
X-IronPort-AV: E=Sophos;i="4.37,263,1231075800"; 
   d="scan'208";a="293852388"
Date: Thu, 15 Jan 2009 09:16:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090114221655.GX8071@disturbed>
Mail-Followup-To: Lachlan McIlroy <lachlan@sgi.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090112151133.GA24852@infradead.org> <496C2D69.2010301@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496C2D69.2010301@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:58:01PM +1100, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
>>> Hi
>>>
>>> I discovered a bug in XFS in delayed allocation.
>>>
>>> When you take a small partition (52MB in my case) and copy many small 
>>> files on it (source code) that barely fits there, you get -ENOSPC. 
>>> Then sync the partition, some free space pops up, click "retry" in MC 
>>> an the copy continues. They you get again -ENOSPC, you must sync, 
>>> click "retry" and go on. And so on few times until the source code 
>>> finally fits on the XFS partition.
>>>
>>> This misbehavior is apparently caused by delayed allocation, delayed  
>>> allocation does not exactly know how much space will be occupied by 
>>> data, so it makes some upper bound guess. Because free space count is 
>>> only a guess, not the actual data being consumed, XFS should not 
>>> return -ENOSPC on behalf of it. When the free space overflows, XFS 
>>> should sync itself, retry allocation and only return -ENOSPC if it 
>>> fails the second time, after the sync.
> This sounds like a problem with speculative allocation - delayed allocations
> beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
> allocation will be credited to the file. 

The second retry occurs without speculative EOF allocation. That's
what the BMAPI_SYNC flag does....

That being said, it can't truncate away pre-existing speculative
allocations on other files, which is why there is a global flush
and wait before the third retry.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
