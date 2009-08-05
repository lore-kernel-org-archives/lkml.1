Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZHEVxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZHEVxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZHEVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:53:42 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38498 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbZHEVxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:53:42 -0400
Cc: Ramon de Carvalho Valle <ramon@risesecurity.org>,
       Christoph Hellwig <hch@infradead.org>,
       xfs mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mszeredi@novell.com
Message-Id: <041FE945-8CBD-476C-83CD-E57748251711@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <4A790762.3010207@sandeen.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
Date: Wed, 5 Aug 2009 16:53:40 -0500
References: <1249329808.7686.26.camel@logos>	 <20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>	 <4A786110.8090404@sandeen.net> <1249411898.7576.19.camel@logos>	 <4A7887CE.2060300@sandeen.net> <1249444550.7372.23.camel@logos> <4A790762.3010207@sandeen.net>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 4, 2009, at 11:15 PM, Eric Sandeen wrote:

> Ramon de Carvalho Valle wrote:
>> On Tue, 2009-08-04 at 14:11 -0500, Eric Sandeen wrote:
>>> Ramon de Carvalho Valle wrote:
>>>> The xfs_iformat function does not check if the realtime device  
>>>> target pointer
>>>> is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk  
>>>> inode
>>>> structure.
>>>>
>>>> Signed-off-by: Christoph Hellwig <hch@infradead.org>
>>>> Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
>>>> Cc: stable <stable@kernel.org>
>>>> ---
>>>> fs/xfs/xfs_inode.c |   23 +++++++++++++++++------
>>>> 1 files changed, 17 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>> index 1f22d65..37d3ee5 100644
>>>> --- a/fs/xfs/xfs_inode.c
>>>> +++ b/fs/xfs/xfs_inode.c
>>>> @@ -343,13 +343,24 @@ xfs_iformat(
>>>> 		return XFS_ERROR(EFSCORRUPTED);
>>>> 	}
>>>>
>>>> +	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
>>>> +			!ip->i_mount->m_rtdev_targp)) {
>>>> +		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
>>>> +			"corrupt dinode %Lu, flags = 0x%x.",
>>>> +			(unsigned long long)ip->i_ino,
>>>> +			ip->i_d.di_flags);
>>>> +		XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
>>>> +				     ip->i_mount, dip);
>>> I think I'd rather not change all the corruption text tag ordering;
>>> it'll make it harder to track down any common occurrences of
>>> "xfs_iformat(X)" corruption in the future if they get renumbered  
>>> now.
>>>
>>> I'd either make this xfs_iformat(2.1) ;) or just leave it as  
>>> Christoph
>>> had.  "realtime" is a lot more informative than "3" anyway.
>>
>> I don't think this is a bad decision, because the corruption errors  
>> can
>> be easily identified by the output of xfs_fs_repair_cmn_err and the
>> source line. I think this is a reasonable change that will keep the  
>> code
>> clean and consistent.
>
> Until you wind up looking at a problem from some old kernel, or  
> modified
> vendor kernel, and you realize that now you really don't know which
> error "xfs_iformat(6)" is anymore, and you either have to go digging
> through trees that aren't handy, or you just give up and don't  
> bother to
> help because now it's too much of a pain.  ;)
>
> But I can leave it up to the folks @ sgi, I can see both sides of the
> argument, and I won't care too much either way.

Agree with Eric, see the benefits of both approaches, but I think,
it'll be cleaner without shifting the numbering of all messages.
Otherwise, looks good.

Felix

>
>
> Thanks,
> -Eric
>
>> -Ramon
>>
>>> -Eric
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

