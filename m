Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbYARW62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbYARW62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbYARW6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:58:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:44548 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760153AbYARW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:58:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Xd1JLFVPqP7xYgQ01r0ON30Frp8mqH7dtzrvbMh7diS0+qljArSXpECtmu7o8yOjyCwKQ01NRsn5b5SwqaxJA/fLaCXb+v5DpUyy8rKgeo2xuiZcY4DIp9epcY1uef/6Iiq3IXWEajrCbazHGDUCCBDt/MA6tovJBoRzzZTom54=
Message-ID: <47912F02.6070801@gmail.com>
Date: Sat, 19 Jan 2008 07:58:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
References: <1200445210549-git-send-email-htejun@gmail.com> <1200681668.25782.9.camel@cinder.waste.org>
In-Reply-To: <1200681668.25782.9.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, 2008-01-16 at 10:00 +0900, Tejun Heo wrote:
>> And mprintk the following.
>>
>>  code:
>>   DEFINE_MPRINTK(mp, 2 * 80);
>>
>>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
>>   mprintk_push(&mp, "ATA %d", 7);
>>   mprintk_push(&mp, ", %u sectors\n", 1024);
>>   mprintk(&mp, "everything seems dandy\n");
> 
> I prefer Matthew Wilcox's stringbuf approach which does proper memory
> management and isn't specific to printk:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/0517.html

Yeap, that's generic and nice but I think both 'generic' and 'proper
memory management' are weakness if what you're trying to do is to
support collecting messages in pieces and putting it out via printk.
Please consider the following scenario.

You're in an interrupt handler and detected a severe error condition
which should be notified to the user but the information is rather
complex and best built in pieces, so you create a stringbuf and does
sb_printf() to it w/ GFP_ATOMIC but alas memory allocation failed and
you end up printing "out of memory" unless you detect the failure and go
back and printk messages piece-by-piece manually.  I would rather
assemble the message manually from the get-go into an on-stack buffer.

By being specifially 'printk' and let the user supply buffer, which in
most cases can be on-stack (messages shouldn't be too long anyway),
mprintk either can avoid those problems from the beginning or can
automatically work around when problem arises (initialized with NULL
buffer from allocation failure) without losing any message, so it's
essentially as simple as using printk.  There is no error handling (both
mprintk and kfree can handle NULL pointer) and the message is guaranteed
to go out no matter what.

Auto-expanding string buffer is nice but I don't think it fits the bill
here.

Thanks.

-- 
tejun
