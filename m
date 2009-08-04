Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZHDNp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZHDNp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZHDNpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZHDNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:45:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC 0/2] new kfifo API
Date: Tue, 4 Aug 2009 15:45:37 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1249306755.8358.8.camel@wall-e> <200908041424.54472.arnd@arndb.de> <1249389877.11474.14.camel@wall-e>
In-Reply-To: <1249389877.11474.14.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908041545.37329.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18clICoe3s7quEF2WOYmppfYZg0+ulPLmTkwjS
 JbT5bami8Y8pEvH21n/9eRoZf96c1C9i9dk3cfPLAoW0nXJvyM
 v8fTt9/kJCP5zu1Ai/lKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Stefani Seibold wrote:
> > Your second version is ok in this regard because it uses the original
> > size logic.
> 
> Does it mean you like it now ;-) ???? I think we are on a good way!

It looks much better now, but I still think you are doing too many
things at once, and I disagree about the locking changes.

I think it would be best to have an incremental set of patches
to the original code, along the lines of

[PATCH 1/x] kfifo: preparation code reorg, no functional change
[PATCH 2/x] kfifo: add DEFINE_KFIFO and friends
[PATCH 3/x] kfifo: add kfifo_{to,from}_user
[PATCH 4/x] kfifo: add kfifo_{get,put}_rec
[PATCH 5/x] kfifo: ...

About the locking stuff, I think it should best be left in place.
The __kfifo_{get,put} functions should probably be declared part
of the official interface and documented as such -- people are
using them anyways. It's generally a good idea to have the obvious
interface work in an entirely safe way (kfifo_get doing all the
locking it might need), with a __foo variant of the same function
for people that want the extra performance and know what they are
doing.

I would also leave out the recsize argument, using an 'unsigned short'
for the record length unconditionally won't waste any real space but
simplifies both the implementation and the interface.

Finally, I don't see a reason for the optional KFIFO_F_NOTRIM argument.
If you have fixed records, I would guess that you always need it
anyway, so you could just make it the default and remove the function
argument.

	Arnd <><
