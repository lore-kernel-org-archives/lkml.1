Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbYJMJo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbYJMJo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbYJMJhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:37:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:62902 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186AbYJMJhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NIgGTNiPmaQAUDz5oPLkv9C6i6hYtt3IJNPz6Gi7ywZX8YnvJpV6mZSqQgIRF/6Psy
         J2U/hOSegTQaJf3pjpiSrDluoCesRjmDhMtaZdM6oQV+kXpL8zYeUhtprtHQ1q9Yj8PT
         UGlGrar/wB8/AQSOk5IuQ3uM/zLPA5WL4r1qw=
Message-ID: <48F316C4.1070603@gmail.com>
Date: Mon, 13 Oct 2008 11:37:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: sam@ravnborg.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin OTP Char Driver: add writing support of
 OTP
References: <1223889199-31658-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1223889199-31658-1-git-send-email-cooloney@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2008 11:13 AM, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>

Some changelog please.

> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
[...]
> @@ -123,18 +132,95 @@ static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t
>  	if (mutex_lock_interruptible(&bfin_otp_lock))
>  		return -ERESTARTSYS;
>  
> -	/* need otp_init() documentation before this can be implemented */
> +	stampit();
> +
> +	timing = bfin_otp_init_timing();
> +	if (timing == 0) {
> +		mutex_unlock(&bfin_otp_lock);
> +		return -EIO;
> +	}
> +
> +	base_flags = OTP_CHECK_FOR_PREV_WRITE;
> +
> +	bytes_done = 0;
> +	page = *pos / (sizeof(u64) * 2);
> +	while (bytes_done < count) {
> +		flags = base_flags | (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
> +		stamp("processing page %i (0x%x:%s) from %p", page, flags,
> +			(flags & OTP_UPPER_HALF ? "upper" : "lower"), buff + bytes_done);
> +		if (copy_from_user(&content, buff + bytes_done, sizeof(content))) {
> +			bytes_done = -EFAULT;
> +			break;
> +		}
> +		ret = bfrom_OtpWrite(page, flags, &content);
> +		if (ret & OTP_MASTER_ERROR) {
> +			stamp("error from otp: 0x%x", ret);
> +			bytes_done = -EIO;
> +			break;
> +		}
> +		if (flags & OTP_UPPER_HALF)
> +			++page;
> +		bytes_done += sizeof(content);
> +		*pos += sizeof(content);

What happens to pos if it fails later?

> +	}
> +
> +	bfin_otp_deinit_timing(timing);
>  
>  	mutex_unlock(&bfin_otp_lock);
>  
> +	return bytes_done;
> +}
> +
> +static int bfin_otp_ioctl(struct inode *inode, struct file *filp,
> +                          unsigned cmd, unsigned long arg)
> +{
> +	stampit();
> +
> +	switch (cmd) {
> +	case OTPLOCK: {
> +		u32 timing;
> +		int ret = -EIO;
> +
> +		if (!allow_writes)
> +			return -EACCES;
> +
> +		if (mutex_lock_interruptible(&bfin_otp_lock))
> +			return -ERESTARTSYS;
> +
> +		timing = bfin_otp_init_timing();
> +		if (timing) {
> +			u32 otp_result = bfrom_OtpWrite(arg, OTP_LOCK, NULL);
> +			stamp("locking page %i resulted in 0x%x", arg, otp_result);
> +			if (!(otp_result & OTP_MASTER_ERROR))
> +				ret = 0;
> +
> +			bfin_otp_deinit_timing(timing);
> +		}
> +
> +		mutex_unlock(&bfin_otp_lock);
> +
> +		return ret;
> +	}
> +
> +	case MEMLOCK:
> +		allow_writes = false;
> +		return 0;
> +
> +	case MEMUNLOCK:
> +		allow_writes = true;
> +		return 0;

Please switch to unlocked_ioctl. It should be pretty easy. You should change
(and check) allow_writes under the mutex anyway.

> +	}
> +
>  	return -EINVAL;
