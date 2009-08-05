Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZHEEPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZHEEPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 00:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZHEEPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 00:15:31 -0400
Received: from sandeen.net ([209.173.210.139]:14161 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbZHEEPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 00:15:30 -0400
Message-ID: <4A790762.3010207@sandeen.net>
Date: Tue, 04 Aug 2009 23:15:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
CC: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, hch@lst.de,
       linux-kernel@vger.kernel.org, mszeredi@novell.com
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
References: <1249329808.7686.26.camel@logos>	 <20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>	 <4A786110.8090404@sandeen.net> <1249411898.7576.19.camel@logos>	 <4A7887CE.2060300@sandeen.net> <1249444550.7372.23.camel@logos>
In-Reply-To: <1249444550.7372.23.camel@logos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramon de Carvalho Valle wrote:
> On Tue, 2009-08-04 at 14:11 -0500, Eric Sandeen wrote:
>> Ramon de Carvalho Valle wrote:
>>> The xfs_iformat function does not check if the realtime device target pointer
>>> is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
>>> structure.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@infradead.org>
>>> Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
>>> Cc: stable <stable@kernel.org>
>>> ---
>>>  fs/xfs/xfs_inode.c |   23 +++++++++++++++++------
>>>  1 files changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>> index 1f22d65..37d3ee5 100644
>>> --- a/fs/xfs/xfs_inode.c
>>> +++ b/fs/xfs/xfs_inode.c
>>> @@ -343,13 +343,24 @@ xfs_iformat(
>>>  		return XFS_ERROR(EFSCORRUPTED);
>>>  	}
>>>  
>>> +	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
>>> +			!ip->i_mount->m_rtdev_targp)) {
>>> +		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
>>> +			"corrupt dinode %Lu, flags = 0x%x.",
>>> +			(unsigned long long)ip->i_ino,
>>> +			ip->i_d.di_flags);
>>> +		XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
>>> +				     ip->i_mount, dip);
>> I think I'd rather not change all the corruption text tag ordering;
>> it'll make it harder to track down any common occurrences of
>> "xfs_iformat(X)" corruption in the future if they get renumbered now.
>>
>> I'd either make this xfs_iformat(2.1) ;) or just leave it as Christoph
>> had.  "realtime" is a lot more informative than "3" anyway.
> 
> I don't think this is a bad decision, because the corruption errors can
> be easily identified by the output of xfs_fs_repair_cmn_err and the
> source line. I think this is a reasonable change that will keep the code
> clean and consistent.

Until you wind up looking at a problem from some old kernel, or modified
vendor kernel, and you realize that now you really don't know which
error "xfs_iformat(6)" is anymore, and you either have to go digging
through trees that aren't handy, or you just give up and don't bother to
help because now it's too much of a pain.  ;)

But I can leave it up to the folks @ sgi, I can see both sides of the
argument, and I won't care too much either way.

Thanks,
-Eric

> -Ramon
> 
>> -Eric


