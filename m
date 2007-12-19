Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbXLSAgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbXLSAgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXLSAgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:36:47 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:55250 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbXLSAgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:36:46 -0500
Message-ID: <47686777.7050605@cosmosbay.com>
Date: Wed, 19 Dec 2007 01:36:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/sys.c : Get rid of expensive divides in groups_sort()
References: <47686269.2090103@cosmosbay.com> <20071218162453.e0156041.akpm@linux-foundation.org>
In-Reply-To: <20071218162453.e0156041.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030904090104000509010200"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 19 Dec 2007 01:36:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030904090104000509010200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Andrew Morton a écrit :
> On Wed, 19 Dec 2007 01:14:33 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> groups_sort() can be quite long if user loads a large gid table.
>>
>> This is because GROUP_AT(group_info, some_integer) uses an integer divide.
>> So having to do XXX thousand divides during one syscall can lead to very high 
>> latencies. (NGROUPS_MAX=65536)
>>
>> In the past (25 Mar 2006), an analog problem was found in groups_search()
>> (commit d74beb9f33a5f16d2965f11b275e401f225c949d ) and at that time I changed 
>> some variables to unsigned int.
>>
>> I believe that a more generic fix is to make sure NGROUPS_PER_BLOCK is unsigned.
>>
> 
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index ac3d496..725a491 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -775,7 +775,7 @@ static inline int above_background_load(void)
>>  
>>  struct io_context;			/* See blkdev.h */
>>  #define NGROUPS_SMALL		32
>> -#define NGROUPS_PER_BLOCK	((int)(PAGE_SIZE / sizeof(gid_t)))
> 
> That was a dopey thing to do.  Both PAGE_SIZE and sizeof() are unsigned and
> we went and cast it to a signed thing, even though it is a nonsense to ever
> consider a negative value of this.

Maybe the author intention was to cast it to an "int", instead of "long", I 
dont know...

> 
>> +#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
>>  struct group_info {
>>  	int ngroups;
>>  	atomic_t usage;
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index d1fe71e..091e58f 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1148,7 +1148,7 @@ static int groups_to_user(gid_t __user *grouplist,
>>  	int count = group_info->ngroups;
>>  
>>  	for (i = 0; i < group_info->nblocks; i++) {
>> -		int cp_count = min(NGROUPS_PER_BLOCK, count);
>> +		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
>>  		int off = i * NGROUPS_PER_BLOCK;
>>  		int len = cp_count * sizeof(*grouplist);
>>  
>> @@ -1168,7 +1168,7 @@ static int groups_from_user(struct group_info *group_info,
>>  	int count = group_info->ngroups;
>>  
>>  	for (i = 0; i < group_info->nblocks; i++) {
>> -		int cp_count = min(NGROUPS_PER_BLOCK, count);
>> +		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
>>  		int off = i * NGROUPS_PER_BLOCK;
>>  		int len = cp_count * sizeof(*grouplist);
>>  
> 
> We now have a jumble of signed and unsigned, stuck together with min_t
> sticky tape.
> 
> Please, take a closer look in there and see if there's anything which
> *needs* to be signed: is there anything which can actually, sensibly have a
> negative quantity?  I bet there isn't, and I bet the code would be cleaner,
> faster and more obviously correct if it was converted to unsigned throughout.
> 
> I blame C.  Negative quantities are rare, and C's default of treating
> scalars as signed was a mistake.  Oh well.
> 
> 

Yes I agree that 'unsigned' should be the default...

Well, I was trying to keep patch small, but as you have some time, I will make 
it bigger :)

[PATCH] kernel/sys.c : Get rid of expensive divides in groups_sort()

groups_sort() can be quite long if user loads a large gid table.

This is because GROUP_AT(group_info, some_integer) uses an integer divide.
So having to do XXX thousand divides during one syscall can lead to very high 
latencies. (NGROUPS_MAX=65536)

In the past (25 Mar 2006), an analog problem was found in groups_search()
(commit d74beb9f33a5f16d2965f11b275e401f225c949d ) and at that time I changed 
some variables to unsigned int.

I believe that a more generic fix is to make sure NGROUPS_PER_BLOCK is unsigned.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------030904090104000509010200
Content-Type: text/plain;
 name="NGROUPS_PER_BLOCK.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="NGROUPS_PER_BLOCK.patch"

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac3d496..725a491 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -775,7 +775,7 @@ static inline int above_background_load(void)
 
 struct io_context;			/* See blkdev.h */
 #define NGROUPS_SMALL		32
-#define NGROUPS_PER_BLOCK	((int)(PAGE_SIZE / sizeof(gid_t)))
+#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
 struct group_info {
 	int ngroups;
 	atomic_t usage;
diff --git a/kernel/sys.c b/kernel/sys.c
index d1fe71e..d632352 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1145,16 +1145,16 @@ static int groups_to_user(gid_t __user *grouplist,
     struct group_info *group_info)
 {
 	int i;
-	int count = group_info->ngroups;
+	unsigned int count = group_info->ngroups;
 
 	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min(NGROUPS_PER_BLOCK, count);
-		int off = i * NGROUPS_PER_BLOCK;
-		int len = cp_count * sizeof(*grouplist);
+		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
+		unsigned int len = cp_count * sizeof(*grouplist);
 
-		if (copy_to_user(grouplist+off, group_info->blocks[i], len))
+		if (copy_to_user(grouplist, group_info->blocks[i], len))
 			return -EFAULT;
 
+		grouplist += NGROUPS_PER_BLOCK;
 		count -= cp_count;
 	}
 	return 0;
@@ -1165,16 +1165,16 @@ static int groups_from_user(struct group_info *group_info,
     gid_t __user *grouplist)
 {
 	int i;
-	int count = group_info->ngroups;
+	unsigned int count = group_info->ngroups;
 
 	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min(NGROUPS_PER_BLOCK, count);
-		int off = i * NGROUPS_PER_BLOCK;
-		int len = cp_count * sizeof(*grouplist);
+		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
+		unsigned int len = cp_count * sizeof(*grouplist);
 
-		if (copy_from_user(group_info->blocks[i], grouplist+off, len))
+		if (copy_from_user(group_info->blocks[i], grouplist, len))
 			return -EFAULT;
 
+		grouplist += NGROUPS_PER_BLOCK;
 		count -= cp_count;
 	}
 	return 0;

--------------030904090104000509010200--
