Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYHWIKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYHWIKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 04:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYHWIKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 04:10:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:55285 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYHWIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 04:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OMjkNj1N8tJ6+vSrAyqYEKo/gNVWh1xTEGPYiNyUD+Mj7FVhp6aiVDaGjLSZow8U13
         GiCq5ZUDTJ5isqXsRifuSWTuim4psx2k3m6XB2Vxats239RW+GyE71yZIyMVYl+zaOoz
         rEIIYnLCSKZGPKfgy+GwomNob7H3hJ3i7MZyo=
Message-ID: <48AFC5ED.50005@gmail.com>
Date: Sat, 23 Aug 2008 01:10:21 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@enneenne.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()
References: <48ABCC0B.40607@gmail.com> <20080822153451.bb79bd1f.akpm@linux-foundation.org>
In-Reply-To: <20080822153451.bb79bd1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 20 Aug 2008 00:47:23 -0700
> Zev Weiss <zevweiss@gmail.com> wrote:
> 
>> From: Zev Weiss <zevweiss@gmail.com>
>>
>> The MEMGETREGIONINFO ioctl() in mtdchar.c was clobbering user memory by
>> overwriting more than intended, due to the size of struct
>> mtd_erase_region_info changing in commit
>> 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8.
>>
>> Fix uses a member-by-member copy into a local struct region_info_user,
>> which is then copy_to_user()'d (and matches the size correctly by being
>> of the same type as the pointer passed in the ioctl() call).
>>
>> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
>> Tested-by: Zev Weiss <zevweiss@gmail.com>
>> ---
>> I had been having some problems with userspace memory corruption, and traced
>> them to a MEMGETREGIONINFO ioctl() on an MTD device.  I applied this patch and
>> it seems to fix the problem, though I am not an expert and there may be a more
>> correct way to go about doing this.  I'm also new at submitting patches, so
>> hopefully I haven't screwed up the patch-submission etiquette too
>> horrifically.
>>
>>   drivers/mtd/mtdchar.c |   11 +++++++++--
>>   1 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
>> index 13cc67a..0acb135 100644
>> --- a/drivers/mtd/mtdchar.c
>> +++ b/drivers/mtd/mtdchar.c
>> @@ -411,14 +411,21 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
>>   	case MEMGETREGIONINFO:
>>   	{
>>   		struct region_info_user ur;
>> +		struct mtd_erase_region_info *kr;
>>
>>   		if (copy_from_user(&ur, argp, sizeof(struct region_info_user)))
>>   			return -EFAULT;
>>
>>   		if (ur.regionindex >= mtd->numeraseregions)
>>   			return -EINVAL;
>> -		if (copy_to_user(argp, &(mtd->eraseregions[ur.regionindex]),
>> -				sizeof(struct mtd_erase_region_info)))
>> +
>> +		kr = &(mtd->eraseregions[ur.regionindex]);
>> +
>> +		ur.offset = kr->offset;
>> +		ur.erasesize = kr->erasesize;
>> +		ur.numblocks = kr->numblocks;
>> +
>> +		if (copy_to_user(argp, &ur, sizeof(struct region_info_user)))
>>   			return -EFAULT;
>>   		break;
>>   	}
> 
> ug.
> 
> Putting a kernel pointer into a shared-with-userspace data structure
> (struct mtd_erase_region_info) was a big mistake.
> 
> Copying a `struct region_info_user' back to userspace seems better than
> copying a `struct mtd_erase_region_info', but what do I know?
> 
> Actually...
> 
> Before 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8, `struct
> mtd_erase_region_info' had three members, all u32.  We were copying
> three u32's out to userspace.
> 
> After 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8, `struct
> mtd_erase_region_info' has four members: three u32's and one ulong*. 
> We're copying three u32's and one ulong* out to userspace.
> 
> After your change, we're copying _four_ u32's out to userspace, so
> there still is potential for scribbling on unsuspecting userspace?
> 
> If that reading is right, we need to go back to copying just the three
> u32's.  Perhaps via
> 
> struct mtd_erase_region_info {
> 	struct {
> 		u_int32_t offset;
> 		u_int32_t erasesize;
> 		u_int32_t numblocks;
> 	} user_part;
> 	unsigned long *lockmap;
> };
> 
> or similar.
> 
> David?  Help?  2.6.25.x anmd 2.6.26.x need fixing as well.
> 
> 

Hmm.  Well, I may be misunderstanding what you're saying (again, I'm very much
a newbie to kernelspace), but I *think* the "copying four u32's out to
userspace" thing isn't really a problem with my patch.  It does certainly copy
those four u32's, but given that `ur' (struct mtd_region_info_user) is
initialized by copying from userspace, its fourth u32 (the `regionindex'
member) should be identical when copied back out to userspace, given that it's
not touched in the memberwise modification of the struct.  So yes, it is
copying 4 bytes more than is strictly necessary, but it seemed like a
reasonably clean way of going about it (to me, for what that's worth).

In my particular situation it didn't do anything unexpected in my testing (and
restored the normal behavior I had when previously running 2.6.17.7).

On the other hand, if I'm missing something completely, please let me know,
and perhaps I can prepare a more suitable fix.

Thanks,
Zev
