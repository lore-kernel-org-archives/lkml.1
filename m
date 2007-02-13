Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXBMEfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXBMEfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 23:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161006AbXBMEfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 23:35:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59272 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161005AbXBMEfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 23:35:12 -0500
Date: Tue, 13 Feb 2007 15:35:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [patch] (2nd try)  add epoll compat code to kernel/compat.c ...
Message-Id: <20070213153525.c1440cff.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0702111615340.24568@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702111615340.24568@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Feb_2007_15_35_25_+1100_2yaVMTYTKTP7f8t4"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Feb_2007_15_35_25_+1100_2yaVMTYTKTP7f8t4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi Davide,

[Linux-arch readers can skip to the last few paragraphs ...]

Just a couple of nits to start:

On Sun, 11 Feb 2007 16:24:30 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
>
> diff -Nru linux-2.6.20/fs/eventpoll.c linux-2.6.20.mod/fs/eventpoll.c
> --- linux-2.6.20/fs/eventpoll.c	2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20.mod/fs/eventpoll.c	2007-02-11 15:26:07.000000000 -0800

The changes to this file are just white space.  Don't include it with
this patch (if at all).

> diff -Nru linux-2.6.20/include/linux/compat.h linux-2.6.20.mod/include/linux/compat.h
> --- linux-2.6.20/include/linux/compat.h	2007-02-09 16:14:20.000000000 -0800
> +++ linux-2.6.20.mod/include/linux/compat.h	2007-02-11 16:11:37.000000000 -0800
> @@ -234,5 +234,35 @@
>  		compat_ulong_t maxnode, const compat_ulong_t __user *old_nodes,
>  		const compat_ulong_t __user *new_nodes);
>
> +/*
> + * epoll (fs/eventpoll.c) compat bits follow ...
> + */
> +struct epoll_event;
> +
> +struct compat_epoll_event {
> +	u32 events;
> +	u32 data[2];
> +};
> +
> +asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
> +				     struct compat_epoll_event __user *event);
> +asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
> +				      int maxevents, int timeout);
> +/*
> + * Architectures that does not need "struct epoll_event" translation
                         ^^^^
should be "do"

> + * should wire compat_sys_epoll_pwait. The ones that needs "struct epoll_event"
                                                        ^^^^^
should be "need"

Sorry for the grammar lesson.

> + * translation, should wire compat_sys_epoll_pwait2. An architecture needs
> + * "struct epoll_event" translation is alignof(u64) in 32 bits mode is 4, and
                                       ^^                    ^^^^
should be "if" and we normally say "32 bit mode"

> + * alignof(u64) in 64 bits mode is 8.

"64 bit mode"

> +asmlinkage long compat_sys_epoll_pwait2(int epfd, struct compat_epoll_event __user *events,

Try to stay less than 80 columns wide.

> diff -Nru linux-2.6.20/kernel/compat.c linux-2.6.20.mod/kernel/compat.c
> --- linux-2.6.20/kernel/compat.c	2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20.mod/kernel/compat.c	2007-02-11 16:11:01.000000000 -0800
> +asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
> +				     struct compat_epoll_event __user *event)
> +{
> +	long err = 0;
> +	struct compat_epoll_event user;
> +	struct epoll_event __user *kernel = NULL;
> +	union {
> +		u64 q;
> +		u32 d[2];
> +	} mux;
> +
> +	if (event) {
> +		if (copy_from_user(&user, event, sizeof(user)))
> +			return -EFAULT;
> +		kernel = compat_alloc_user_space(sizeof(struct epoll_event));
> +		err |= __put_user(user.events, &kernel->events);
> +		mux.d[0] = user.data[0];
> +		mux.d[1] = user.data[1];
> +		err |= __put_user(mux.q, &kernel->data);

A better way here might be to have each 64 bit architecture define
compat_epoll_event in its asm/compat.h and then you can just use:

	if (copy_from_user(&user, event, sizeof(user)))
		return -EFAULT;
	kernel = compat_alloc_user_space(sizeof(struct epoll_event));
	err |= __put_user(user.events, &kernel->events);
	err |= __put_user(user.data, &kernel->data);

And you shouldn't need the compat routine if
offsetof(struct compat_epoll_event, data) == offsetof(struct epoll_event, data).

> +asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
> +				      int maxevents, int timeout)
> +{
> +	long i, ret, err = 0;
> +	struct epoll_event __user *kbuf;
> +	struct epoll_event ev;
> +	union {
> +		u64 q;
> +		u32 d[2];
> +	} mux;
> +
> +	if (maxevents <= 0 || maxevents > (INT_MAX / sizeof(struct epoll_event)))
> +		return -EINVAL;
> +	kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
> +	ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
> +	for (i = 0; i < ret; i++) {
> +		err |= __get_user(ev.events, &kbuf[i].events);
> +		err |= __get_user(ev.data, &kbuf[i].data);
> +		err |= put_user(ev.events, &events->events);
> +		mux.q = ev.data;
> +		err |= put_user(mux.d[0], &events->data[0]);
> +		err |= put_user(mux.d[1], &events->data[1]);
> +		events++;
> +	}

Similarly here.

OK, I have thought about this some more and I *think* the only
architecture that needs compat_sys_epoll_ctl or compat_sys_epoll_wait is
ia64 where the 64 bit version of struct epoll_event is different from the
32 bit version.  On x86_64, the struct is explictly packed (so it is the
same as the 32 bit version) and on all the other 64 bit architectures the
alignment of the u64 is the same as the equivalent 32 bit version.

Since ia64 already has its own version of these two, we only have to
worry about epoll_pwait and then the struct epoll_event is only a problem
for ia64.

Am I right?  (I have cc'd linux-arch for guidance.)

(sorry for the long early bit of this mail)
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Feb_2007_15_35_25_+1100_2yaVMTYTKTP7f8t4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF0UATFdBgD/zoJvwRAlEkAJ9nZqypv3EX+b4P9BEydclE24Fz+ACeIbbq
XBoEwBiG+rpWt43rOc1OEsk=
=Q0zA
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Feb_2007_15_35_25_+1100_2yaVMTYTKTP7f8t4--
