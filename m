Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbXBJPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbXBJPsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 10:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbXBJPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 10:48:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:58431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbXBJPso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 10:48:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: compat_ioctl (was [PATCH update] ieee1394: cycle timer read extension for raw1394/libraw1394)
Date: Sat, 10 Feb 2007 16:47:56 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pieter Palmers <pieterp@joow.be>,
       Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net
References: <45BA5CFD.6070900@joow.be> <tkrat.e06f68103e99e517@s5r6.in-berlin.de> <45CDD490.2020004@s5r6.in-berlin.de>
In-Reply-To: <45CDD490.2020004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702101647.59339.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18PukXmCkwz24f4x57C/nBVqQOnErCZ3UvWM0Pzi8lBsT61U5bLxQzzULZqBE5cDVSGvx1osQjIhztB8D7nFKiX3brxLUtVjiJMA2Z93USsIw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 15:20, Stefan Richter wrote:
> 
> I wrote on 2007-02-03:
> > +#define RAW1394_IOC_GET_CYCLE_TIMER          \
> > +     _IOR ('#', 0x30, struct raw1394_cycle_timer)
> ...
> > +/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> > +struct raw1394_cycle_timer {
> > +     /* contents of Isochronous Cycle Timer register,
> > +        as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
> > +     __u32 cycle_timer;
> > +
> > +     /* local time in microseconds since Epoch,
> > +        simultaneously read with cycle timer */
> > +     __u64 local_time;
> > +};
> >  #endif /* IEEE1394_RAW1394_H */
> 
> Hmm, is this struct padded on 64bit platforms?
> If so, would
>         struct raw1394_cycle_timer {
>                 __u64 local_time;
>                 __u32 cycle_timer;
>         };
> be padded too?

If one of these two is padded on a given CPU, the other one is as well,
because the structure alignment is defined as the maximum alignment
of one of its members (this is needed so that arrays work).

Both are padded on all 64 bit architectures that Linux runs on, but
on x86, you get the extra twist that the 32 bit version does not
have padding. To express the right structure for compat mode, you 
need something like

#ifdef __x86_64__
typedef u64 compat_u64 __attribute__((packed, aligned(4)));
#else
typedef u64 compat_u64;
#endif
struct raw1394_cycle_timer {
        compat_u64 local_time;
        u32 cycle_timer;
};

	Arnd <><
