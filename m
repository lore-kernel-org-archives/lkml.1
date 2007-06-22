Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXFVVAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXFVVAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXFVVAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:00:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45629 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbXFVVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AVjtoJVFYVzjrBbYuRXIGxbSfNU9Okj4IO+ap90ipNSYGLDJTIRimp+FnlDDXV5nvwO5bqNhH70KZ7W14o/mmedYvGtJtawObRWxm0b8m5xo70mrCUug8BSVx/0J0cUer9yHOOW71Sr2Ow+XjRQChLYW1Yf7GGM3GDulp1SMY4A=
Message-ID: <a781481a0706221400o613fe6a6ib1cdb066057f31a6@mail.gmail.com>
Date: Sat, 23 Jun 2007 02:30:31 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Oliver Neukum" <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       "=?UTF-8?Q?Toralf_F=EF=BF=BDrster?=" <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0706221317q3dd49905j8773b2f8a96ad63b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
	 <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.64.0706221602000.1817@scrub.home>
	 <Pine.LNX.4.64.0706221711320.26568@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0706221735270.1817@scrub.home>
	 <Pine.LNX.4.64.0706221842220.26568@fbirervta.pbzchgretzou.qr>
	 <a781481a0706221317q3dd49905j8773b2f8a96ad63b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Jan,
>
> On 6/22/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> > On Jun 22 2007 18:24, Roman Zippel wrote:
> > >
> > >> There have been discussions to remove the default-ys again, I've sent a patch
> > >> [http://lkml.org/lkml/2007/5/12/216], but nothing happened.
> > >>
> > >> So, should all affected menuconfigs be transformed into tristates, what
> > >> do you think, Roman? Let me know so I can cook up a patch (hopefully
> > >> before 2.6.22) should they become tristate.
> > >
> > >Using bool is clearly a bug and I'd prefer if it removed the defaults as
> > >well.
> >
> > What I don't quite understand is, that CONFIG_CRYPTO is also a bool,
> > its subparts are tristates however, and there is no problem involved
> > with these.
>
> That's because neither CONFIG_CRYPTO nor any of the crypto modules
> depend on another symbol that is itself tristate (and hence can be modular),
> which is the case with all the problematic cases that have been posted to
> lkml lately.

To elaborate, the problem is:

menuconfig FOO
	bool "FOO support drivers"
	depends on BAR

if FOO

config BAZ
	tristate "BAZ driver"

endif # FOO

Where:

config BAR
	tristate "BAR subsystem"

The problem occurs when:
BAR=m
FOO=y (user selects FOO to show menu to be able to then select BAZ)
BAZ=y

BAZ would be built-in, BAR modular => build breakage. Note that it is
*BAZ* that depends on BAR. BAZ is *code* in the kernel sources, and
depends on BAR because it calls *code* exported by BAR (obviously).

[ We've marked _FOO_ as "depends on BAR" too, however, but that
is only because all the related drivers that this menu shows / hides
have the common property that they depend on BAR and hence there's
no point in showing this menu option to the user unless he has picked
BAR already.]

The root cause of the problem, as Randy Dunlap pointed out yesterday,
is a boolean coming in between the dependency chain of 2 tristates:
BAZ (tristate) depends on FOO (bool) depends on BAR (tristate).

BAR=m _does_ allow its dependency FOO to be "y", which then
allows BAZ (marked as dependency of only FOO but not BAR too,
sadly) to be "y".

Solution 1:

Make all FOO-like configmenu's trisate.
=> if BAR=m => FOO can only be m too => BAZ can only be m too.

But making a menuconfig symbol tristate is ugly, IMHO. These new
primitives are just on/off switches to show / hide a further menu that
contains related drivers / options, after all. They are bool's by meaning,
and need to defined / used as such too. [my opinion, fwiw]

Solution 2:

Explicitly honour the dependency of BAZ on BAR.

2.(a) do this either explicitly by adding "depends on" in kconfig itself:

config BAZ
	tristate "BAZ driver"
	depends on BAR

=> do this for all the config symbols inside any if FOO / endif block
where FOO depends on some other tristate symbol itself. But this
sounds (and feels like being) redundant.

2.(b) or else, make the config scripts "intelligent" so that if:

"menuconfig FOO depends on BAR", then:

All the "config BAZ"s inside this menuconfig (inside the if FOO /
endif block) also automatically "depend on" BAR too.

I would vote for solution 2.(b), personally, but solution 1 is easiest.

Satyam
