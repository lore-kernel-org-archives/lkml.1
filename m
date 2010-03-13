Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab0CMP25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 10:28:57 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35059 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab0CMP24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 10:28:56 -0500
Date: Sat, 13 Mar 2010 10:27:08 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Philippe De Muyter <phdm@macqel.be>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH kobjects] Fix a rare memory leak in
 kobject_set_name_vargs
In-Reply-To: <1268493336.2947.52.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.00.1003131026380.11320@localhost>
References: <20100313124324.GA15244@frolo.macqel>  <alpine.LFD.2.00.1003130752001.8523@localhost> <1268493336.2947.52.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-64675795-1268494030=:11320"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-64675795-1268494030=:11320
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 13 Mar 2010, Eric Dumazet wrote:

> Le samedi 13 mars 2010 =C3=A0 07:53 -0500, Robert P. J. Day a =C3=A9crit =
:
> > On Sat, 13 Mar 2010, Philippe De Muyter wrote:
> >
> > > Hello Greg,
> > >
> > > This is a possible memory leak that I discovered only by accidental c=
ode
> > > reading.
> > >
> > > --
> > >
> > > If kvasprintf fails in kobject_set_name_vargs, the memory used by
> > > the original kobj->name is leaked.  Fix that.  I also avoid useless
> > > memory accesses to kobj->name by using the local variables old_name
> > > and new_name instead.
> > >
> > > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> > >
> > > diff -r 373fdd3df333 linux-2.6.x/lib/kobject.c
> > > --- a/linux-2.6.x/lib/kobject.c=09Wed Aug 19 23:26:44 2009 +0200
> > > +++ b/linux-2.6.x/lib/kobject.c=09Sat Mar 13 13:35:43 2010 +0100
> > > @@ -216,20 +216,22 @@ int kobject_set_name_vargs(struct kobjec
> > >  =09=09=09=09  va_list vargs)
> > >  {
> > >  =09const char *old_name =3D kobj->name;
> > > +=09char *new_name;
> > >  =09char *s;
> > >
> > > -=09if (kobj->name && !fmt)
> > > +=09if (old_name && !fmt)
> > >  =09=09return 0;
> > >
> > > -=09kobj->name =3D kvasprintf(GFP_KERNEL, fmt, vargs);
> > > -=09if (!kobj->name)
> > > +=09new_name =3D kvasprintf(GFP_KERNEL, fmt, vargs);
> > > +=09if (!new_name)
> > >  =09=09return -ENOMEM;
> > >
> > >  =09/* ewww... some of these buggers have '/' in the name ... */
> > > -=09while ((s =3D strchr(kobj->name, '/')))
> > > +=09while ((s =3D strchr(new_name, '/')))
> > >  =09=09s[0] =3D '!';
> > >
> > >  =09kfree(old_name);
> > > +=09kobj->name =3D new_name;
> > >  =09return 0;
> > >  }
> >
> >   the routine kobject_set_name_vargs() is described in
> > Documentation/kobject.txt as "legacy cruft" to be removed at some
> > point, so it's not clear there's any value in "fixing" it.
> >
>
> Given I submitted a similar patch two days before, I guess a fix
> would be welcome or else we might see one or two attempts per week
> from various people.
>
> http://lkml.org/lkml/2010/3/11/438
>
> Legacy or not, this code looks wrong. I caught it while looking for
> kmemleaks reports on my dev machine, that were triggered by
> CONFIG_NO_BOOTMEM use.

  fair enough, i was just going off of what i read in Doc/kobject.txt.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-64675795-1268494030=:11320--
