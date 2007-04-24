Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbXDXXy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbXDXXy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXDXXy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:54:28 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52912 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbXDXXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:54:27 -0400
Date: Tue, 24 Apr 2007 17:53:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] use mutex instead of semaphore in RocketPort driver
In-reply-to: <fa.ZWnvY4ypIcIOxuu79yJn6cBDr8M@ifi.uio.no>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
Message-id: <462E9885.1010605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.CH+7gvaumSAVtl/1QOSoYPsXewg@ifi.uio.no>
 <fa.NPDKv3GAx73J43g63faobz7IZVo@ifi.uio.no>
 <fa.ZWnvY4ypIcIOxuu79yJn6cBDr8M@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke wrote:
> El Tue, Apr 24, 2007 at 07:53:04PM +0200 Oliver Neukum ha dit:
> 
>> Am Dienstag, 24. April 2007 19:49 schrieb Matthias Kaehlcke:
>>> @@ -1706,7 +1706,7 @@ static int rp_write(struct tty_struct *tty,
>>>         if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
>>>                 return 0;
>>>  
>>> -       down_interruptible(&info->write_sem);
>>> +       mutex_lock_interruptible(&info->write_mtx);
>> This is a bug. It is also present in the current code, but nevertheless
>> it is a bug. If you use an interruptible lock, you must be ready to deal
>> with interrupts, which are ignored by this code.
> 
> i fear i don't have the experience/knowledge to fix this bug, thanks
> for your remark. 
> 
> i'm a bit confused now about the interruptible locks, i thought using
> them means that the process will be waked up when receiving a
> signal. what role are playing interrupts when using interruptible locks?

You are correct, interrupts aren't involved. However if the wait is 
interrupted by a signal, mutex_lock_interruptible will return a nonzero 
return code which needs to be checked for (and likely -ERESTARTSYS or 
-EINTR returned), otherwise the code will blindly continue as though it 
has locked the mutex even though it has not.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

