Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbYHHWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbYHHWQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763359AbYHHWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:16:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763228AbYHHWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:16:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Date: Sat, 9 Aug 2008 00:13:41 +0200
User-Agent: KMail/1.9.9
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel> <200808081146.54834.arnd@arndb.de> <1218221451.19082.36.camel@nimitz>
In-Reply-To: <1218221451.19082.36.camel@nimitz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090013.41999.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/z/V4r/UfP0SyFcCWxd1tYO9/F3W1Q9rDS93D
 USgPKAoN2IewaJMmKU/hY/zqCchEm35PujRBqzE5xzF2KC6yZj
 auvefwp2plT8YppG/t8fA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Dave Hansen wrote:
> On Fri, 2008-08-08 at 11:46 +0200, Arnd Bergmann wrote:

> > > +struct cr_hdr_tail {
> > > +	__u32 magic;
> > > +	__u32 cksum[2];
> > > +};
> > 
> > This structure has an odd multiple of 32-bit members, which means
> > that if you put it into a larger structure that also contains
> > 64-bit members, the larger structure may get different alignment
> > on x86-32 and x86-64, which you might want to avoid.
> > I can't tell if this is an actual problem here.
> 
> Can't we just declare all these things __packed__ and stop worrying
> about aligning them all manually?

I personally dislike __packed__ because it makes it very easy to get
suboptimal object code. If you either pad every structure to a multiple
of 64 bits or avoid __u64 members, you don't have a problem. Also,
I think avoiding implicit padding inside of data structures is very
helpful for user interfaces, if necessary you can always add explicit
padding.

> > get_fs()/set_fs() always feels a bit ouch, and this way you have
> > to use __force to avoid the warnings about __user pointer casts
> > in sparse.
> > I wonder if you can use splice_read/splice_write to get around
> > this problem.
> 
> I have to wonder if this is just a symptom of us trying to do this the
> wrong way.  We're trying to talk the kernel into writing internal gunk
> into a FD.  You're right, it is like a splice where one end of the pipe
> is in the kernel.
> 
> Any thoughts on a better way to do this?  

Maybe you can invert the logic and let the new syscalls create a file
descriptor, and then have user space read or splice the checkpoint
data from it, and restore it by writing to the file descriptor.
It's probably easy to do using anon_inode_getfd() and would solve this
problem, but at the same time make checkpointing the current thread
hard if not impossible.

> Yes, eventually.  I think one good point is that we should probably
> remove this now so that we *have* to think about security implications
> as we add each individual patch.  For instance, what kind of checking do
> we do when we restore an mlock()'d VMA?

I think the question can be generalized further: How do you deal with
saved tasks that have more priviledges than the task doing the restore?

There are probably more, but what I can think of right now includes:
* anything you can set using ulimit
* capabilities
* threads running as another user/group
* open files that have had their permissions changed after the open

	Arnd <><
