Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYD3JYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYD3JYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYD3JY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:24:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60505 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYD3JY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:24:28 -0400
Date: Wed, 30 Apr 2008 11:25:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, mchehab@infradead.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430092500.GA31644@uranus.ravnborg.org>
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu> <20080430.005212.46815036.davem@davemloft.net> <20080430081345.GA16519@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430081345.GA16519@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:13:45AM +0200, Ingo Molnar wrote:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Wed, 30 Apr 2008 09:48:07 +0200
> > 
> > > 
> > > fix allmodconfig build bug introduced in latest -git by commit 
> > > 7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):
> > > 
> > >   LD      kernel/built-in.o
> > >   LD      drivers/built-in.o
> > >   ld: drivers/media/built-in.o: No such file: No such file or directory
> > > 
> > > which happens if all media drivers are modular:
> > 
> > I was seeing this too, as I think was Stephen Rothwell.
> 
> i think any build which has the media drivers only as modules will 
> trigger it, so it's rather widespread. My fix has held up fine for 10 
> randconfigs so far so it should do the trick.
> 
> i'm wondering though why similar problems are not more common. A quick 
> look at drivers/Makefile suggests that there are many obj-y rules there 
> for driver sub-trees that can be all-modular, not just video:
> 
>  obj-y                           += video/
>  obj-y                           += char/
>  obj-y                           += serial/
>  obj-y                           += base/ block/ misc/ mfd/ net/ media/
>  obj-y                           += macintosh/
>  obj-y                           += ieee1394/
>  obj-y                           += cdrom/
>  obj-y                           += auxdisplay/
>  obj-y                           += i2c/
>  obj-y                           += lguest/
>  obj-y                           += firmware/
> 
> drivers/net/ obj-y is kept alive by the "obj-y wireless/" rule i think, 
> but what makes other sub-trees link, like drivers/macintosh/ ?

drivers/media is special because it does not contain any files.
Kbuild will generate a built-in.o file only if there is
a chance for a .o file in the directory.

When all media is modules kbuild does not know enough
to say that a built-in.o is needed in drivers/media/
and the workaround to do a obj-y := common/
is the best way to do so.

We had a similar issue in driver/video once I think.
But here we solved it with the kconfig dependency.
If we only say obj-m += media/ then
kbuild will not try to link a built-in.o.
But if we say obj-y += media/ then kbuild will
expect to find a built-in.o in media/

	Sam
