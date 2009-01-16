Return-Path: <linux-kernel-owner+w=401wt.eu-S937260AbZAPTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937260AbZAPTUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZAPTUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:20:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZAPTUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:20:33 -0500
Message-ID: <4970DDF9.4090007@redhat.com>
Date: Fri, 16 Jan 2009 11:20:25 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       aarcange@redhat.com
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de>
In-Reply-To: <200901161852.04953.arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Arnd Bergmann wrote:
> Did you get any feedback from Ulrich
> Drepper as to whether he plans to add support to glibc?

If they are in the kernel there is no reason not to export them from
glibc.  But I have a general comment about all kinds of read syscalls.
If think they have been misdesigned from day one and if we are going to
add new ones we might want to fix them.

The problem is that they don't allow for zero-copy operations in enough
cases.  The kernel is not free to store the data wherever it wants even
if the userlevel code is fine with that.  Ideally the program would tell
the kernel that it is fine with any addressable address and provides a
buffer for the kernel to use in case zero-copy into that buffer is
possible or no zero-copy is possible at all.  An interface could look
like this:

   ssize_t readz (int fd, void *buf, size_t len, void **res)

(and accordingly for similar calls).  The application will then use the
pointer stored at the address pointed to by the fourth parameter instead
of unconditionally using the buffer pointed to by the second parameter.
 For res==NULL the semantics could be the same as the normal read().

This is not the only interface needed to make this work.  Somehow the
memory used for the zero-copy buffers has to be administrated.  At the
very least an interface to mark the buffer returned by readz() as unused
is needed.

There is a lot to think about before this can be done (something I
started back in my 2006 OLS paper [1]).  But I wonder whether it's worth
preparing for it and not add yet more interfaces which aren't ready for
this type of I/O.


[1] http://people.redhat.com/drepper/newni.pdf

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklw3bIACgkQ2ijCOnn/RHSutgCgvIZki4gZfuLzwCOGkZqOf97v
1LYAn3fQj0C8CabsfvaYonFTZQ3oUtSn
=EDYF
-----END PGP SIGNATURE-----
