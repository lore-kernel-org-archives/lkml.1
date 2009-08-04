Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbZHDSAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbZHDSAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZHDSAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:00:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbZHDSAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:00:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC 0/2] new kfifo API
Date: Tue, 4 Aug 2009 20:00:30 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, stelian@popies.net
References: <1249306755.8358.8.camel@wall-e> <200908041545.37329.arnd@arndb.de> <1249397872.18146.64.camel@wall-e>
In-Reply-To: <1249397872.18146.64.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908042000.30491.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18NIe/SMErvV86gEePvOqy3I4juLpnciTIA6LN
 Khkye4EKZ00o4wzQOoYr1ekZbIcR4CDgzPGG50hgouhg4JBipS
 IoMj2EsOge+YRJOxNyRlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Stefani Seibold wrote:
> Am Dienstag, den 04.08.2009, 15:45 +0200 schrieb Arnd Bergmann:
> > On Tuesday 04 August 2009, Stefani Seibold wrote:
> > > > Your second version is ok in this regard because it uses the original
> > > > size logic.
> > > 
> > > Does it mean you like it now ;-) ???? I think we are on a good way!
> > 
> > It looks much better now, but I still think you are doing too many
> > things at once, and I disagree about the locking changes.
> > 
> 
> I had a look at the user of the kfifo_put and kfifo_get, most did not
> really depend on the spinlock, because there are single read/single
> write users.

The question is not so much what the common use case is but what
the safe one is. Except for Andi's NMI driver, everyone can use
the locked version, even if many could use the unlocked version
if they want it to be faster.

You could of course change the existing users of the locked
interface to use the unlocked one, but I wouldn't bother.
Changing the behaviour of an existing interface without changing
the name is not so nice though.

If you read the original discussion about kfifo, a lot of
it focused around how locking should be done:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-09/4195.html

Of course I realize that the locking gets into the way if you
want to do copy_{to,from}_user, but the last person that had
this problem also worked around that by defining user access
only for the unlocked versions:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-06/msg04959.html

No idea why this was never merged ;-)

> > [PATCH 2/x] kfifo: add DEFINE_KFIFO and friends
> > [PATCH 3/x] kfifo: add kfifo_{to,from}_user
> > [PATCH 4/x] kfifo: add kfifo_{get,put}_rec
> > [PATCH 5/x] kfifo: ...
> > 
> 
> Thats will work... but the first patch will break something. Why is
> everybody depending on this stupid split patch dogma, beside it make
> sense or not?

multiple reasons:

- it makes reviews easier. You want the patches to get merged, so it's
your job to make it easy to see how they help and don't cause bugs.

- the patches with the separate changelogs become part of the
bisectable git history. If something breaks, we can find the specific
change that caused it and see the problem, potentially reverting
the patch.

- the patch description becomes part of the documentation of the code.
if you don't understand why code is done in a specific way, you can
look at the patch that introduced it. Your 0/2 mail contents are very
detailed, but don't get anywhere, while a patch description lives
forever.

All of these are much more important for infrastructure changes than
for device drivers.

> If i do this in that why, then the first patch will change 13 files, and
> modify about 70 lines.

That doesn't sound too much.

> > About the locking stuff, I think it should best be left in place.
> > The __kfifo_{get,put} functions should probably be declared part
> > of the official interface and documented as such -- people are
> > using them anyways. It's generally a good idea to have the obvious
> > interface work in an entirely safe way (kfifo_get doing all the
> > locking it might need), with a __foo variant of the same function
> > for people that want the extra performance and know what they are
> > doing.
> > 
> 
> Believe me, nobody need this locking stuff. The common use case is one
> writer/one reader, so it is complete useless. Have a look on the current
> source file wich use it.

ok. Mostly true, but looking at it conservatively:

sonypi.c: multiple readers: sonypi_misc_read can be called concurrently,
	which is probably a driver bug

meyeioc.c: ioctl can race with irq

sony-laptop.c: sony_pic_irq can race with sony_nc_notify, sonypi_misc_read
	can race with do_sony_laptop_release_key

cxio_resource.c: I have no idea what that code does, do you?

> > I would also leave out the recsize argument, using an 'unsigned short'
> > for the record length unconditionally won't waste any real space but
> > simplifies both the implementation and the interface.
> > 
> 
> You are wrong. It is designed to be look free until one reader and one
> writer is in use. If i split the record operation i must introduce a
> lock, because between two kfifo_put a kfifo_get operation can happen (or
> visa verse).

I don't understand what you mean by that or what it has to do with
the recsize argument.

> > Finally, I don't see a reason for the optional KFIFO_F_NOTRIM argument.
> > If you have fixed records, I would guess that you always need it
> > anyway, so you could just make it the default and remove the function
> > argument.
> 
> The design is to have variable length records, so it it not always true
> that the destination of an operation have enough space. Cutting of the
> record is not always what then is desired. It also does not cost any
> code or performance since it is handle by __build_constant_p and will be
> complete optimized away.

I did not object to the implementation complexity but everybody having
to specify an extra argument which is likely to be the same in all cases,
just like you argue that we don't need both locked and unlocked versions
when everyone could live with the unlocked API.

> I would get a little bit confused ... Why did you not say "please add
> only the kfifo_from_user() and kfifo_to_user() stuff and throw the rest
> away"?. I am thankful for your review and your objections, but if my
> idea is melt down in that way i would prefer not do the job.
> 
> Why do you have so much fear to change an interfaces which is currently
> used by very few sources? Most of them are not critical.

especially because it is so rarely used, any regressions would likely
not get found early, so it would be better to only touch the code
when the change is "obviously correct" and a significant improvement.

Adding new interfaces obviously doesn't cause regressions, but counts
as untested (or bitrotten) code until there are actual users in the
tree, which you don't have.

> So my offer is to split it into 5 patches against the current 2.6.31
> tree:
> 
> [PATCH 1/x] kfifo  code cleanup and preparation (includes for broken sources)
> [PATCH 2/x] kfifo: remove spinlock (includes fix for broken sources) 
> [PATCH 3/x] kfifo: add DEFINE_KFIFO and friends
> [PATCH 4/x] kfifo: add kfifo_{to,from}_user
> [PATCH 5/x] kfifo: add kfifo_{get,put}_rec
> 
> Is this acceptable? It would be nice to have your support.

Yes, that looks good.

	Arnd <><
