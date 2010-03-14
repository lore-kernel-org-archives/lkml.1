Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab0CNONe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:13:34 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:22966 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179Ab0CNONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:13:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABaLnEvCTtAn/2dsb2JhbACab3O2IoR7BA
Date: Sun, 14 Mar 2010 15:13:29 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] IOMEGA network drive compatibility
Message-ID: <20100314141328.GA7712@frolo.macqel>
References: <20100310161429.GA16799@frolo.macqel> <87hboow105.fsf@devron.myhome.or.jp> <20100310235808.GA4353@frolo.macqel> <87bpevryxt.fsf@devron.myhome.or.jp> <20100311120214.GA23767@frolo.macqel> <87y6hzni82.fsf@devron.myhome.or.jp> <20100313113150.GA11907@frolo.macqel> <87wrxg9xri.fsf@devron.myhome.or.jp> <20100314103924.GA3712@frolo.macqel> <87r5nnqhit.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r5nnqhit.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 08:17:30PM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> > You can call that a hack, but it certainly is better than the current situation.
> > IOMEGA network drive firmware allows to create two files in the same directory
> > differing only by the trailing dots.  Suppose you have in the same directory
> > a file called "123456789" and a file called "123456789." (same name + a
> > trailing dot).  When afterwards connected via USB to a linux computer,
> > ls or any GUI equivalent will show you two files, one called "123456789"
> > and one called "123456789.".  If you compare those two files, linux/vfat
> > will tell you that they are equal, because the vfat driver will wrongly
> > access twice the same "123456789" file and never the "123456789." file.
> >
> > -rwxr-xr-x 1 phdm root     1 2009-10-15 23:44 123456789
> > -rwxr-xr-x 1 phdm root     1 2009-10-15 23:44 123456789.
> >
> > If you then decide to remove the "123456789." file (the one with the
> > trailing dot), because it is an useless copy of your "123456789" file,
> > linux/vfat will silently remove the "123456789" file.  Afterwards,
> > if you're lucky, you'll see ls complain :
> >
> > 	ls: cannot access a.: No such file or directory
wrong editing, of course it was :
	ls: cannot access 123456789.: No such file or directory
> >
> > , but some GUI interfaces won't say anything.
> >
> > In the listing, ls will show :
> >
> > -????????? ? ?    ?        ?                ? 123456789.
> > (The "123456789" does not appear anymore)
> >
> > but again some GUI won't even show you the name of the "123456789." file
> 
> Because it's wrong entry as fatfs. In this situation, user needs to
> repair by tools (e.g. fsck), so it's not responsibility of fs driver.

I know that entries with trailing dots are "invalid" fatfs entries,
but 1) linux/vfat currently accept such entries silently without truncating
them and 2) IOMEGA disks present themselves as fatfs disks.  Who are we to
tell the opposite ?  And IOMEGA integrated scandisk (accessible via the
web interface) does not find any error in its filesystem.

> 
> > With my proposed patch, at least if getdents tells a user program that
> > there is a "123456789." entry, further references by open and friends
> > will access precisely that entry, not another one.  That at least needs to
> > be fixed, without any option that the user should give to mount.
> 
> Now, you try to change that design. So, you need to change/think more
> high level consistency/design, not just workaround. Otherwise, it'll be
> unmaintainable/unfixable.

I am sorry but I don't see anything unmaintainable/unfixable in my patch :
it is very small and localized and it only allows accessing existing
entries with trailing dots, nothing more.
It does not allow to create "invalid" entries, so it does not change the
behaviour for "strict" vfat disks, it only introduces a small time penalty
when a user tries to access a file using a different name that the one stored
in the directory, which happens very rarely : most linux users use GUI's or
bash tab-completion to access files, which implies they use the name given by
the file-system driver, not a variation of it.

Now if we are concerned about "editing" such files by creating a temporary
file and renaming, we can look at what is needed to make renaming to an
existing name containing trailing dots succeed.  I have not tested that yet.

For the rest, i.e. creating arbitrary names with trailing dots just like
what IOMEGA drives do, it can be with a mount option, or left as it is
now : impossible.

Philippe
