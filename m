Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXHJXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXHJXTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXHJXTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:19:14 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:47494 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXHJXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:19:13 -0400
Date: Fri, 10 Aug 2007 16:19:12 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Markus Rechberger <mrechberger@gmail.com>
cc: Manu Abraham <abraham.manu@gmail.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb_frontend_ioctl(): fix
 check-after-use
In-Reply-To: <d9def9db0708101047u27c939a4ve57b28cf4319aaf2@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0708101546170.26791@shell4.speakeasy.net>
References: <20070730222817.GE3972@stusta.de>
 <1a297b360707312052l14adb72el8ee59c74b7757605@mail.gmail.com>
 <d9def9db0708101047u27c939a4ve57b28cf4319aaf2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Markus Rechberger wrote:
> On 8/1/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > On 7/31/07, Adrian Bunk <bunk@stusta.de> wrote:
> > > The Coverity checker spotted that we have already oops'ed if "fe" was
> > NULL.
> > >
> > > --- linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c.old
> > > +++ linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c
> > > @@ -706,11 +706,11 @@ static int dvb_frontend_ioctl(struct ino
> > > -       if (!fe || fepriv->exit)
> > > +       if (fepriv->exit)
> > >                 return -ENODEV;
>
> This issue has been known for a while including some other problems at
> that part.
>
> http://article.gmane.org/gmane.linux.drivers.dvb/35351/match=patch+dvb_net+hotplugging+support
>
> this includes a link where this and more got discussed in May.

For dvb_net_close, I like the patch I already posted better.  To fix the
check-after-use, it's not "use" part that's the problem, it's the "check" part
that isn't necessary.

I traced the dvb-net code, http://article.gmane.org/gmane.linux.kernel/543689,
and I'm sure that dvbdev can't be NULL.

My patch also deletes a few pieces of duplicated code by calling
dvb_generic_release().

The only problem is that practically no one uses dvb-net, so it's very hard to
test these patches.

In all the dvb code, were is the locking for device open and release?  I don't
see it.  What is preventing two threads from trying to open and/or close the
same dvb device at the same time?
