Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZGUQJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZGUQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZGUQJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:09:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50032 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755432AbZGUQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:09:25 -0400
Date: Tue, 21 Jul 2009 17:09:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all mmap_zero
 operations
Message-ID: <20090721170909.6182230c@lxorguk.ukuu.org.uk>
In-Reply-To: <1248191833.2654.320.camel@localhost>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
	<20090721160437.5bda68b4@lxorguk.ukuu.org.uk>
	<1248189524.2654.301.camel@localhost>
	<20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
	<1248191833.2654.320.camel@localhost>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This just seemed reasonable, since the Kconfig default is 4096 that's
> what most people have anyway right?

Yes - its rather inadequate when there are multi-page objects floating
around to exploit (remember you only need writes through data pointers for
exploits not executable code)

> runcon -t wine_t [my exploit]
> win.
> 
> So now I have to stop allowing unconfined_t to specifically run things
> as wine_t.  Easy enough to get around
> 
> chcon -t wine_exec_t [my exploit]
> win.
> 
> Well crap, now I have to stop letting unconfined_t label things
> wine_exec_t.  Easy enough to get around if you can load it as an rpm
> (ok, this step is probably harder)

If I can load it as an rpm then I'm the superuser and I already won so
that case isn't too bad really is it ?

So far you've described in SELinux the equivalent of

"user must not be able to chown and setuid their files to someone else"

which was hardly news in 1970 ;)

> and hell, how do I know I can't just get wine some windows program to
> get win to map the page for me?

Mathematical absolutes don't work here. How do you know 4K is enough, 64K
is enough - you never do that either. You can only make it a lot harder.

> unconfined is such a monstrosity it's too hard to get a handle on.  Make
> everyone log in as user_t (man semanage) and you will be better (but I
> haven't proven it is safe...)

Ok.

> and you still could.  Just set mmap_min_addr = 0 and you get SELinux
> protection for confined domains.  I'll gladly add an selinux tunable if
> people like it so SELinux users who don't want to enforce the uid=0 rule
> can do exactly everything they can do today.
> 
> Someone on this list has to know a wine guru.  Seems to me there has to
> be a way that we can give wine CAP_SYS_RAWIO just long enough to map the
> page so non-SELinux users aren't left in the lurch they are today.

I did look - but wine doesn't simply wrap itself around an application,
run it and die. The wine execution model is rather more complicated and
the need to map page zero can thus pop up later on. Some of the other
users you can do this with, and most of the other ones like LRMI of
course are CAP_SYS_RAWIO *anyway* as the main user of this stuff is vm86
bios execution.

It's a really ugly problem that almost begs for better hardware
facilities (such as the multiple independent address spaces in some
processors)

