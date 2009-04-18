Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZDREvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZDREvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 00:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZDREvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 00:51:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:11360 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDREv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 00:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pQBb2yA8vsMV1RMolOibuszUFgBdLAOSw6SXWia4hFGYtvcjG5vXlSnWjg8/elydfb
         2TGFeUOnj3BGD+r3FBUMmZ0Btnr359LHB60rx2UMsWRFFkkalG7dWmYqOucMvZWG8/Fw
         NhQUHYBNW0T9BCB84Bo9Mlj3OaiqjSPErYExo=
Date: Sat, 18 Apr 2009 12:51:11 +0800
From: leiming <tom.leiming@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, laurent.pinchart@skynet.be,
       mchehab@infradead.org
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Message-ID: <20090418125111.6646e997@linux-lm>
In-Reply-To: <alpine.LFD.2.00.0904171952260.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com>
	<200904172336.12414.rjw@sisk.pl>
	<20090418103226.54250420@linux-lm>
	<alpine.LFD.2.00.0904171952260.4042@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 19:55:29 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > @@ -742,7 +742,7 @@ static int uvc_alloc_urb_buffers(struct
> > uvc_video_device *video, 
> >  	/* Buffers are already allocated, bail out. */
> >  	if (video->urb_size)
> > -		return 0;
> > +		return DIV_ROUND_UP(video->urb_size, psize);
> 
> I don't think this is right. It should round _down_.
> 
> It's supposed to return 'npackets', but if you pass it a different
> packet size than it was passed originally, it can now return a
> potentially bigger number than the already allocated buffer, no?
> 
> So I think it should round down (ie use a regular divide). No?

Yes,you are correct, please ignore my last reply, and following is
the fixed patch.

Thanks.

>From a3b3d72cdd57a0699fb643b41b78eb7beb211ff5 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 15 Apr 2009 22:32:51 +0800
Subject: [PATCH] V4L/DVB:usbvideo:fix uvc resume failed(v2)

Now urb buffers is not freed before suspend, so uvc_alloc_urb_buffers
should return packet counts allocated originally during uvc resume
, instead of zero.

This version uses round down to return packet counts on Linus's
suggestions, or else may lead to buffer destructed if packet size
is changed before calling uvc_alloc_urb_buffers() in this kind of
case.

This patch is against v2.6.30-rc2.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/media/video/uvc/uvc_video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index a95e173..6ce974d 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -742,7 +742,7 @@ static int uvc_alloc_urb_buffers(struct uvc_video_device *video,
 
 	/* Buffers are already allocated, bail out. */
 	if (video->urb_size)
-		return 0;
+		return video->urb_size / psize;
 
 	/* Compute the number of packets. Bulk endpoints might transfer UVC
 	 * payloads accross multiple URBs.
-- 
1.6.0.GIT





-- 
Lei Ming
