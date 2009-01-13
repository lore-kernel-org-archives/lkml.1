Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbZAMFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbZAMFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZAMFze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:55:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33615 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754943AbZAMFzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:55:33 -0500
Message-ID: <496C2D69.2010301@sgi.com>
Date: Tue, 13 Jan 2009 16:58:01 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
Organization: SGI
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: spurious -ENOSPC on XFS
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090112151133.GA24852@infradead.org>
In-Reply-To: <20090112151133.GA24852@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
>> Hi
>>
>> I discovered a bug in XFS in delayed allocation.
>>
>> When you take a small partition (52MB in my case) and copy many small 
>> files on it (source code) that barely fits there, you get -ENOSPC. Then 
>> sync the partition, some free space pops up, click "retry" in MC an the 
>> copy continues. They you get again -ENOSPC, you must sync, click "retry" 
>> and go on. And so on few times until the source code finally fits on the 
>> XFS partition.
>>
>> This misbehavior is apparently caused by delayed allocation, delayed 
>> allocation does not exactly know how much space will be occupied by data, 
>> so it makes some upper bound guess. Because free space count is only a 
>> guess, not the actual data being consumed, XFS should not return -ENOSPC 
>> on behalf of it. When the free space overflows, XFS should sync itself, 
>> retry allocation and only return -ENOSPC if it fails the second time, 
>> after the sync.
This sounds like a problem with speculative allocation - delayed allocations
beyond eof.  Even if we write a small file, say 4k, a 64k chunk of delayed
allocation will be credited to the file.  If we extend the file we use more
of that chunk instead of allocating more.  When the file is closed and the
last inode reference is dropped the excess delayed allocations are released
back to freespace - this must be happening during the sync.

> 
> This looks a lot like: http://oss.sgi.com/bugzilla/show_bug.cgi?id=724
> It's on my short-term todo list to turn the testcase in that entry
> into a proper xfsqa testcase and followup on the investigation by
> Dave and Eric.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

