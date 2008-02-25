Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYBYIRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYBYIRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYBYIQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:16:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:18866 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYBYIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pZANRKre7XPqOh+nRSE0iLBpSBYHrD2drnH5sAy5OMzC1zgcO78pa089KbwCEvq8jYXOeWQyhifUs59tL3fo6sivdfKcD0123oQPOz5AOAV9HmoUYNhGwYNy3xAVfobSOPfrDLe5PcuodFGirrhzWAKL/YjflYo2xavvjqQO3+o=
Message-ID: <47C2796F.2070601@gmail.com>
Date: Mon, 25 Feb 2008 09:16:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       git-dev <git-dev@xilinx.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Xilinx: hwicap: cleanup
References: <1202437061-12691-1-git-send-email-stephen.neuendorffer@xilinx.com> <20080211182429.76E204D8018@mail62-sin.bigfish.com> <fa686aa40802232216s47b7751bi384352697dbf4ce2@mail.gmail.com> <20080224232152.CEC5F12C8057@mail99-dub.bigfish.com>
In-Reply-To: <20080224232152.CEC5F12C8057@mail99-dub.bigfish.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2008 12:21 AM, Stephen Neuendorffer wrote:
>>>  @@ -549,8 +556,7 @@ static int hwicap_release(struct inode *inode,
> struct file *file)
>>>         int i;
>>>         int status = 0;
>>>
>>>  -       if (down_interruptible(&drvdata->sem))
>>>  -               return -ERESTARTSYS;
>>>  +       mutex_lock(&drvdata->sem);
>> Why not mutex_lock_interruptible()? (goes for all cases of
> mutex_lock())
> 
> It's not clear to me how to get 'correct' behavior in these functions if
> the interrupt happens.  For instance in probe/setup, if the mutex_lock
> is interrupted, it doesn't appear that there is anything to do other
> than return an error code that no device is present?  I think this was
> suggested by Jiri...

Yeah, since ERESTARTSYS would be ignored from f_op->release (see __fput()), 
drv->probe (see really_probe() and probe_failed label); not even talking about 
void return value functions. In those cases, the device won't be de/initialized 
and might result in unwanted behaviour (multiple modprobes for one device, 
rmmod/insmod need if you hit the path in release etc.).
