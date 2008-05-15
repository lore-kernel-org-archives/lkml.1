Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYEOJzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYEOJzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYEOJy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:54:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:6934 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYEOJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f2tBWNkXtueHYaNqLwCX5cNeMgx5GnfhnZSFpb8uqUhKlBOfAChwDNB/WcAvKS+PyKSq0nU5YZ4iFY7IuW8wVFnLS7dLnRNFXS2tVLRSo4keMWyFRwE4g0ai9IaBt3tyvfQPdSh7bq1x23JNyn5Kcco+HQiRCHYeJytOoAQVCcs=
Message-ID: <386072610805150254p6161627er9f99910066287f2f@mail.gmail.com>
Date: Thu, 15 May 2008 17:54:51 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Jie Zhang" <jie.zhang@analog.com>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Cc: "Oliver Neukum" <oliver@neukum.org>, harvey.harrison@gmail.com,
       david-b@pacbell.net, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <482BFF2C.4090506@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
	 <200805150940.34516.oliver@neukum.org> <482BEE57.6040704@analog.com>
	 <200805151036.09386.oliver@neukum.org> <482BFF2C.4090506@analog.com>
X-Google-Sender-Auth: 4e1237af34b002a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 5:15 PM, Jie Zhang <jie.zhang@analog.com> wrote:
> Oliver Neukum wrote:
>>
>> Am Donnerstag 15 Mai 2008 10:03:35 schrieb Jie Zhang:
>>>
>>> Oliver Neukum wrote:
>>>>
>>>> Am Donnerstag 15 Mai 2008 08:19:24 schrieb Bryan Wu:
>>>>>
>>>>> --- a/drivers/usb/host/uhci-hub.c
>>>>> +++ b/drivers/usb/host/uhci-hub.c
>>>>> @@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd,
>>>>> u16 typeReq, u16 wValue,
>>>>>        switch (typeReq) {
>>>>>          case GetHubStatus:
>>>>> -               *(__le32 *)buf = cpu_to_le32(0);
>>>>> +               put_unaligned_le32(0, buf);
>>>>
>>>> What is supposed to make all these changes a good idea?
>>>>
>>> Since buf might not be 4-byte aligned.
>>
>> It is. Please analyze the code before you use these access methods.
>>
> You are right. buf has been 4-byte aligned since 2.6.19. My patch was
> written two years ago. Sorry for the noise I caused.
>

I has keeping this patch for a long time.  Jie fixed this patch at
2006/09/20 in our svn:
http://blackfin.uclinux.org/git/?p=readonly-mirrors/linux-kernel.git;a=commit;h=cb3da1243f84b37b53486c7e86da34565b4c5d92
http://blackfin.uclinux.org/git/?p=readonly-mirrors/linux-kernel.git;a=commit;h=2559298f0dca2cffc0b87390b92a484004f0d85e

And a similar patch from David Miller was accept in ohci-hub.c
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=92164c5dd1ade33f4e90b72e407910de6694de49

Also because of the same issue, which was fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=54bee6e1b455573658972510a76119f279db32b7

If other functions not only rh_call_control() call this hub_control()
pointer and the buf is not 4-byte aligned,
this bug will fire again without the unaligned API. This patch is
safer for the caller, although not efficient.

-Bryan
