Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYEMD5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYEMD5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYEMD5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:57:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbYEMD53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:57:29 -0400
Message-ID: <482910FA.1080703@redhat.com>
Date: Mon, 12 May 2008 20:54:34 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com> <20080512201341.9ead6a9a.akpm@linux-foundation.org>
In-Reply-To: <20080512201341.9ead6a9a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
>> +	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
> 
> The fifth assertion triggers with alpha allmodconfig.

This means the simple approach won't work for alpha.

The question is how to solve it?  I suggest the following:

- - define SOCK_NONBLOCK to some value > 16 in include/asm-alpha/socket.h

- - add #ifndef SOCK_NONBLOCK around the definition in include/linux/net.h

- - in sys_socket, sys_socketpair, sys_paccept

   int fflags = flags;
   if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK)) {
     fflags &= ~SOCK_NONBLOCK;
     fflags |= O_NONBLOCK;
   }

  and use fflags instead of flags in the places where we pass it on.

This has no costs on platforms other than alpha.

Shall I sent a patch?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgpEPoACgkQ2ijCOnn/RHQ38gCgyVOI/urGeoIr7CFIfs8C7OyR
I80AniPGGWyxZYUQg0pQlySQHqX/UYlx
=5fA2
-----END PGP SIGNATURE-----
