Return-Path: <linux-kernel-owner+w=401wt.eu-S1762933AbYJMKNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762933AbYJMKNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765020AbYJMJ72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:59:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:42989 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763138AbYJMJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QE0ITG2mqa7V84LuBuBRQ+1IRHuEAfXYM6JzkmX12QUq5toET6c787CjPPXGmqByWC
         cKXaI2NpjKQC9VQ0MaV112WTxbKY7myzVMc+etJig+dnIQv0t099EP6MAHUm+f5TXrce
         KRkVHjAKQrslZ1FgN1v8NULnZY0TbSKy5RKz8=
Message-ID: <48F31BF9.6030109@gmail.com>
Date: Mon, 13 Oct 2008 11:59:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Bryan Wu <cooloney@kernel.org>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Blackfin OTP Char Driver: add writing support of
 OTP
References: <1223889199-31658-1-git-send-email-cooloney@kernel.org>	 <48F316C4.1070603@gmail.com> <8bd0f97a0810130243q39581ef5y704c500c8ac3ee1c@mail.gmail.com>
In-Reply-To: <8bd0f97a0810130243q39581ef5y704c500c8ac3ee1c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2008 11:43 AM, Mike Frysinger wrote:
> On Mon, Oct 13, 2008 at 05:37, Jiri Slaby wrote:
>> On 10/13/2008 11:13 AM, Bryan Wu wrote:
>>> @@ -123,18 +132,95 @@ static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t
>>>       if (mutex_lock_interruptible(&bfin_otp_lock))
>>>               return -ERESTARTSYS;
>>>
>>> -     /* need otp_init() documentation before this can be implemented */
>>> +     stampit();
>>> +
>>> +     timing = bfin_otp_init_timing();
>>> +     if (timing == 0) {
>>> +             mutex_unlock(&bfin_otp_lock);
>>> +             return -EIO;
>>> +     }
>>> +
>>> +     base_flags = OTP_CHECK_FOR_PREV_WRITE;
>>> +
>>> +     bytes_done = 0;
>>> +     page = *pos / (sizeof(u64) * 2);
>>> +     while (bytes_done < count) {
>>> +             flags = base_flags | (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
>>> +             stamp("processing page %i (0x%x:%s) from %p", page, flags,
>>> +                     (flags & OTP_UPPER_HALF ? "upper" : "lower"), buff + bytes_done);
>>> +             if (copy_from_user(&content, buff + bytes_done, sizeof(content))) {
>>> +                     bytes_done = -EFAULT;
>>> +                     break;
>>> +             }
>>> +             ret = bfrom_OtpWrite(page, flags, &content);
>>> +             if (ret & OTP_MASTER_ERROR) {
>>> +                     stamp("error from otp: 0x%x", ret);
>>> +                     bytes_done = -EIO;
>>> +                     break;
>>> +             }
>>> +             if (flags & OTP_UPPER_HALF)
>>> +                     ++page;
>>> +             bytes_done += sizeof(content);
>>> +             *pos += sizeof(content);
>> What happens to pos if it fails later?
> 
> there is no state maintained in the hardware.  the pos gets updated
> only when a half-page actually gets processed.  so there is no
> "later".

Sure there is. Next iteration of the loop. I.e. what happens if bfrom_OtpWrite
fails for the second time?

>> You should change (and check) allow_writes under the mutex anyway.
> 
> not really.  the mutex is to restrict access to the OTP hardware, not
> driver state.  because there is none.  access to allow_writes is
> atomic in the hardware anyways.

Yeah, the assignment/check is.

But is this OK to you:
PROCESS 1			PROCESS 2
lock
  set allow_writes
write
   check allow_writes
   be interrupted
				whatever
				unlock
				    unset allow_writes
				sleep
   mutex lock
   the processing...
