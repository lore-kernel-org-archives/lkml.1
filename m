Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbZHDO6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbZHDO6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZHDO6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:58:08 -0400
Received: from www84.your-server.de ([213.133.104.84]:34917 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbZHDO6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:58:06 -0400
Subject: Re: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stelian@popies.net
In-Reply-To: <200908041545.37329.arnd@arndb.de>
References: <1249306755.8358.8.camel@wall-e>
	 <200908041424.54472.arnd@arndb.de> <1249389877.11474.14.camel@wall-e>
	 <200908041545.37329.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 16:57:52 +0200
Message-Id: <1249397872.18146.64.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 04.08.2009, 15:45 +0200 schrieb Arnd Bergmann:
> On Tuesday 04 August 2009, Stefani Seibold wrote:
> > > Your second version is ok in this regard because it uses the original
> > > size logic.
> > 
> > Does it mean you like it now ;-) ???? I think we are on a good way!
> 
> It looks much better now, but I still think you are doing too many
> things at once, and I disagree about the locking changes.
> 

I had a look at the user of the kfifo_put and kfifo_get, most did not
really depend on the spinlock, because there are single read/single
write users.
 
> I think it would be best to have an incremental set of patches
> to the original code, along the lines of
> 
> [PATCH 1/x] kfifo: preparation code reorg, no functional change

This is not possible. You cannot cleanup functionality without changing
and breaking anything.

> [PATCH 2/x] kfifo: add DEFINE_KFIFO and friends
> [PATCH 3/x] kfifo: add kfifo_{to,from}_user
> [PATCH 4/x] kfifo: add kfifo_{get,put}_rec
> [PATCH 5/x] kfifo: ...
> 

Thats will work... but the first patch will break something. Why is
everybody depending on this stupid split patch dogma, beside it make
sense or not?

If i do this in that why, then the first patch will change 13 files, and
modify about 70 lines.
 
> About the locking stuff, I think it should best be left in place.
> The __kfifo_{get,put} functions should probably be declared part
> of the official interface and documented as such -- people are
> using them anyways. It's generally a good idea to have the obvious
> interface work in an entirely safe way (kfifo_get doing all the
> locking it might need), with a __foo variant of the same function
> for people that want the extra performance and know what they are
> doing.
> 

Believe me, nobody need this locking stuff. The common use case is one
writer/one reader, so it is complete useless. Have a look on the current
source file wich use it.

But kfifo_put() and kfifo_put will() be in the next version static
inlines to __kfifo_put() and __kfifo_get(). So we are compatible at this
point. 

> I would also leave out the recsize argument, using an 'unsigned short'
> for the record length unconditionally won't waste any real space but
> simplifies both the implementation and the interface.
> 

You are wrong. It is designed to be look free until one reader and one
writer is in use. If i split the record operation i must introduce a
lock, because between two kfifo_put a kfifo_get operation can happen (or
visa verse).
   
> Finally, I don't see a reason for the optional KFIFO_F_NOTRIM argument.
> If you have fixed records, I would guess that you always need it
> anyway, so you could just make it the default and remove the function
> argument.
> 

The design is to have variable length records, so it it not always true
that the destination of an operation have enough space. Cutting of the
record is not always what then is desired. It also does not cost any
code or performance since it is handle by __build_constant_p and will be
complete optimized away.

I would get a little bit confused ... Why did you not say "please add
only the kfifo_from_user() and kfifo_to_user() stuff and throw the rest
away"?. I am thankful for your review and your objections, but if my
idea is melt down in that way i would prefer not do the job.

Why do you have so much fear to change an interfaces which is currently
used by very few sources? Most of them are not critical.  

I think it is a quiet clean interface, easy to use, easy to understand
and handles 99 percent of the use cases.

So my offer is to split it into 5 patches against the current 2.6.31
tree:

[PATCH 1/x] kfifo  code cleanup and preparation (includes for broken sources)
[PATCH 2/x] kfifo: remove spinlock (includes fix for broken sources) 
[PATCH 3/x] kfifo: add DEFINE_KFIFO and friends
[PATCH 4/x] kfifo: add kfifo_{to,from}_user
[PATCH 5/x] kfifo: add kfifo_{get,put}_rec

Is this acceptable? It would be nice to have your support.

Stefani


