Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbXCTFTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbXCTFTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 01:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbXCTFTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 01:19:04 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:29765 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933234AbXCTFTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 01:19:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=6OD5X95JdjdxGwS5CPPRRAwLnQG7so/msnOilDDXOCuPpFFomc10zb1IaXNPTZs/4i+peOgQEaeDK0RS8DfXWzTJvoJn61eBVu/u59sFU4L2czMIlwAk+mvaD/rXUx0cwu1k9wL1f+p7Tp0zOKcnEYmi4k6Vl641ka2XqsGs+3A=  ;
X-YMail-OSG: 7bZ7I8QVM1km3ejftwc8SomMJheGtm55XeqrJM7mC1MFQDnPNw5wGAOV8qEG7e_mc7qGLgye6YCRwq7heTb27prVYWTT7.wEjwKKjRQDyZm9mzeLXNexZgQAN78i05lvtvk5tHCGaF_e0Dd0COhQl50tlg--
Message-ID: <45FF6EC1.10705@yahoo.com.au>
Date: Tue, 20 Mar 2007 16:18:57 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>	<45FEE33C.1020706@googlemail.com>	<20070319140827.285dcc7f.akpm@linux-foundation.org>	<6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>	<20070319175852.c73406f1.akpm@linux-foundation.org>	<20070319180234.6b7826b2.akpm@linux-foundation.org>	<45FF4B59.3060107@yahoo.com.au> <20070319205645.4918d978.akpm@linux-foundation.org> <45FF6E55.4060101@yahoo.com.au>
In-Reply-To: <45FF6E55.4060101@yahoo.com.au>
Content-Type: multipart/mixed;
 boundary="------------040502030409040700050903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040502030409040700050903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Nick Piggin wrote:
> Andrew Morton wrote:
> 
>> On Tue, 20 Mar 2007 13:47:53 +1100 Nick Piggin 
>> <nickpiggin@yahoo.com.au> wrote:
>>
>>
>>> Andrew Morton wrote:
>>>
> 
>>> Hang on a sec... I'll try fixing the thing before you next make a
>>> release.
>>>
>>
>>
>> Too late.  hot-fixes/ awaits thee.
> 
> 
> Awww... well thanks very much Michal for reporting the bug, I reproduced
> it easily and it turns out to be a typo.
> 
> In my testing I never had a lot of writeout going on, so most of the pages
> will have been truncated in the first loop...

Also, noticed another problem in the same general area. Andrew you were
indeed right to question the removal of that unmap_mapping_range call,
but I think even it alone it wasn't enough...

-- 
SUSE Labs, Novell Inc.

--------------040502030409040700050903
Content-Type: text/plain;
 name="mm-dnp-invp-race-fix2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-dnp-invp-race-fix2.patch"

The nopage vs invalidate race fix patch did not take care of truncating
private COW pages. Mind you, I'm pretty sure this was previously racy
even for regular truncate, not to mention vmtruncate_range.

Anyway, fix that omission.

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1905,7 +1905,18 @@ int vmtruncate(struct inode * inode, lof
 	if (IS_SWAPFILE(inode))
 		goto out_busy;
 	i_size_write(inode, offset);
+
+	/*
+	 * unmap_mapping_range is called twice, first simply for efficiency
+	 * so that truncate_inode_pages does fewer single-page unmaps. However
+	 * after this first call, and before truncate_inode_pages finishes,
+	 * it is possible for private pages to be COWed, which remain after
+	 * truncate_inode_pages finishes, hence the second unmap_mapping_range
+	 * call must be made for correctness.
+	 */
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(mapping, offset);
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 	goto out_truncate;
 
 do_expand:
@@ -1943,7 +1954,9 @@ int vmtruncate_range(struct inode *inode
 
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	truncate_inode_pages_range(mapping, offset, end);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	inode->i_op->truncate_range(inode, offset, end);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);

--------------040502030409040700050903--
Send instant messages to your online friends http://au.messenger.yahoo.com 
