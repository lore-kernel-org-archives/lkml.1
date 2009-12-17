Return-Path: <linux-kernel-owner+w=401wt.eu-S1764881AbZLQQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764881AbZLQQqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764802AbZLQQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:46:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49931 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbZLQQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:46:19 -0500
Date: Thu, 17 Dec 2009 17:46:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSCTL: Fix sysctl breakage on systems with older glibc
Message-ID: <20091217164614.GI9804@basil.fritz.box>
References: <20091216112844.GA31705@basil.fritz.box> <m16385abat.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m16385abat.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 07:07:54AM -0800, Eric W. Biederman wrote:
> reaction would be.  If it makes logging in and manually using the
> machine unbearable on systems with versions of glibc from days of
> yore, the level of logging is too high.

The reason I was slightly annoyed is because I flagged this 
during code review and it wasn't addressed before merging.

> 
> > I see this on a SUSE 10.0 system with glibc 2.3.5.
> > Don't warn for this common case.
> 
> Perhaps it is just my sample of the world but glibc < 2.5 isn't
> common, especially on machines that I am putting new kernels on.
> Equally machines with 3+ year old installs are rare.

Linux simply cannot abandon older user land. We still (near) 
fully support a.out executables, even on 64bit.

> 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> > diff -u linux-2.6.32-git12/kernel/sysctl_binary.c-o linux-2.6.32-git12/kernel/sysctl_binary.c
> > --- linux-2.6.32-git12/kernel/sysctl_binary.c-o	2009-12-16 12:15:52.000000000 +0100
> > +++ linux-2.6.32-git12/kernel/sysctl_binary.c	2009-12-16 12:14:58.000000000 +0100
> > @@ -1399,6 +1399,13 @@
> >  {
> >  	int i;
> >  
> > +	/* 
> > +	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot 
> > +	 * ever go away.
> > +	 */
> The comment is wrong.  Older versions of glibc are perfectly happy
> getting -ENOSYS form sys_sysctl.

and it fills and fills and fills the kernel log. In practice
that's not usable.

> 
> > +	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
> > +		return;
> 
> If you make it printk_once for this case I think that strikes the right
> balance.  You won't be spammed to death by messages telling you about
> a silly old glibc, but you will be told.

It's not a "silly old glibc", it's a "perfectly functional old glibc"

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
