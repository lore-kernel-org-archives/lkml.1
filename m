Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXDRNVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXDRNVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992442AbXDRNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:21:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:3178 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992450AbXDRNVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g4/ZTx6RhqMdB815tEudN+gruorO+uWGjBTKbHzwxBSDw2FyuthufxJnh9x8o2X4Kiy5JzLzpkWZ/MjteB3gWKn+9vLX4wC6T1EVg0Iw5BEa8WV+tV5AGvfdArQpJ4+RGx5eOOrCygndLghzoeWDLR0cfZL92wNVZcNRg18koJ4=
Message-ID: <19a3b7a80704180621m1b343b4eif02a7930a5edf2fc@mail.gmail.com>
Date: Wed, 18 Apr 2007 15:21:17 +0200
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Kaffeine problem with CFS
Cc: "=?ISO-8859-9?Q?S.=C7a=F0lar_Onur?=" <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
	 <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com>
	 <20070418091714.GA23446@elte.hu>
	 <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com>
	 <20070418092805.GA23125@elte.hu>
	 <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com>
	 <19a3b7a80704180304u72cc6612w2e6e0811226f1a52@mail.gmail.com>
	 <20070418101041.GA30643@elte.hu>
	 <19a3b7a80704180534w3688af87x78ee68cc1c330a5c@mail.gmail.com>
	 <19a3b7a80704180555q4e0b26d5x54bbf34b4cd9d33e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/18, Christoph Pfister <christophpfister@gmail.com>:
> [ Sorry for accidentally dropping CCs ]
>
> 2007/4/18, Christoph Pfister <christophpfister@gmail.com>:
> > 2007/4/18, Ingo Molnar <mingo@elte.hu>:
> > >
> > > * Christoph Pfister <christophpfister@gmail.com> wrote:
> > >
> > > > Or I could try playing around a bit with your patchset and trying to
> > > > reproduce it over here. Because I already have debug builds for
> > > > xine-lib and compiling a new kernel can take place in the background
> > > > it wouldn't be much effort for me.
> > >
> > > that would be great :) Here are the URLs for it. CFS is based on
> > > v2.6.21-rc7:
> > >
> > >   http://kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.21-rc7.tar.bz2
> > >
> > > And the CFS patch is at:
> > >
> > >   http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.patch
> > >
> > > rebuild your kernel as usual and boot into it. No extra configuration is
> > > needed, you'll get CFS by default.
> > >
> > > if this kernel builds/boots fine for you then you might also want to
> > > send me a quick note about how it feels, interactivity-wise. And of
> > > course i'm interested in any sort of feedback about problems as well.
> > > I'd like to make CFS as media-playback friendly as possible, so if
> > > there's any problem in that area it would be nice for me to know about
> > > it as soon as possible.
> > >
> > >         Ingo
> >
> > Okay - so here are some results (it's strange that gdb goes nuts
> > inside the xine_play call). I have three bts (seems to be fairly easy
> > to reproduce that behaviour over here): Twice while playing an audio
> > cd and once while playing a normal file. The hang usually ends if you
> > wait long enough (something around 30 secs over here).

<big snip>

> > Christoph
> >
> >
> > PS: Haven't analyzed them yet - but doing so now :-)
>
> Ok - one nice thing: In all those bts demux_loop is at demux.c:285 -
> meaing that demux_lock is held and xine_play is waiting for it ...
> The lock should be temporilary unreleased with a sched_yield so that
> the main thread can access it. As you wrote the implementation of this
> function seems to have changed a bit - so I'll replace it with a short
> sleep and try again ...
>
> Christoph

Replacing the sched_yield in demux.c with an usleep(10) stopped those
seeking hangs here (at least I was able to pull the slider back and
forth during 2 mins without trouble compared to the few secs I need
earlier to get a hang).

Christoph
