Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZDRDvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZDRDvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 23:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZDRDvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 23:51:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:11807 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZDRDvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 23:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Q4hr8Xr9yiSQFzIYUou+smZo7UCMxtmvanDIRKIFLDvsp1NK61UGb9Gz+eqZdwswqh
         FSN5W9/zRXXX9473VJhq7LKX8QajuMj6p6rf6WFCjiU4kSuSSw2ThQAV74+j9MB0tVbC
         8jx0AtEGK8VEbod8fxkrnFEiHEWP5EihwBjvc=
Date: Sat, 18 Apr 2009 11:50:51 +0800
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
Message-ID: <20090418115051.175f292f@linux-lm>
In-Reply-To: <alpine.LFD.2.00.0904171952260.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com>
	<200904172336.12414.rjw@sisk.pl>
	<20090418103226.54250420@linux-lm>
	<alpine.LFD.2.00.0904171952260.4042@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 19:55:29 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> @@ -742,7 +742,7 @@ static int uvc_alloc_urb_buffers(struct
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

Now uvc only uses the previous allocated buffer in suspend/resume
path, so the packet size doen't change in this path.

> potentially bigger number than the already allocated buffer, no?

If this case does exist, the URBs need to be updated and the patch is 
not enough. 

> 
> So I think it should round down (ie use a regular divide). No?

Because the following fact:

	uvc_alloc_urb_buffers()
	{
		...
		video->urb_size = psize * npackets; 
		...
	}

so DIV_ROUND_UP still can work correctly.

Thanks!

-- 
Lei Ming
