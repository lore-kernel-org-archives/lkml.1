Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbZCaSxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbZCaSxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764051AbZCaSwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:52:22 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:17353 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764050AbZCaSwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:52:19 -0400
Message-ID: <49D2665A.9090500@panasas.com>
Date: Tue, 31 Mar 2009 21:52:10 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Avishay Traeger <avishay@gmail.com>, open-osd <osd-dev@open-osd.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [osd-dev] [PATCH 6/8] exofs: super_operations and	file_system_type
References: <49C1331D.1080805@panasas.com>	<1237399791-29502-1-git-send-email-bharrosh@panasas.com> <20090331010430.72e8137e.akpm@linux-foundation.org>
In-Reply-To: <20090331010430.72e8137e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 18:52:16.0894 (UTC) FILETIME=[CFF659E0:01C9B231]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 31, 2009, 11:04 +0300, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 18 Mar 2009 20:09:51 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> This patch ties all operation vectors into a file system superblock
>> and registers the exofs file_system_type at module's load time.
>>
>> * The file system control block (AKA on-disk superblock) resides in
>>   an object with a special ID (defined in common.h).
>>   Information included in the file system control block is used to
>>   fill the in-memory superblock structure at mount time. This object
>>   is created before the file system is used by mkexofs.c It contains
>>   information such as:
>> 	- The file system's magic number
>> 	- The next inode number to be allocated
>>
>>
>> ...
>>
>> +static int exofs_statfs(struct dentry *dentry, struct kstatfs *buf)
>> +{
>> +	struct super_block *sb = dentry->d_sb;
>> +	struct exofs_sb_info *sbi = sb->s_fs_info;
>> +	struct osd_obj_id obj = {sbi->s_pid, 0};
>> +	struct osd_attr attrs[] = {
>> +		ATTR_DEF(OSD_APAGE_PARTITION_QUOTAS,
>> +			OSD_ATTR_PQ_CAPACITY_QUOTA, sizeof(__be64)),
>> +		ATTR_DEF(OSD_APAGE_PARTITION_INFORMATION,
>> +			OSD_ATTR_PI_USED_CAPACITY, sizeof(__be64)),
>> +	};
>> +	uint64_t capacity = ~0;
>> +	uint64_t used = ~0;
> 
> My brain hurts.
> 
> ~0 is signed 0xffffffff.
> 
> When assigning to a u64 it gets signed extended to signed
> 0xffffffffffffffff and then converted to unsigned 0xffffffffffffffff.

Right (I think, I'm not sure in what order)

> 
> I think.  Just as with plain old "-1".  Perhaps using plain old "-1"
> would be clearer here.

or maybe ~0ULL or ~(uint64_t)0 to be extremely anal about it.

Benny

> 
>> ...
>>
>> +const struct super_operations exofs_sops = {
> 
> This can in fact be made static, I believe.
> 
>> ...
>>
> 
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev
