Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab0CNKjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:35 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:61625 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757695Ab0CNKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:39:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKNZnEvCTtAn/2dsb2JhbACab3O1d4R7BA
Date: Sun, 14 Mar 2010 11:39:24 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] IOMEGA network drive compatibility
Message-ID: <20100314103924.GA3712@frolo.macqel>
References: <20100310123257.GA2899@frolo.macqel> <87d3zc1bjo.fsf@devron.myhome.or.jp> <20100310161429.GA16799@frolo.macqel> <87hboow105.fsf@devron.myhome.or.jp> <20100310235808.GA4353@frolo.macqel> <87bpevryxt.fsf@devron.myhome.or.jp> <20100311120214.GA23767@frolo.macqel> <87y6hzni82.fsf@devron.myhome.or.jp> <20100313113150.GA11907@frolo.macqel> <87wrxg9xri.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrxg9xri.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ogawa,

I changed the subject to make it more explicit.

On Sat, Mar 13, 2010 at 10:06:25PM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> >> No, this breaks consistency. With this patch, unlink("a."), then
> >> open("a.", O_CREAT) and write(), the result depend on existent
> >> files. This patch is providing two files on one name.
> >
> > To avoid that, we could remember that we have found a filename with a trailing
> > dot (in that directory or in the whole disk), and if that's the case then
> > we are allowed to create filenames with trailing dots.
> 
> It sounds like dirty hack, and it would make more complex situations.
> And the user can umount/mount (or reboot, etc.) before open().

You can call that a hack, but it certainly is better than the current situation.
IOMEGA network drive firmware allows to create two files in the same directory
differing only by the trailing dots.  Suppose you have in the same directory
a file called "123456789" and a file called "123456789." (same name + a
trailing dot).  When afterwards connected via USB to a linux computer,
ls or any GUI equivalent will show you two files, one called "123456789"
and one called "123456789.".  If you compare those two files, linux/vfat
will tell you that they are equal, because the vfat driver will wrongly
access twice the same "123456789" file and never the "123456789." file.

-rwxr-xr-x 1 phdm root     1 2009-10-15 23:44 123456789
-rwxr-xr-x 1 phdm root     1 2009-10-15 23:44 123456789.

If you then decide to remove the "123456789." file (the one with the
trailing dot), because it is an useless copy of your "123456789" file,
linux/vfat will silently remove the "123456789" file.  Afterwards,
if you're lucky, you'll see ls complain :

	ls: cannot access a.: No such file or directory

, but some GUI interfaces won't say anything.

In the listing, ls will show :

-????????? ? ?    ?        ?                ? 123456789.
(The "123456789" does not appear anymore)

but again some GUI won't even show you the name of the "123456789." file

With my proposed patch, at least if getdents tells a user program that
there is a "123456789." entry, further references by open and friends
will access precisely that entry, not another one.  That at least needs to
be fixed, without any option that the user should give to mount.

Best regards

Philippe
