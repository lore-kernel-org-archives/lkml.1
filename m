Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYLaKnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYLaKnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYLaKmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:42:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22645 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYLaKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=re:to:from:cc:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-type:content-transfer-encoding;
        b=xy7S08ZbDR/YyeDhptyB/Vbe3OY1dHIfPFeyuDWZCcxmx4gswJnGxalUUhStiE2k5i
         MuYPNBV2IBANllNJsJauKYAUcxlThqoF7itfOQrXdYp36GEFnOIumcgClwdytnF/uga7
         /ySjqYmtL0m6r6sTo5PKMjnmQBATEpA+97ypU=
Re: [PATCH] Fix sg_io_hdr.info corruption.
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: James.Bottomley@hansenpartnership.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Date: Wed, 31 Dec 2008 13:51:43 +0300
Message-ID: <20081231104125.3800.97290.stgit@xl0.local>
In-Reply-To: <20081231180759X.fujita.tomonori@lab.ntt.co.jp>
References: <20081231180759X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 12:08, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 30 Dec 2008 15:46:03 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
[...]
>> the code has been like this for years and years.  Why hasn't anyone
>> noticed?
>
> The members from 'status' in struct sg_io_hdr to the last are used to
> transfer information from kernel to user space. The values that user
> space sets are just ignored.
>

Then probably there is no need to copy those fields, right?
There should be no data leak from the kernel, as sgio is
allocated on the userspace stack, and the appropriate ioctl
handler should set/zero all those fields anyway, as it expects
them to come directly from the user (did not check).
So, at worst the user will get it's own garbage insted of the
values he left in the fields that the kernel was supposed to
set.

If so, please could drop my previous patch and take this one.

From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: [PATCH] Don't perform unneeded copy.

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> says:

The members from 'status' in struct sg_io_hdr to the last are used to
transfer information from kernel to user space. The values that user
space sets are just ignored.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 fs/compat_ioctl.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..23b1f5a 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -782,12 +782,6 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
 	if (put_user(compat_ptr(data), &sgio->usr_ptr))
 		return -EFAULT;
 
-	if (copy_in_user(&sgio->status, &sgio32->status,
-			 (4 * sizeof(unsigned char)) +
-			 (2 * sizeof(unsigned (short))) +
-			 (3 * sizeof(int))))
-		return -EFAULT;
-
 	err = sys_ioctl(fd, cmd, (unsigned long) sgio);
 
 	if (err >= 0) {

