Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbYEWCPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbYEWCPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbYEWCPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:15:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37166 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbYEWCPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:15:23 -0400
Message-ID: <483628B7.1080704@np.css.fujitsu.com>
Date: Fri, 23 May 2008 11:15:19 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, dgc@sgi.com, viro@ZenIV.linux.org.uk,
       harvey.harrison@gmail.com
Subject: Re: [PATCH][RFC]fix soft lock up at NFS mount by per-SB LRU-list
 of unused dentries
References: <4834D8DA.30907@np.css.fujitsu.com> <20080522225608.GZ173056135@sgi.com>
In-Reply-To: <20080522225608.GZ173056135@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

Thank you for reviewing the patch.
I'd fix coding style issues at next post. And,...

David Chinner wrote:
> On Thu, May 22, 2008 at 11:22:18AM +0900, Kentaro Makita wrote:
>> +			}
>> +		}
>> +	}
> 
> I'm wondering if this loop is an excessively long time to be holding the
> dcache_lock. I guess the hol dtime is limited by the size of *count being
> passed in. I think we could also do a:
> 
> 		cond_resched_lock(&dcache_lock);
> 	
> in the loop here to prevent this from occurring....
Did you mean:
 - scan sb->s_dentry_lru and move dentries to temporary list
   with lock held
 - cond_resched_lock(&dcache_lock);
 - prune dentries on temporary list
Is that right?

....
>> +	spin_lock(&sb_lock);
>> +	list_for_each_entry(sb, &super_blocks, s_list) {
> 
> Question on lock ordering of sb_lock vs dcache_lock - which is the inner
> lock? Are the two of them held together anywhere else? (/me doesn't
> have time to searchthe code right now).
> 
The sb_lock is inner lock. And I searched the whole code and found only
 prune_dcache() held both sb_lock and dcache_lock.

Best Regards,
Kentaro Makita
> 
> Otherwise it's looking good.
> 
> Cheers,
> 
> Dave.
