Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYDXQcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYDXQcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYDXQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:31:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48766 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755138AbYDXQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:31:51 -0400
Date: Thu, 24 Apr 2008 17:03:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative^2 to sys_indirect: socket, socketpair
Message-ID: <20080424170325.569afa43@the-village.bc.nu>
In-Reply-To: <200804241618.m3OGI9kd013025@devserv.devel.redhat.com>
References: <200804241618.m3OGI9kd013025@devserv.devel.redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments all come down to implementation details and it basically looks
sound and fairly small clean change (especially when the various wrappers
and _flags changes were replaced by just fixing up the callers to
functions in a final implementation.

Add a new accept() and it looks good to me

> -	fd = get_unused_fd();
> +	fd = get_unused_fd_flags(flags);

Better to fix up the existing users who don't pass flags (and check why
they need not to), Implementation detail

> -int sock_map_fd(struct socket *sock)
> +static int sock_map_fd_flags(struct socket *sock, int flags)

No need to rename these, the compiler errors will let us quickly
find/fix any users.

> +int sock_map_fd(struct socket *sock)
> +{
> +	return sock_map_fd_flags(sock, 0);
> +}

Ditto

> +	/* Extract the close-on-exec flag.  */
> +	if ((type & SOCK_CLOEXEC) != 0) {
> +		fflags = O_CLOEXEC;
> +		type &= ~SOCK_CLOEXEC;

> +	/* Extract the close-on-exec flag.  */
> +	if ((type & SOCK_CLOEXEC) != 0) {
> +		fflags = O_CLOEXEC;
> +		type &= ~SOCK_CLOEXEC;
> +	}

Should probably be done once in one place in case we ever add future flags



-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
