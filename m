Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYE1Aqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYE1Aqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYE1Aq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:46:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:62442 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYE1Aq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dLcwODW4eD4NwR4Tc5pp8p6Fnc609IYSTTQstfkc0l7OGhGtFLi/eJfBImSXS9xddSob4k55iXm4odwV2FQ+V4aC9hkh9OUZlwtfRhPOeQqwAEZkpFAi5gmwbbATRtE61YmfjZ63yS2VFE+oTRcGoHfNbeeUiOmAf8LfOtGbOeQ=
Message-ID: <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
Date: Tue, 27 May 2008 20:46:22 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Andy Walls" <awalls@radix.net>
Subject: Re: [PATCH] video4linux: Push down the BKL
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Alan Cox" <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jonathan Corbet" <corbet@lwn.net>
In-Reply-To: <1211932138.3197.29.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522223700.2f103a14@core>
	 <20080526220154.GA15487@devserv.devel.redhat.com>
	 <20080527101039.1c0a3804@gaivota>
	 <20080527094144.1189826a@bike.lwn.net>
	 <20080527133100.6a9302fb@gaivota>
	 <20080527103755.1fd67ec1@bike.lwn.net>
	 <20080527155942.7693c360@gaivota>
	 <412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	 <20080527180048.6a27dbf7@gaivota>
	 <1211932138.3197.29.camel@palomino.walls.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

On Tue, May 27, 2008 at 7:48 PM, Andy Walls <awalls@radix.net> wrote:
> MythTV's mythbackend can open both sides of the card at the same time
> and the cx18 driver supports it.  On my HVR-1600, MythTV may have the
> digital side of the card open pulling EPG data off of the ATSC
> broadcasts, when I open up the MythTV frontend and start watching live
> TV on the analog side of the card.  MythTV also supports
> Picture-in-Picture using both the analog and digital parts of the
> HVR-1600.

In this case, what you see as a 'feature' in MythTV is actually a
problem in our case.  While the HVR-1600 can support this scenario,
the HVR-950 can only use one or the other (the em28xx chip uses GPIOs
to enable the demodulator and presumably you should never have both
demodulators enabled at the same time).  Because of this we need a
lock.  If MythTV only opened one device or the other at a time, we
could put the lock on the open() call, but since MythTV opens both
simultaneously even though it may only be using one, we would need a
much more granular lock.

Certainly I'm not blaming MythTV for this behavior, but it will make
the locking much more complicated in some hybrid devices.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
