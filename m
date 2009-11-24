Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbZKXXuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbZKXXuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934386AbZKXXuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:50:10 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50590 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934380AbZKXXuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nqn7IcODykb64T2fzSEGqXATWg6M83S5WgWmhSJwstYKUal7XosJwvgtPwgiQqCbKG
         VHWW6hfmDpzc4SLwsY0/qQXr1OE7ubwf10aHWHl6q1DjtZGujaWTfkJxz3npVUjTjFiK
         P9DjTs9Wut700YpA49el4PvAVspYObUdifObo=
Subject: Plan for adding XD support in mtd layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <1258894713.4127.4.camel@maxim-laptop>
References: <1258763144.4997.12.camel@maxim-laptop>
	 <20091121102542.GA21136@logfs.org>  <1258894713.4127.4.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 01:50:10 +0200
Message-ID: <1259106610.28219.34.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my plan for adding the XD format into MTD subsystem.
Please review.

New additions are marked with '->'


Chip driver:

no problems with that, in fact ricoh controller I reverse engineered is
very similar conceptually
to jmicron.
I can take original jmicron driver almost verbatim.
This will live in new sub folder of mtd and call into base XD driver


Base XD mtd driver:

* No way to tell that readsize = 512, but write & erase size isn't.
Not such a big deal, since higher level FTL driver can hardcode that
assumption, and access via mtdblk isn't necessary, since FTL will
replace it for XD, and the raw access will be done through mtdchar.

* it is possible to export 'extra' via oob. FTL will use that, and will
be available to user via char device

* No need to export CIF block, it will be available for user via char
device by scanning the device (using a new utility)


-> I need new mtd_info member for at least for card identification, and
will be nice to have zone/block/page size
This will be used by FTL and mtdchar to be exported to user space


FTL driver:

I will write new XD/smartmedia FTL driver.

* Will read ID/type from device and do all the work based on that,
(figure page size/zone count/block size, etc...) or will get that info
from mtd driver 

* Will cache read/writes (this will overlap with mtdblk)

* Will provide normal block level access to filesystems, and user.
(using common block device of course)

* No debugging information or/and device specific ioctls.


Char driver:

* Already exists, and I will need to modify it, so I could read ID/media
type
Also would be nice to pass info about sizes (zones/pages/blocks) to
userspace 
If not, I will put translation table to userspace utility based on media
ID


Userspace utility:
* Will allow user to read FTL maps (based on oob), Media ID, CIF, all
using char device
* Will also allow low level format.



Best regards,
Maxim Levitsky

