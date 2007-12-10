Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXLJOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXLJOjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXLJOjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:39:03 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:64502 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXLJOjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:39:00 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] mm: fix XIP file writes
Date: Mon, 10 Dec 2007 15:38:20 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>, cotte@de.ibm.com
References: <20071204042628.GA26636@wotan.suse.de> <20071204113549.GA6751@wotan.suse.de> <20071204130050.GB6751@wotan.suse.de>
In-Reply-To: <20071204130050.GB6751@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712101538.20619.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

> Here we go. See, brd already found a bug ;)
> Can you apply the ext2 XIP patch too? And I'll resend the brd XIP patch.
[...]
> Writing to XIP files at a non-page-aligned offset results in data corruption
> because the writes were always sent to the start of the page.
[...]
> @@ -314,7 +314,7 @@ __xip_file_write(struct file *filp, cons
>  		fault_in_pages_readable(buf, bytes);
>  		kaddr = kmap_atomic(page, KM_USER0);
>  		copied = bytes -
> -			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
> +			__copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
>  		kunmap_atomic(kaddr, KM_USER0);
>  		flush_dcache_page(page);

I asked myself why this problem never happened before. So I asked our testers
to reproduce this problem on 2.6.23 and service levels. As the testcase did
not trigger, I looked into the 2.6.23 code. This problem was introduced by
commit 4a9e5ef1f4f15205e477817a5cefc34bd3f65f55 (mm: write iovec cleanup from
Nick Piggin) during 2.6.24-rc:
--------snip-------
-		copied = filemap_copy_from_user(page, offset, buf, bytes);
[...]
+		copied = bytes -
+			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
-------------------

So yes, its good to have xip on brd. It even tests your changes ;-)
Good news is, that we dont need anything for stable.

Christian
