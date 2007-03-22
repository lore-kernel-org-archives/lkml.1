Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXCVPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXCVPxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXCVPxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:53:48 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:3937 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbXCVPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:53:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoUALJDAkZKhRO4UGdsb2JhbACHL4dsAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: johann deneux <johann.deneux@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Date: Thu, 22 Mar 2007 11:50:11 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Slaby <jirislaby@gmail.com>,
       "\"STenyaK (Bruno =?iso-8859-1?q?Gonz=E1lez?=)\"" <stenyak@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
References: <2460126662758025813@fi.muni.cz> <46018FB8.1080601@gmail.com> <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com>
In-Reply-To: <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221150.12403.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 18:03, johann deneux wrote:
> On 3/21/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > Dmitry Torokhov napsal(a):
> > > On 3/21/07, johann deneux <johann.deneux@gmail.com> wrote:
> > >> I would suggest adding a new effect type (3d effect) and extending the
> > >> union in struct ff_effect.
> > >> Let me know if I'm too vague, I already suggested that solution but
> > >> got no answer. I wonder if my mail got lost, nobody understood what I
> > >> said, or if it's just a plain bad idea.
> > >>
> > >
> > > My concern with a new 3D effect is that it will be a very "simple"
> > > effect with only constant force apllied. That might be enough for
> > > phantom but may not be sufficient for future devices. If we add
> > > ability to specify a "plane" for an effect we will be able to add
> > > envelopes on top of more complex effects and get desired combined
> > > effcet.
> >
> > I didn't get this too much, because I don't understand the FF layer well so
> > far. How is this going to work? Let's say, we have 3 torque values computed
> > in US, and this structure:
> >
> > struct ff_effect {
> >     __u16 direction;
> >     struct ff_trigger trigger;
> >     struct ff_replay replay;
> >
> >     struct ff_constant_effect {
> >         __s16 level;
> >         struct ff_envelope {
> >              __u16 attack_length;
> >              __u16 attack_level;
> >              __u16 fade_length;
> >              __u16 fade_level;
> >         };
> >     };
> > };
> >
> > and need to pass the three 16bits torques into s16 ioaddr[0..2]. How?
> >
> 
> Stupid question, I have forgotten the details of ioctl: Wouldn't the
> following work?
> 
> struct ff_effect {
>         __u16 type;
>         __s16 id;
>         __u16 direction;
>         struct ff_trigger trigger;
>         struct ff_replay replay;
> 
>         union {
>                 struct ff_constant_effect constant;
>                 struct ff_ramp_effect ramp;
>                 struct ff_periodic_effect periodic;
>                 struct ff_condition_effect condition[2]; /* One for each axis */
>                 struct ff_rumble_effect rumble;
>         } u;
> 
>         /* New member: Specify a plane in the 3d space. */
>         struct ff_ruct ff_plane plane;
> };
> 
> Would that pose compatibility issues? If the input layer knows the
> size of the struct the user-space application is sending, it knows if
> it's safe to look into the "plane" member. If it is, and the device
> driver is capable of handling 3d effects, then fine. If it is but the
> device driver can't handle it, return an error code. If it isn't, just
> do whatever it's currently doing.

No, the kernel would not know that there is more data unless we add a new
ioctl number.

> 
> Alternatively, one could leave ff_effect effect untouched and find
> another way to specify the plane, e.g. another ioctl.

I was thinking about a new ioctl to specify a plane for a specific effect,
but probably extending the structure and having 2 distinct ioctls (with
and without plane) is cleaner.

-- 
Dmitry
