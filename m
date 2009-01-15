Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbZAOAyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbZAOAyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758906AbZAOAyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:54:35 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50001 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758419AbZAOAye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:54:34 -0500
Message-ID: <496E89E4.9070004@sgi.com>
Date: Thu, 15 Jan 2009 11:57:08 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
Organization: SGI
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: spurious -ENOSPC on XFS
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090112151133.GA24852@infradead.org> <496C2D69.2010301@sgi.com> <20090114221655.GX8071@disturbed>
In-Reply-To: <20090114221655.GX8071@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Tue, Jan 13, 2009 at 04:58:01PM +1100, Lachlan McIlroy wrote:
>> Christoph Hellwig wrote:
>>> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
>>>> Hi
>>>>
>>>> I discovered a bug in XFS in delayed allocation.
>>>>
>>>> When you take a small partition (52MB in my case) and copy many small 
>>>> files on it (source code) that barely fits there, you get -ENOSPC. 
>>>> Then sync the partition, some free space pops up, click "retry" in MC 
>>>> an the copy continues. They you get again -ENOSPC, you must sync, 
>>>> click "retry" and go on. And so on few times until the source code 
>>>> finally fits on the XFS partition.
>>>>
>>>> This misbehavior is apparently caused by delayed allocation, delayed  
>>>> allocation does not exactly know how much space will be occupied by 
>>>> data, so it makes some upper bound guess. Because free space count is 
>>>> only a guess, not the actual data being consumed, XFS should not 
>>>> return -ENOSPC on behalf of it. When the free space overflows, XFS 
>>>> should sync itself, retry allocation and only return -ENOSPC if it 
>>>> fails the second time, after the sync.
>> This sounds like a problem with speculative allocation - delayed allocations
>> beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
>> allocation will be credited to the file. 
> 
> The second retry occurs without speculative EOF allocation. That's
> what the BMAPI_SYNC flag does....
By then it's too late.  There could already be many files with delayed
allocations beyond eof that are unneccesarily consuming space.  I suspect
that when those files are flushed some are not able to convert the full
delayed allocation in one extent and only convert what is needed to write
out data.  The remaining unused delayed allocation is released and that's
why the freespace is going up and down.

> 
> That being said, it can't truncate away pre-existing speculative
> allocations on other files, which is why there is a global flush
> and wait before the third retry.....
> 
> Cheers,
> 
> Dave.

