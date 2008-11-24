Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbYKXOLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbYKXOLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYKXOKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:10:53 -0500
Received: from smtp.nokia.com ([192.100.105.134]:53597 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYKXOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:10:52 -0500
Message-ID: <492AB7F3.5020406@nokia.com>
Date: Mon, 24 Nov 2008 16:19:31 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-3-git-send-email-dedekind@infradead.org> <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
In-Reply-To: <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2008 14:10:32.0708 (UTC) FILETIME=[69D20440:01C94E3E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> * Artem Bityutskiy | 2008-11-21 19:19:24 [+0200]:
> 
>> index 9ee6508..3f1f16b 100644
>> --- a/fs/ubifs/key.h
>> +++ b/fs/ubifs/key.h
>> @@ -345,7 +345,7 @@ static inline int key_type_flash(const struct ubifs_info *c, const void *k)
>> {
>> 	const union ubifs_key *key = k;
>>
>> -	return le32_to_cpu(key->u32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
>> +	return le32_to_cpu(key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> 
> If you would change such references to something like
> |return le32_to_cpup(&key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> then on powerpc
> 
>   text    data     bss     dec     hex filename
> 155384    1284      24  156692   26414 ubifs-b4.ko
> 155372    1284      24  156680   26408 ubifs-after.ko
> 
> because now it is possible to load the value as LE from memory instead
> of loading it BE and swapping it afterwads.

Wouldn't that be true for every le32_to_cpu of an lvalue?  Shame you can't
do:

is_lvalue(x) ? le32_to_cpup(&(x)) : le32_to_cpu(x)

>> }
>>
>> /**
>> @@ -416,7 +416,7 @@ static inline unsigned int key_block_flash(const struct ubifs_info *c,
>> {
>> 	const union ubifs_key *key = k;
>>
>> -	return le32_to_cpu(key->u32[1]) & UBIFS_S_KEY_BLOCK_MASK;
>> +	return le32_to_cpu(key->j32[1]) & UBIFS_S_KEY_BLOCK_MASK;
>> }
> 
> This and the previous change look like a bugfix for something that
> should trigger during recovery or something? Shouldn't I fail in
> ubifs_validate_entry() during recovery?

This is just about casting.  key->u32[1] and key->j32[1] are the same object.
There is no "real" bug in these two cases - just compilation warnings.

>> /**
>> diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
>> index 77d26c1..bed9742 100644
>> --- a/fs/ubifs/recovery.c
>> +++ b/fs/ubifs/recovery.c
>> @@ -168,12 +168,12 @@ static int write_rcvrd_mst_node(struct ubifs_info *c,
>> 				struct ubifs_mst_node *mst)
>> {
>> 	int err = 0, lnum = UBIFS_MST_LNUM, sz = c->mst_node_alsz;
>> -	uint32_t save_flags;
>> +	__le32 save_flags;
>>
>> 	dbg_rcvry("recovery");
>>
>> 	save_flags = mst->flags;
>> -	mst->flags = cpu_to_le32(le32_to_cpu(mst->flags) | UBIFS_MST_RCVRY);
>> +	mst->flags |= cpu_to_le32(UBIFS_MST_RCVRY);
> 
> another micro optimisation would be to use __constant_cpu_to_le32()

As per Harvey's reply.

