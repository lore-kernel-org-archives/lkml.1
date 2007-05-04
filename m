Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXEDI42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXEDI42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXEDI42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:56:28 -0400
Received: from lugor.de ([212.112.242.222]:41087 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933030AbXEDI41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:56:27 -0400
From: Christian Hesse <mail@earthworm.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: build system: no module target ending with slash?
Date: Fri, 4 May 2007 10:56:14 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
References: <200705030043.49208.mail@earthworm.de> <200705030917.19630.mail@earthworm.de> <20070503193736.GA18216@uranus.ravnborg.org>
In-Reply-To: <20070503193736.GA18216@uranus.ravnborg.org>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1509195.9kC0gRHhoH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705041056.19286.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Fri, 04 May 2007 10:56:21 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1509195.9kC0gRHhoH
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 03 May 2007, Sam Ravnborg wrote:
> On Thu, May 03, 2007 at 09:17:15AM +0200, Christian Hesse wrote:
> > On Thursday 03 May 2007, Sam Ravnborg wrote:
> > > On Thu, May 03, 2007 at 06:25:11AM +0200, Sam Ravnborg wrote:
> > > > On Thu, May 03, 2007 at 12:43:43AM +0200, Christian Hesse wrote:
> > > > > Hi James, hi everybody,
> > > > >
> > > > > playing with iwlwifi I try to patch it into the kernel and to bui=
ld
> > > > > it from there. But I have a problem with the build system.
> > > > >
> > > > > The file drivers/net/wireless/mac80211/Makefile contains one sing=
le
> > > > > line:
> > > > >
> > > > > obj-$(CONFIG_IWLWIFI)   +=3D iwlwifi/
> > > > >
> > > > > When CONFIG_IWLWIFI=3Dm in scripts/Makefile.lib line 29 the targe=
t is
> > > > > filtered as it ends with a slash. That results in
> > > > > drivers/net/wireless/mac80211/built-in.o not being built and the
> > > > > build process breaks with an error. What is the correct way to
> > > > > handle this? Why are targets ending with a slash filtered?
> > > >
> > > > Looks buggy. I will take a look tonight.
> > >
> > > After some coffee...
> > >
> > > Line 29 in Kbuild.include find all modules and a directory is not a
> > > module. In line 26 in same file the directory iwlwifi is included in
> > > the list of directories to visit.
> > > So there is something else going on.
> >
> > In scripts/Kbuild.include line 26 is empty and line 29 is a comment... =
Do
> > I look at the wrong place?
>
> I looked at lxr.linux.no - so probarly an outdated version.
>
> > I still believe in my version: built-in.o is built if any of $(obj-y)
> > $(obj-m) $(obj-n) $(obj-) $(lib-target) contains anything in
> > scripts/Makefile.build line 77. As scripts/Makefile.lib line 29 filters
> > the only target the object file is not built.
>
> I have applied your patch and tried it out.
> The reason for the problem is the placeholder directory mac80211.
> kbuild will not waste time building built-in.o for a directory where
> it is not necessary. So for mac80211 no built-in.o is created since there
> is no need. The only reference is to a module.

Agreed that it is not really needed. But if you don't build it you should n=
ot=20
try to link it later...

> The quick-and-dirty workaround is to add a single
> obj-n :=3D xx
> in mac80211/Makefile and kbuild is happy again.
>
> I could teach kbuild to create built-in.o also in the case
> where we refer to a subdirectory only. But then we would end up with a
> built-in.o in all directories where we have a kbuild MAkefile (almost) and
> that is not desireable.

I would prefer to teach it not to link object files that are not built.

> So I recommend the proposed workaround for now with a proper comment.

Ok, thanks for your help.
=2D-=20
Regards,
Chris

--nextPart1509195.9kC0gRHhoH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGOvUzlZfG2c8gdSURAplNAKCk3fzEPohwqmZy7a+Zqs4eShSs0ACeP2+M
qWDKDJULH4Qo7iGgaMy/xII=
=lgaY
-----END PGP SIGNATURE-----

--nextPart1509195.9kC0gRHhoH--
