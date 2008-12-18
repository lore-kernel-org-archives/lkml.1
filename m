Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753049AbYLRTy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYLRTy1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYLRTyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:54:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42451 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYLRTyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=n6SO6NL+Yspr+PA6gPjvq+b5Rugot043VPMwFvmgoNtp+XfyhS28MSRdI2z8aHqK/A
         8I80p0kmThjOy3my0D8Aov3xvPjCU/IRY6nTMtn9domB4qzUzunGiBrhniROvllXuUIG
         OgonTWcFutBd92nZDeZf2jlWudKTF/ST/yCCY=
Message-ID: <494AAA5C.6060601@gmail.com>
Date: Thu, 18 Dec 2008 20:54:04 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203 -	bisected
References: <1228322600.6693.61.camel@lts-notebook> <1228940487.6139.68.camel@lts-notebook>
In-Reply-To: <1228940487.6139.68.camel@lts-notebook>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[ Sorry for the late reply ]

Lee Schermerhorn wrote:
> On Wed, 2008-12-03 at 11:43 -0500, Lee Schermerhorn wrote:
>> I couldn't find anything on the list about this.
>>
>> I've built and booted 28-rc7-mmotm-081203 on both x86_64 and ia64.  I
>> can ssh into the x86_64 platform fine.  On the ia64, I'm seeing sshd
>> [from RHEL5 distro] seg faulting.  [Same sshd worked on the
>> 28-rc6-mmotm-081201 kernel.]
>>
>> Has anyone else seen this?
>>
> 
> I finally got around to bisecting this--sshd fails with SEGV on ia64--on
> mmotm-081208.  It appears to be caused by the patch duo:
> 
> do_mpage_readpage-remove-first_logical_block-parameter.patch
> do_mpage_readpage-remove-first_logical_block-parameter-fix.patch

Unfortunately I don't see why this patch causes such breakage.

Could you apply the following patch with the previous patch applied
and see if sshd still segfaults ?

It basically reverts:

   do_mpage_readpage-remove-first_logical_block-parameter-fix.patch

Therefore I can see which part of the patch is broken.

Also can you tell me what the block size used by the file system
hosting sshd ?

Thanks !

                Franck

--- 8< ---

diff --git a/fs/mpage.c b/fs/mpage.c
index ca33b28..b5ac1ff 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -163,10 +163,7 @@ map_buffer_to_page(struct page *page, struct buffer_head *bh, int page_block)
 */
 static int last_mapped_page(struct buffer_head *map_bh, struct page *page)
 {
-	pgoff_t map_index = map_bh->b_page->index;
-
-	return buffer_boundary(map_bh) &&
-		page->index >= map_index + (map_bh->b_size>>PAGE_CACHE_SHIFT);
+	return buffer_boundary(map_bh);
 }
 
 /*
