Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbXDMTIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbXDMTIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXDMTIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:08:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbXDMTIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:08:46 -0400
Message-ID: <461FD536.80903@redhat.com>
Date: Fri, 13 Apr 2007 15:08:38 -0400
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] make iunique use a do/while loop rather than its obscure
 goto loop
References: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com> <20070413114214.cb9328f5.akpm@linux-foundation.org>
In-Reply-To: <20070413114214.cb9328f5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Apr 2007 17:58:56 -0400
> Jeffrey Layton <jlayton@redhat.com> wrote:
> 
>> A while back, Christoph mentioned that he thought that iunique ought to be
>> cleaned up to use a more conventional loop construct. This patch does that,
>> turning the strange goto loop into a do/while.
>>
>> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 23fc1fd..90e7587 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -689,21 +689,18 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
>>  	struct inode *inode;
>>  	struct hlist_head * head;
>>  	ino_t res;
>> +
>>  	spin_lock(&inode_lock);
>> -retry:
>> -	if (counter > max_reserved) {
>> -		head = inode_hashtable + hash(sb,counter);
>> +	do {
>> +		if (counter <= max_reserved)
>> +			counter = max_reserved + 1;
>>  		res = counter++;
>> +		head = inode_hashtable + hash(sb, res);
>>  		inode = find_inode_fast(sb, head, res);
>> -		if (!inode) {
>> -			spin_unlock(&inode_lock);
>> -			return res;
>> -		}
>> -	} else {
>> -		counter = max_reserved + 1;
>> -	}
>> -	goto retry;
>> -	
>> +	} while (inode != NULL);
>> +	spin_unlock(&inode_lock);
>> +
>> +	return res;
>>  }
>>  
> 
> hm.
> 
> ino_t iunique(struct super_block *sb, ino_t max_reserved)
> {
> 	static ino_t counter;
> 	struct inode *inode;
> 	struct hlist_head * head;
> 	ino_t res;
> 
> 	spin_lock(&inode_lock);
> 	do {
> 		if (counter <= max_reserved)
> 			counter = max_reserved + 1;
> 		res = counter++;
> 		head = inode_hashtable + hash(sb, res);
> 		inode = find_inode_fast(sb, head, res);
> 	} while (inode != NULL);
> 	spin_unlock(&inode_lock);
> 
> 	return res;
> }
> 
> The counter-vs-max_reserved test can be moved outside the loop, can't it?
> 

No. If the counter wraps while we're looping, then we'll need to skip 
past the "reserved" inode numbers. So we need to check this on every 
loop iteration. We could potentially put that in an "unlikely" if you 
think that would be better.

> Shouldn't counter be per-sb?

I doubt it really matters too much, but it could potentially be more 
efficient to do that, especially after a wraparound on the counter. It 
might be reasonable to make new_inode use a per-sb counter as well. Do 
you think it's worth respinning?

-- Jeff
