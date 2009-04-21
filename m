Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZDUBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZDUBry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZDUBri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:47:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:40771 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZDUBrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f7LW420clkf8BPnOo7o4OHxCyiZOWC4KvEPZ6avP5oixIyhFPw56R/SVzjB1eLdcdJ
         AFImuTmurjSVV9pp7gu5vBY5gaMsMDzziZl5IO0j1dvRfLcU7RQke9Xa/VSr6+pGEAhl
         VehV3iZ2VN+J2bjik//l0tIhLwVOobs7jGkAY=
MIME-Version: 1.0
In-Reply-To: <200904202208.23899.laurent.pinchart@skynet.be>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	 <alpine.LFD.2.00.0904171952260.4042@localhost.localdomain>
	 <20090418125111.6646e997@linux-lm>
	 <200904202208.23899.laurent.pinchart@skynet.be>
Date: Tue, 21 Apr 2009 09:47:34 +0800
Message-ID: <d82e647a0904201847n403424efnb5a0c40a4cac365d@mail.gmail.com>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
From: Ming Lei <tom.leiming@gmail.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/21 Laurent Pinchart <laurent.pinchart@skynet.be>:
> On Saturday 18 April 2009 06:51:11 leiming wrote:
>> On Fri, 17 Apr 2009 19:55:29 -0700 (PDT)
>>
>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> > > @@ -742,7 +742,7 @@ static int uvc_alloc_urb_buffers(struct
>> > > uvc_video_device *video,
>> > >   /* Buffers are already allocated, bail out. */
>> > >   if (video->urb_size)
>> > > -         return 0;
>> > > +         return DIV_ROUND_UP(video->urb_size, psize);
>> >
>> > I don't think this is right. It should round _down_.
>> >
>> > It's supposed to return 'npackets', but if you pass it a different
>> > packet size than it was passed originally, it can now return a
>> > potentially bigger number than the already allocated buffer, no?
>> >
>> > So I think it should round down (ie use a regular divide). No?
>>
>> Yes,you are correct, please ignore my last reply, and following is
>> the fixed patch.
>
> psize and video->urb_size shouldn't have changed before and after resume,
> otherwise we'll get into trouble anyway. A regular divide and a round-up
> divide should then return the same result. I'll take the regular divide, as it
> will be more efficient.

Yes.

>
>> Thanks.
>>
>> From a3b3d72cdd57a0699fb643b41b78eb7beb211ff5 Mon Sep 17 00:00:00 2001
>> From: Ming Lei <tom.leiming@gmail.com>
>> Date: Wed, 15 Apr 2009 22:32:51 +0800
>> Subject: [PATCH] V4L/DVB:usbvideo:fix uvc resume failed(v2)
>>
>> Now urb buffers is not freed before suspend, so uvc_alloc_urb_buffers
>> should return packet counts allocated originally during uvc resume
>> , instead of zero.
>>
>> This version uses round down to return packet counts on Linus's
>> suggestions, or else may lead to buffer destructed if packet size
>> is changed before calling uvc_alloc_urb_buffers() in this kind of
>> case.
>
> The comment is misleading. If the packet size changes we need to reallocate
> the buffers anyway. Have you checked if the packet size (which depends on the
> endpoint being selected) can be changed between suspend and resume, either by
> the uvcvideo driver (I don't think it can) or the USB core ?

The packet size does not change between suspend and resume.  I mean
uvc_alloc_urb_buffers()
still can be used in other cases if buffers was not freed and is
reuesed in future. It seems there is no
such cases in uvcvideo now, but uvc_alloc_urb_buffers() really __can__
 work in such case, isn't it?

IMHO It is only used to allocate or reserve UVC_URBS usb buffers,
which size is video->urb_size, and
npackets can be shortened or enlarged if psize is changed, after all.

Thanks!

-- 
Lei Ming
