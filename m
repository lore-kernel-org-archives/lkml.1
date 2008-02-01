Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbYBAHRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbYBAHRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYBAHRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:17:41 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21183 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYBAHRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:17:40 -0500
Message-ID: <47A2C791.8000303@msgid.tls.msk.ru>
Date: Fri, 01 Feb 2008 10:17:37 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
References: <47A0CD90.5080208@msgid.tls.msk.ru> <200801302211.10622.rjw@sisk.pl> <47A10886.5050707@msgid.tls.msk.ru> <20080131144030.GC983@elf.ucw.cz>
In-Reply-To: <20080131144030.GC983@elf.ucw.cz>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
[]
>> I'm looking at the uswsusp source (while the kernel compiles),
>> and have a question here.  Is it possible to call some external
>> application (typically a shell script) to do the final work after
>> when the image has been written?  I mean in principle - I
>> understand there are some limitations here, but I don't know
>> which exactly.
> 
> No, you can't exec() anything. That would write mtime back to disk and
> cause badness.

Now that's.. interesting.

s2disk writes to a swap device/file, which should update
mtime of this device node/file.  Isn't it something which
also causes the same badness?

Also, if the only concern is mtime update, what's really
wrong with it?  I mean, regardless of whether such update
will finally hit the disk or not, there's not much difference
really - it updates just mtime field, and there should be
no harm in that.  Unless such update first goes to a
journal (in a journalling filesystem) - which DOES modify
some on-disk structures.

>> it typically involves writing/reading something to/from
>> a given serial port (/dev/ttySxx), or to an USB device,

> Create libups.so, and link s2disk to it?

And what's the difference here again?  We'll open a serial
port and write something to it - which, again, will update
mtime of that device node.  Unless the said node is on a
tmpfs, exactly the same badness will happen.  Not all the
world is udev, after all.

So I don't get the reason why we can't exec something here,
still.  (And, for example, call splashy commands as external
processes, instead of linking all this cruft into s2disk and
resume.)

What I'm thinking about here is - s2ram mlock()s its memory.
If it will fork/exec something, that something will obviously
NOT be locked like that.  Is it of some concern?  Probably
not, because that something will be executed after we've
taken the snapshot.

/mjt
