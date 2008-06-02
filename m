Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYFBHwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYFBHwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYFBHv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:51:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYFBHv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:51:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Mon, 2 Jun 2008 09:51:26 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200806020325.m523Pqsq025740@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200806020325.m523Pqsq025740@agora.fsl.cs.sunysb.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806020951.26868.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX185S1eQqmQKhGP+m8O9cWSyRDqOPqBHR/f6Sqz
 w2T5OHPPj3Ge5dZ0Zf1x/3l7xyaadpKTgm+GY5cFd1bKdLUDMp
 I95VC7IslKH625gkggXmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008, Erez Zadok wrote:
> Correction: Unionfs doesn't make additional copies in the page cache.

Ok, I must have misunderstood something there. Sorry about that.

> Arnd, I favor a more generic approach, one that will work with the vast
> majority of file systems that people use w/ unioning, preferably all of
> them.  Supporting copy-on-write in cramfs will only help a small subset of
> users.  Yes, it might be simple, but I fear it won't be useful enough to
> convince existing users of unioning to switch over.  And I don't think we
> should add CoW support in every file system -- the complexity will be much
> more than using unionfs or some other VFS-based solution.

My idea was to have it in cramfs, squashfs and iso9660 at most, I agree
that doing it in even a single writable file system would add far too
much complexity. I did not mean to start a fundamental discussion about
how to do it the right way, just noticed that there are half a dozen
implementations that have been around for years without getting close to
inclusion in the mainline kernel, while a much simpler approach gives
you sane semantics for a subset of users.

> I can see some advantages (re: cache coherency) by hacking CoW support
> directly into a f/s.  If you want to use a filesystem-specific solution,
> then I suggest you don't modify a file system used as a source in a union,
> but one used as a destination.  You'll have better overage that way.  The
> vast majority of times, unionfs users will either write to tmpfs or ext2;
> but the source readonly f/s can be a lot of different ones (most popular are
> ext*, nfs*, isofs, and cramfs/squashfs).

Yes, that absolutely makes sense. I don't care much about a persistant
storage for the overlay, so tmpfs (if not ramfs) should be the only place
to do it in. It does introduce some of the same old problems though,
because you could still write to a bind mounted copy of the underlying
file system (unlike cramfs, which is guaranteed to be read-only), which
forces you to either to a full copy-up, or can result in inconsistent
file contents. Also, stacking multiple union-tmpfs copies on top of each
other would be hard to do without the potential to overflow the kernel
stack.

I'll probably try implementing a '-o union' option tmpfs anyway, just
to see how hard it is and what the problems are.

> I find it somewhat ironic to hear the argument that "union mounts isn't
> stable yet, so lets come up with a new solution inside cramfs."  Why should
> your solution become stable much faster than union mounts (which also had
> patches floating around for a long time already).

Because the patches are not trying to solve any of the hard problems at all:
Persistent storage of overlays, readdir traversal through more than two
layers, stable inode numbers, opening a file through two different overlays,
copyup, and so on. I'm sure you know more about these problems that I do,
but as long as I don't have to care about them, I don't see a problem
with my patches (other than the bugs I already described).

> If you have cycles to spare, why not help Bharata and Jan?

I spent a lot of time on discussing the initial implementation with Jan
years ago, and will keep reviewing their patches, but I have neither the
time nor the brains to really contribute much to them. As you mentioned
in your reply to Jan E., it's on an entirely different scale than doing
a small hack to cramfs or tmpfs.

	Arnd <><
