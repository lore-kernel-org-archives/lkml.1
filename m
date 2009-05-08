Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZEHFUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZEHFUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZEHFUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:20:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:44695 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbZEHFUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:20:09 -0400
Cc: xfs@oss.sgi.com, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.beregalov@gmail.com
Message-Id: <9375AA94-2051-42CB-A7EB-9A32E3F94A24@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <4A039F85.8010506@sandeen.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs: fix double unlock in xfs_swap_extents()
Date: Fri, 8 May 2009 00:20:06 -0500
References: <1241745202-7452-1-git-send-email-felixb@sgi.com> <4A039F85.8010506@sandeen.net>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 7, 2009, at 9:57 PM, Eric Sandeen wrote:

> Felix Blyakher wrote:
>> Regreesion from commit ef8f7fc, which rearranged the code in
>> xfs_swap_extents() leading to double unlock of xfs inode iolock.
>> That resulted in xfs_fsr deadlocking itself on platforms, which
>> don't handle double unlock of rw_semaphore nicely. It caused the
>> count go negative, which represents the write holder, without
>> really having one. ia64 is one of the platforms where deadlock
>> was easily reproduced and the fix was tested.
>>
>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>
> Also-written-by: Eric Sandeen <sandeen@sandeen.net>
> Independently-arrived-at-by: Eric Sandeen <sandeen@sandeen.net>

That would make it: Signed-off-by: Eric Sandeen <sandeen@sandeen.net> :)

> ;)
>
> But seriously ...

Seriously.

Felix

>
>
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
>
>> ---
>> fs/xfs/xfs_dfrag.c |    8 +++++---
>> 1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
>> index e6d839b..7465f9e 100644
>> --- a/fs/xfs/xfs_dfrag.c
>> +++ b/fs/xfs/xfs_dfrag.c
>> @@ -347,13 +347,15 @@ xfs_swap_extents(
>>
>> 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
>>
>> -out_unlock:
>> -	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> -	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> out:
>> 	kmem_free(tempifp);
>> 	return error;
>>
>> +out_unlock:
>> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> +	goto out;
>> +
>> out_trans_cancel:
>> 	xfs_trans_cancel(tp, 0);
>> 	goto out_unlock;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

