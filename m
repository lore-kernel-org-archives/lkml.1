Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXIQLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXIQLsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXIQLsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:48:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:45430 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXIQLr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Dxvv5CgeOQGW+LM5VmTb5DPHSBi59rK7+t7g7UAY8LKL0WsGrv1rYZrbJus3kkqVFMxuf270+ed5IpxNMsRJLcyUWWxe+AskVt0mmnJHrqG6meYriyCSVO94zb0As4dtyFg3ZS+ASdfn/Xcnc+KYkaPU7S+MRq5SThbtUg5TC5U=
Message-ID: <46EE68F9.9050707@gmail.com>
Date: Mon, 17 Sep 2007 13:46:01 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       Jeff Norden <jeff@math.tntech.edu>, alan@redhat.com,
       linux-kernel@vger.kernel.org, Albert CC Lee <albertcc@tw.ibm.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
References: <200709041607.l84G7KsT032647@norden.math.tntech.edu>	<18141.42848.537873.349518@alkaid.it.uu.se> <20070906013929.1621849d@the-village.bc.nu> <46EE09D3.9010201@gmail.com> <46EE5033.7060708@garzik.org>
In-Reply-To: <46EE5033.7060708@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> [cc'ing Albert and linux-ide]
>>
>> Alan Cox wrote:
>>> /from the media. */
>>>>  > +    if (qc->nbytes < 2048)
>>>>  > +        return -EOPNOTSUPP;
>>>>  > +
>>>>  >      /* No ATAPI DMA in smart mode */
>>>>  >      if (itdev->smart)
>>>>  >          return -EOPNOTSUPP;
>>>>  >
>>>> This looks like a gross hack. Aren't you supposed to inspect
>>>> the command instead and whitelist the ones you know are OK,
>>>> like pata_pdc2027x.c and sata_promise.c do?
>>> It does seem to be about transfer size in the IT821x case not commands.
>>> It may be to do with how we issue ATAPI command transfer sizes from high
>>> up (patch went to Jeff) but for now this is definitely the right
>>> approach
>>>
>>> Reviewed-by: Alan Cox <alan@redhat.com>
>>
>> I wonder whether we should be using similar check in generic path too.
>> We have quite a few cases where MWDMA ATAPI devices choking on commands
>> with small transfer sizes.  I don't think we'll experience significant
>> performance regression with this applied and even if there is some, it's
>> far better to have slightly slower working device.
>>
>> What do you guys think?
> 
> Need to look at, or know, a standard profile of submitted commands. It's
> quite possible some high performance commands want this, where possible.

Yeah, agreed.  I'm quite confused what's going on with all these MWDMA
failures and would really like to know what's broken.  The reason can be
one of the following two.

1. libata itself isn't doing anything wrong but using SCSI for mid and
high level drivers are causing problems as more types of commands are used.

2. Mode programming for MWDMA is broken.  This doesn't seem too likely
as we're seeing MWDMA failures across different low level drivers but is
still a possibility.

However, it's now like drivers/ide drivers didn't have MWDMA problems.
Some drives show similar behavior on IDE too.  It's less noticeable
because IDE is much quicker to downstep to PIO mode.  libata EH logic
definitely can use some improvements here.

I think the correct thing to do regarding command DMA filtering is to
follow what the other OS does.  Apparently, that's all ATAPI device
vendors test against.

Thanks.

-- 
tejun
