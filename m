Return-Path: <linux-kernel-owner+w=401wt.eu-S1765203AbYJMJ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765203AbYJMJ7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761184AbYJMJni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:43:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:8955 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762589AbYJMJnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h/2oDk2l4Ryh0L1eX/n830MdaYEVWlve1DqLOgw6nzBl/9I9gsoe1/+di9Jxx+SBU6
         /SAmoSoFvtKnTyFhGB0UYGGGX9DJYb6o8eoCL2b0TcWlrOCNNwmxcfprDLLBtosG6Bxt
         kCZzhoApPrHGl4Jo+QKHRp/vR7dgReHI1MuBU=
Message-ID: <8bd0f97a0810130243q39581ef5y704c500c8ac3ee1c@mail.gmail.com>
Date: Mon, 13 Oct 2008 05:43:36 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin OTP Char Driver: add writing support of OTP
Cc: "Bryan Wu" <cooloney@kernel.org>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48F316C4.1070603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223889199-31658-1-git-send-email-cooloney@kernel.org>
	 <48F316C4.1070603@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 05:37, Jiri Slaby wrote:
> On 10/13/2008 11:13 AM, Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>
> Some changelog please.

i implemented write support.  like the subject says ... not sure what
else to say.

>> @@ -123,18 +132,95 @@ static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t
>>       if (mutex_lock_interruptible(&bfin_otp_lock))
>>               return -ERESTARTSYS;
>>
>> -     /* need otp_init() documentation before this can be implemented */
>> +     stampit();
>> +
>> +     timing = bfin_otp_init_timing();
>> +     if (timing == 0) {
>> +             mutex_unlock(&bfin_otp_lock);
>> +             return -EIO;
>> +     }
>> +
>> +     base_flags = OTP_CHECK_FOR_PREV_WRITE;
>> +
>> +     bytes_done = 0;
>> +     page = *pos / (sizeof(u64) * 2);
>> +     while (bytes_done < count) {
>> +             flags = base_flags | (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
>> +             stamp("processing page %i (0x%x:%s) from %p", page, flags,
>> +                     (flags & OTP_UPPER_HALF ? "upper" : "lower"), buff + bytes_done);
>> +             if (copy_from_user(&content, buff + bytes_done, sizeof(content))) {
>> +                     bytes_done = -EFAULT;
>> +                     break;
>> +             }
>> +             ret = bfrom_OtpWrite(page, flags, &content);
>> +             if (ret & OTP_MASTER_ERROR) {
>> +                     stamp("error from otp: 0x%x", ret);
>> +                     bytes_done = -EIO;
>> +                     break;
>> +             }
>> +             if (flags & OTP_UPPER_HALF)
>> +                     ++page;
>> +             bytes_done += sizeof(content);
>> +             *pos += sizeof(content);
>
> What happens to pos if it fails later?

there is no state maintained in the hardware.  the pos gets updated
only when a half-page actually gets processed.  so there is no
"later".

>> +static int bfin_otp_ioctl(struct inode *inode, struct file *filp,
>> +                          unsigned cmd, unsigned long arg)
>> +{
>> +     stampit();
>> +
>> +     switch (cmd) {
>> +     case OTPLOCK: {
>> +             u32 timing;
>> +             int ret = -EIO;
>> +
>> +             if (!allow_writes)
>> +                     return -EACCES;
>> +
>> +             if (mutex_lock_interruptible(&bfin_otp_lock))
>> +                     return -ERESTARTSYS;
>> +
>> +             timing = bfin_otp_init_timing();
>> +             if (timing) {
>> +                     u32 otp_result = bfrom_OtpWrite(arg, OTP_LOCK, NULL);
>> +                     stamp("locking page %i resulted in 0x%x", arg, otp_result);
>> +                     if (!(otp_result & OTP_MASTER_ERROR))
>> +                             ret = 0;
>> +
>> +                     bfin_otp_deinit_timing(timing);
>> +             }
>> +
>> +             mutex_unlock(&bfin_otp_lock);
>> +
>> +             return ret;
>> +     }
>> +
>> +     case MEMLOCK:
>> +             allow_writes = false;
>> +             return 0;
>> +
>> +     case MEMUNLOCK:
>> +             allow_writes = true;
>> +             return 0;
>
> Please switch to unlocked_ioctl. It should be pretty easy.

will do, thanks

> You should change (and check) allow_writes under the mutex anyway.

not really.  the mutex is to restrict access to the OTP hardware, not
driver state.  because there is none.  access to allow_writes is
atomic in the hardware anyways.

thanks for the review
-mike
