Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbYEFCk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbYEFCk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYEFCkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:40:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYEFCkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:40:11 -0400
Message-ID: <481FC4E6.5060206@redhat.com>
Date: Mon, 05 May 2008 19:39:34 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 01/18] flag parameters: helper function
References: <200805050342.m453gkY4029814@devserv.devel.redhat.com> <20080505185103.b9299541.akpm@linux-foundation.org>
In-Reply-To: <20080505185103.b9299541.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> hm, that looks expensive.  The compiler will need to generate a deref of m
> and rf multiple times around the loop.  Copying them into locals does
> improve that a lot.

There really is no problem.  The value is in L1d when it is reused.
This is the generated code (%rdi is m):

   f:   85 17                   test   %edx,(%rdi)
  11:   74 0b                   je     1e <flags_remap+0x1e>
  13:   8b 47 04                mov    0x4(%rdi),%eax
  16:   09 01                   or     %eax,(%rcx)
  18:   8b 07                   mov    (%rdi),%eax
  1a:   f7 d0                   not    %eax
  1c:   21 c2                   and    %eax,%edx

At address 18 the load will be satisfied from L1d.  If you would want to
cache the value at address f you'd have to create one more instruction.

This really is the best code sequence.  The compiler could have chosen
to move the value into a register because the array is const.  But it
didn't.


> Also: sorry, but ugh-at-the-naming.  We don't *gain* anything from having
> idenitifers called f, of, m, n and rf.  And we lose quite a lot in
> readability and understandability.  It would be much nicer to invest a
> little bit more typing-time here, IMO.

That's Davide's code and I didn't change it because it doesn't really
matter.  This is a trivial function which doesn't need more than 10
seconds to be understood.  If you insist I'll rename the variables and
elements but I consider this just busy work.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIH8Tl2ijCOnn/RHQRAm+PAKDEArdgKWXLAMzzfYQ3Q8XzbJdWmgCfavq+
+THu/JEISm+IrX7oyhITYVU=
=F2Co
-----END PGP SIGNATURE-----
