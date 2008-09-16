Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYIPLbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYIPLbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 07:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYIPLbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 07:31:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:26710 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYIPLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 07:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xE9aeh/F+0LGKsuXmFsQ4thyXUCrKhyfnxvQ/6O0Ypf7EY3y4GkUlUEXgB2G/AxdMA
         WhD3oQWAy/Q2NLrW3FKY/gDARC+d+XLxs4rC2xUZJU1utRm9XQETw5QApfSI8FEvzhM1
         fNYktxVZGjze1ErCYp/sDWzrzBAME3pPp8eN0=
Message-ID: <ea11fea30809160431v50f4d48i22a9dddf496aea34@mail.gmail.com>
Date: Tue, 16 Sep 2008 17:01:04 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: "Marco Stornelli" <marco.stornelli@coritel.it>
Subject: Re: [PATCH] vfs: added better file aio_read aio_write operations presence check
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48CF94DE.7020209@coritel.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CF7C85.1070309@coritel.it>
	 <ea11fea30809160403x69df37cbn34135c40026f75e3@mail.gmail.com>
	 <48CF94DE.7020209@coritel.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 4:43 PM, Marco Stornelli
<marco.stornelli@coritel.it> wrote:
> BUG_ON it was a way to say: "hey you've used the do_sync_read/write as
> read/write operation but you don't specified an aio_read/write", but
> your solutions it's good too.

Looks like I made some copy paste error while sending the patch. Below
is the updated one.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

---
 fs/read_write.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 9ba495d..b89b707 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -225,7 +225,10 @@ ssize_t do_sync_read(struct file *filp, char
__user *buf, size_t len, loff_t *pp
 	kiocb.ki_left = len;

 	for (;;) {
-		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
+		if (filp->f_op->aio_read)
+			ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
+		else
+			ret = generic_file_aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
 		wait_on_retry_sync_kiocb(&kiocb);
@@ -280,7 +283,10 @@ ssize_t do_sync_write(struct file *filp, const
char __user *buf, size_t len, lof
 	kiocb.ki_left = len;

 	for (;;) {
-		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
+		if (filp->f_op->aio_write)
+			ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
+		else
+			ret = generic_file_aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
 		wait_on_retry_sync_kiocb(&kiocb);
-- 
1.5.4.3

Thanks -
Manish


>
> Manish Katiyar ha scritto:
>> On Tue, Sep 16, 2008 at 2:59 PM, Marco Stornelli
>> <marco.stornelli@coritel.it> wrote:
>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> If a filesystem in the file operations specifies for read and write operations only do_sync_read and do_sync_write without
>>> init aio_read and aio_write, there will be a kernel oops, because the vfs code check the presence of (to read for example)
>>> read OR aio_read method, then it calls read if it's pointer is not null. It's not sufficient because if the read function is
>>> actually a do_sync_read, it calls aio_read but without checking the presence. I think a BUG_ON check can be more useful.
>>
>> Instead of doing a BUG_ON() why can't we simply fall back to the
>> generic_aio functions since most of the fs tend to do so as below.
>>
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>>
>> ---
>>  fs/read_write.c |   10 ++++++++--
>>  1 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index 9ba495d..5439bc4 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -225,7 +225,11 @@ ssize_t do_sync_read(struct file *filp, char
>> __user *buf, size_t len, loff_t *pp
>>       kiocb.ki_left = len;
>>
>>       for (;;) {
>> -             ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
>> +             if (filp->f_op->aio_read)
>> +                     ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
>> +             else
>> +                     ret = generic_file_aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
>>               if (ret != -EIOCBRETRY)
>>                       break;
>>               wait_on_retry_sync_kiocb(&kiocb);
>> @@ -280,7 +284,10 @@ ssize_t do_sync_write(struct file *filp, const
>> char __user *buf, size_t len, lof
>>       kiocb.ki_left = len;
>>
>>       for (;;) {
>> -             ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
>> +             if (filp->f_op->aio_write)
>> +                     ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
>> +             else
>> +                     ret = generic_file_aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
>>               if (ret != -EIOCBRETRY)
>>                       break;
>>               wait_on_retry_sync_kiocb(&kiocb);
>
>
