Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZGGNQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZGGNQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZGGNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:16:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48383 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325AbZGGNQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:16:22 -0400
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible memory leak in fs/sysfs/bin.c
References: <b0943d9e0907061530u2d375fe5x91f92cfee3166c91@mail.gmail.com>
	<loom.20090706T230728-669@post.gmane.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 07 Jul 2009 14:16:13 +0100
In-Reply-To: <loom.20090706T230728-669@post.gmane.org> (Parag Warudkar's message of "Mon\, 6 Jul 2009 23\:12\:13 +0000 \(UTC\)")
Message-ID: <tnxmy7gvdk2.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Jul 2009 13:16:14.0412 (UTC) FILETIME=[1AAB40C0:01C9FF05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar <parag.warudkar@gmail.com> wrote:
> Catalin Marinas <catalin.marinas <at> arm.com> writes:
>
>> --- a/fs/sysfs/bin.c
>> +++ b/fs/sysfs/bin.c
>> @@ -164,6 +164,7 @@ static ssize_t write(struct file *file, const char
>> __user *userbuf,
>>  	mutex_lock(&bb->mutex);
>> 
>>  	memcpy(bb->buffer, temp, count);
>> +	kfree(temp);
>
> Does the kfree() need to be inside the mutex_lock? Otherwise looks
> OK to me.

Here's the updated patch:


Free the memory allocated by memdup_user() in fs/sysfs/bin.c

Commit 1c8542c7bb replaced kmalloc() with memdup_user() in the write()
function but also dropped the kfree(temp). The memdup_user() function
allocates memory which is never freed.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 fs/sysfs/bin.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 9345806..2524714 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -171,6 +171,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 	if (count > 0)
 		*off = offs + count;
 
+	kfree(temp);
 	return count;
 }
 

-- 
Catalin
