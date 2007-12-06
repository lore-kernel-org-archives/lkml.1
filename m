Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbXLFFo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbXLFFo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXLFFoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:44:18 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:40073 "EHLO
	mail129-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbXLFFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:44:17 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47578C29.9000007@am.sony.com>
Date: Wed, 05 Dec 2007 21:44:09 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <47537F2E.2070204@am.sony.com>	<b91f94dd5b35247fecf52090c0b3890f@bga.com>	<Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be> <20071205151147.9db4640b.akpm@linux-foundation.org>
In-Reply-To: <20071205151147.9db4640b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2007 05:44:13.0076 (UTC) FILETIME=[07EA8D40:01C837CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 5 Dec 2007 10:52:48 +0100 (CET)
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
>> --------------------------------------------------------------------------------
>> Subject: sparsemem: sparse_add_one_section() may fail to allocate memory
>> 
>> sparsemem: sparse_add_one_section() may fail to allocate memory, and must check
>> whether the allocation succeeded before proceeding to touch the allocated
>> memory.
>> 
>> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> 
>> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> ---
>> FIXME There are still some possible memory leaks in sparse_add_one_section():
>>   - usemap is never deallocated
>>   - __kfree_section_memmap() is a not yet implemented dummy
> 
> I already had
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch


This one has an error in it.  A patch to fix it is below.


> and
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
> 
> queued.  Do they fix the problem, and should they be merged in 2.6.24?


These two plus my fix below allow the hot plug add_memory() call to fail
gracefully and for the platform code to continue to boot on the
128MB of boot mem.

With ps3_defconfig the condition is only hit by the second stage
kexec'ed (kboot) kernel, which is not generally built by end users,
but there is a chance this condition would be hit by custom kernel
config, so I think they should go in for 2.6.24.

I'll continue to work on a fix for the memory allocation failure.

-Geoff


------------------
Subject: sparsemem: Fix sparse_index_init return check

sparse_index_init() returns -EEXIST to indicate the index
has already been created.  Exclude this from the error check
on the return value.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -392,7 +392,7 @@ int sparse_add_one_section(struct zone *
 	 * plus, it does a kmalloc
 	 */
 	ret = sparse_index_init(section_nr, pgdat->node_id);
-	if (ret < 0)
+	if (ret < 0 && ret != -EEXIST)
 		return ret;
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
 	if (!memmap)



