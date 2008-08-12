Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYHLTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYHLTZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYHLTYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:24:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:38451 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYHLTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=AJ1ZS+OE1w53dFR7R3y+JbEzyjBnIAMrkbMUbrq3QAKHxDQSzT59jak3G77/lXRfDs
         /IjYCS5YE/RE0MMOd4n2oGiOfJPIoH8BIFOYx28YiE2zZwx5Yh/c7n6VjDLK0Ezs/i72
         xko8gnTAIVzr8YasyiR99ZiYGI6tk4edzlVkM=
Message-ID: <ea8d860a0808121224y63bd4178xe0c74d5fb3e34180@mail.gmail.com>
Date: Tue, 12 Aug 2008 20:24:51 +0100
From: "Marcin Obara" <marcin_obara@users.sourceforge.net>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] Intel Management Engine Interface
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48A1B71C.6080201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl>
	 <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl>
	 <20080811215340.2c0635dd.akpm@linux-foundation.org>
	 <48A1B71C.6080201@gmail.com>
X-Google-Sender-Auth: df5f45f5ba84ba37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/12 Jiri Slaby <jirislaby@gmail.com>:
> On 08/12/2008 06:53 AM, Andrew Morton wrote:
>>
>> On Mon, 11 Aug 2008 21:23:01 +0200 (CEST)
>> Marcin Obara <marcin_obara@users.sourceforge.net> wrote:
>>> +#define     ECORRUPTED_MESSAGE_HEADER    1000
>>> +#define     ECOMPLETE_MESSAGE            1001
>>
>> What's this?  The driver defines its onw errno numbers?
>>
>> Are these ever returned to userspace?
>>
>> This is risky/confusing/misleading, isn't it?
>
> Yes and already pointed out. This leaks to userspace and it's wrong. Please
> go and read my comments to version #1 once again and if you don't understand
> anything, please drop a message, but do not silently ignore others'
> comments.

Sorry.
I will try to explain.
This source code was designed few years ago and there is already
written userspace software.
Removal of driver internal error codes may affect software.
I think it is more risky than keeping these own errno numbers.

>
> E.g. unlocked_ioctl switch hasn't been done plus other things mentioned
> below too (not all of them)
>
unlocked_ioctl would require to add lock as big kernel lock replacement.
It is risky in such complex code, especially if speed increase is not expected.


>>> +       spin_lock_bh(&dev->device_lock);
>>> +       dev->wd_timer.function = &heci_wd_timer;
>>> +       dev->wd_timer.data = (unsigned long) dev;
>>> +       spin_unlock_bh(&dev->device_lock);
>>
>> Use setup_timer().
>>
>> Note that setup_timer() does init_timer(), but we already have an
>> init_timer(dev->wd_timer) elsewhere.  Please sort that out.
>
> Already commented, left unchanged and without an explanation.

Sorry.
Explanation:
 We don't want to init_timer() here. It is done later, to avoid race condition.
We only configure timer, but we are not ready to start it.

>
>>> +/* IOCTL commands */
>>> +#define IOCTL_HECI_GET_VERSION \
>>> +    _IOWR('H' , 0x0, struct heci_message_data)
> ... and conflicts with hid as I commented before.

Sorry for missing explanations.
This conflict can't be avoided, because there is already written
software that depends on these ioctl definitions.

-- 
Regards
Marcin
