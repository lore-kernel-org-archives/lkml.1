Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYDROBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYDROBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYDROBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:01:06 -0400
Received: from lazybastard.de ([212.112.238.170]:43571 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYDROBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:01:04 -0400
Date: Fri, 18 Apr 2008 16:00:55 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, ben@fluff.org
Subject: Re: Smartmedia/xd card support - request for comments
Message-ID: <20080418140054.GA6200@logfs.org>
References: <20080417212138.GA343@logfs.org> <143829.94600.qm@web36707.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <143829.94600.qm@web36707.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 April 2008 01:47:12 -0700, Alex Dubov wrote:
> 
> First, with all the respect to Jorn, alauda driver can only be considered "proof of concept". It
> does not try to abstract any smartmedia functionality.

"Proof of concept" is the wrong term.  The goal of
drivers/mtd/nand/alauda.c is to get raw access to the flash.  It
explicitly does not abstract anything because I don't want the
abstraction.  I want a raw piece of flash, represented via mtd.  And I
believe it does match those goals - modulo some bugs.

You seem to want something else.  I have a rough idea what that might
be, nothing more.  Can you explain your goals to give us a better idea?

> Second, ssfdc is hopelessly obsolete and requires rewrite.

Not unusual.

> No infrastructure exists for exporting and manipulation of metadata in userspace.

When using the raw mtd, it does.  After block device translation, it
doesn't.

> And, in general, architecture of mtd is suboptimal, relying on blocking calls (as opposed to
> callback based architecture).

Correct.  Erase() is the only callback-based function and every single
driver implements it synchronous anyway.  Improving this situation is
needed for mtd's own sake anyway.  Either that or replacing mtd with
something else, likely the block device code.

> Considering all this, amount of effort needed for satisfactory support of smartmedia through mtd
> was found by me to be far greater than coming with stand-alone implementation. I do agree, that
> eventually my work can be merged into mtd. I don't see what prevents merging of my implementation
> as is on an interim basis, considering there are no real alternatives.

As Thomas already stated, the kernel crowd has little sympathy for
duplication.  In general, if someone comes along and sais "A if not good
enough, so I wrote B", the answer is "go fix A instead".  Not always in
a polite way, I might add.

Sometimes there are good reasons not to fix A.  Usually the reason is to
remove A after B has been merged.  Which does not apply here.  So you
should prepare to explain yourself rather well, if you ever want to see
your code merged.

That said, I personally like duplication and believe it is the way to go
in many causes.  If your code can ignore all the issues with A, you can
focus on the problem at hand and write the best code possible.  But that
is just the first step.  In a second step, any common code of the two
pieces gets generalized and used by both.

The reason why I prefer generalizing late rather than early is that
almost noone gets the abstractions right before seeing all users.
Certainly not me.  The end result is better by being specialized first
and generalize later.  But you have to do the generalization step.

And your chances of getting the code merged before the generalization
are low.  Particularly when adding new userspace interfaces, because we
cannot remove those in a later stage.

> In case somebody is actually interested in looking at the code:
> 
> http://svn.berlios.de/wsvn/tifmxx/trunk/driver/#_trunk_driver_

Sure am.  You should use explicitly sized types in most of your data
structures, like here:
struct xd_card_extra {
        unsigned int   reserved;
        unsigned char  data_status;
        unsigned char  block_status;
        unsigned short addr1;
        unsigned char  ecc_hi[3];
        unsigned short addr2; /* this should be identical to addr1 */
        unsigned char  ecc_lo[3];
} __attribute__((packed));

And if you want to be pre-flamed, running things through checkpatch.pl
lets you take the pain early.

Jörn

-- 
Joern's library part 6:
http://www.gzip.org/zlib/feldspar.html
