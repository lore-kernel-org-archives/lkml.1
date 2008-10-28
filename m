Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYJ1SOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYJ1SOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYJ1SOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:14:11 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:22211 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYJ1SOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:14:09 -0400
Message-ID: <4907566D.9040003@msgid.tls.msk.ru>
Date: Tue, 28 Oct 2008 21:14:05 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>, akpm@linux-foundation.org,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 02/16] Squashfs: directory lookup operations
References: <E1KqrTW-0001xG-Cl@dylan> <Pine.LNX.4.64.0810281835150.23080@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0810281835150.23080@vixen.sonytel.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Fri, 17 Oct 2008, Phillip Lougher wrote:
>> --- /dev/null
>> +++ b/fs/squashfs/namei.c
> 
>> +static int get_dir_index_using_name(struct super_block *s,
>> +			long long *next_block, unsigned int *next_offset,
>> +			long long index_start, unsigned int index_offset,
>> +			int i_count, const char *name, int len)
>> +{
>> +	struct squashfs_sb_info *msblk = s->s_fs_info;
>> +	int i, size, length = 0;
>> +	struct squashfs_dir_index *index;
>> +	char *str;
>> +
>> +	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
>> +
>> +	str = kmalloc(sizeof(*index) + (SQUASHFS_NAME_LEN + 1) * 2, GFP_KERNEL);
>> +	if (str == NULL) {
>> +		ERROR("Failed to allocate squashfs_dir_index\n");
>> +		goto out;
>> +	}
>> +
>> +	index = (struct squashfs_dir_index *) (str + SQUASHFS_NAME_LEN + 1);
> 
> As str has been returned by kmalloc(), and SQUASHFS_NAME_LEN is equal to 256,
> `str + SQUASHFS_NAME_LEN + 1` is an odd address.
> 
[..]
>> +		size = le32_to_cpu(index->size) + 1;
>                                    ^^^^^^^^^^^
[.]
> Hence accessing multi-byte fields in struct squashfs_dir_index causes unaligned
> accesses, which are emulated on some architectures (e.g. on MIPS).
> 
> Use get_unaligned_le32() for unaligned accesses.

How about aligning it properly in the first place instead?
Three ways:

   1) reordering index and str here, so that index comes first,
      str next.

   2) using another constant instead of +1

   3) using separate allocations for separate objects.

/mjt
