Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXINTVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXINTVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbXINTUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:20:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:44973 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXINTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Rxex+Bw5QwrlhTam7F5y/eL7eQedFWSz0+B+GinZ6OVJ/fnlqHMRxuG56sb5dMyB6uieNOxMBPfayJMNQQN6x3zjjzGxf7aahqIROlnOOaDiRx4D0Pm5PZKZQTFaccUoBZe9KuXosyw0RN1fpZwQTlwwSxtaj/KB1CIWHv8sxRU=
Message-ID: <37219a840709141220p543b0da9x53f48eabc1cfe8c9@mail.gmail.com>
Date: Fri, 14 Sep 2007 15:20:51 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <1189794551.2363.36.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <1189791161.2363.8.camel@gaivota>
	 <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>
	 <1189794551.2363.36.camel@gaivota>
X-Google-Sender-Auth: 6ecd6fabc3a3a83c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > - The hybrid tuner support, that where your requirement, when all those
> > > discussions started, were already added to the subsystem. So now, an
> > > hybrid tuner can be accessed by both DVB and V4L devices;
> > >
> >
> > It's far more complex as the thing which is implemented there.
> > The only thing that has been implemented is that one moduleformat
> > can be loaded by the v4l and by the dvb framework nothing else at the
> > moment. I told you at the kernel summit about that and I think you
> > knew about that before.
> >
> > Just to quote some text:
> > "Right now, a separate instance of the driver is used for analog /
> > digital tuning.  In order to use a single instance, we will have to
> > store a pointer to the dvb_frontend structure on the bridge level, but
> > there are various other prerequisites that must be dealt with before we
> > get to that point.
> >
> > We _will_ get there though, eventually."
>
> Maybe it is still not perfect. Feel free to improve it. Several people
> from the community, including me, already offered you help to add your
> driver, reworking on the 5% of the stuff that aren't compatible with the
> V4L/DVB core API design.

For clarification, Markus is quoting me, above.

The idea is to eventually store a pointer to the dvb_frontend
structure on the bridge level to be used as a single entry point
between the analog and digital subsystems.  However, we are not yet
ready for this, as the refactoring process has a lot more to be done
beforehand.

Phase 1 of the refactoring was to implement the core changes required
for a single module to be used by both v4l and dvb, and to convert the
existing tuner modules to the new internal API.

Phase 2, a work in progress, involves the removal of duplicated code.
For example, the current code in the master branch still has tda8275 /
tda8275a analog code inside of tda8290.c, where the digital tuning
code is in tda827x.c ...  This was resolved in this changeset:

Move all tda8275/8275a tuning code from tda8290 module into tda827x module
http://linuxtv.org/hg/~mkrufky/philipsNXP/rev/09c2e16a8cdd

This code is working fine, and I have it pushed to linuxtv.org for the
sake of testing.  I have not requested merge to master because I still
have some cleanups to do, and I do not want this to go to 2.6.24.

(side note: basic support for TDA8295 + TDA18271 has been added to my
philipsNXP tree, as well)

Tuner-simple and dvb-pll will have to undergo a similar treatment, and
it's not going to happen overnight.  But I *am* working on it.

I've outlined a basic roadmap to the refactoring plans in my original RFC:
http://linuxtv.org/pipermail/linux-dvb/2007-August/019950.html

What I didn't mention in that RFC, however, is the method in which I
plan to remove the multiple instantiations of the tuner code for a
single piece of hardware, by moving the dvb_frontend pointer to the
bridge level.  Since this change depends on the other refactoring to
be completed first, I found it unnecessary to explain this in detail
at this point.

When the time comes, a new RFC will be sent out to deal with that matter.

There is no reason why the Xceive driver cannot be merged into the
current development tree using the hybrid tuner framework as it stands
today.

Regards,

Mike
