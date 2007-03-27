Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbXC0JxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbXC0JxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXC0JxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:53:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:61991 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbXC0JxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ify1pI0TLmNUDKgGAwa971rnrX8XhvqD7Xbr/Oirp+f2q/62WE3vbve5o0niHSIHfsal2w+chTmYIfyMxFxnnpRVCsK1yERYFtAzx1wIxxeSGLsliPfs2LrbsYLR+R+m9wxlvKkw452I28YEmWgub6DEzo3AbgTNTZcyFVzS/SA=
Message-ID: <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com>
Date: Tue, 27 Mar 2007 17:53:12 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
Cc: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45F93888.1080207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>
	 <45F7E7E9.6010703@gmail.com>
	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>
	 <45F93888.1080207@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Tejun Heo <htejun@gmail.com> wrote:
> Conke Hu wrote:
> >> E  Internal error: The host bus adapter experienced an internal error
> >> that caused the operation to fail and may have put the host bus adapter
> >> into an error state. Host software should reset the interface before
> >> re-trying the operation. If the condition persists, the host bus adapter
> >> may suffer from a design issue rendering it incompatible with the
> >> attached device.
> >>
> >
> > Yes, I saw this too :) and I am contacting the hardware engineers to
> > check if there is any hardware bug.
> > But, even though this were a hardware bug and could be fixed, we would
> > still need this patch since many SB600 boards have already come into
> > the market and those ASICs can never be fixed :(
>
> Yeap, we certainly need the workaround.  I was just having a little fun.
>  :-)
>
> >> 4381 isn't affected while 4380 is?
> >
> > I never see such an ID, and plan to remove 0x4381.
> > The patch which added the PCI IDs was not sent out by myself. I
> > checked all SB600 boards, and not found any 0x4381 controller, only
> > 0x4380 instead. In fact, SB600 RAID and Non-RAID share the same PCI
> > device ID, only with class code different.
>
> I see.
>
> >> Anyways, Conke Hu, can you please take a look at my patch from a month
> >> ago?  It's almost identical but SERR_INTERNAL is always ignored on both
> >> SB600 PCI IDs, which I think is safer.  Does this fix what you're seeing?
> >>
> >
> > I just read your patch. Another difference is that my patch ignores
> > SERR_INTERNAL only when the command is ATAPI and IRQ_TF_ERR occurs. In
> > other cases, I think, we'd better not ignore the SERR_INTERNEL. Right?
>
> Yeah, I noticed the difference.  I don't really care but I was thinking
> that SERR_INTERNAL might be set in other similar situations too.  e.g.
> TF error from ATA device or what not, so I thought it would be safer to
> ignore the bit altogether.  You probably need to consult your hardware
> people about when exactly the bit misbehaves but unless proven
> otherwise, I'd prefer to always ignore the bit.  Also, please rename the
> enum constant and flag name.
>

Thank you, Tejun!
I was discussing with our HW designers on this topic. It is a HW
design issue and will be fixed in SB700, the next generation of
AMD/ATI southbridge.

The correct walkaround/solution for SB600 SATA is:
1. ignore SERR_INTERNAL for both ATA and ATAPI device (as you suggested :p ).
2. ignore SERR_INTERNAL only on IRQ_TF_ERR.

I'll re-create the patch.

Conke
