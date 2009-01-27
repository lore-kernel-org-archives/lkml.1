Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZA0JXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZA0JXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZA0JXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:23:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35314 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZA0JXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:23:20 -0500
Date: Tue, 27 Jan 2009 09:23:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shane Hathaway <shane@hathawaymix.org>
Cc: Daolong Wang <ahlongxp@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       Rob Landley <rob@landley.net>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Message-ID: <20090127092314.GZ28946@ZenIV.linux.org.uk>
References: <20090115194033.GA10926@hack.private> <20090116124158.4364e269.akpm@linux-foundation.org> <200901170328.15178.rob@landley.net> <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com> <20090119152104.GC6432@c2.user-mode-linux.org> <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com> <49753063.8040007@hathawaymix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49753063.8040007@hathawaymix.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 07:01:07PM -0700, Shane Hathaway wrote:
> The problem is that the name "sigprocmask" is getting renamed to
> "kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
> that name gets mangled into "sys_kernel_sigprocmask" by the
> SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.
> 
> So, instead of the patch suggested earlier, I added the following line
> to arch/um/sys-i386/sys_call_table.S:
> 
> #define sys_sigprocmask sys_kernel_sigprocmask

Interesting...  Everything else aside, we have difference in e.g.
SYSCALL_DEFINE0 and SYSCALL_DEFINE3 behaviours: SYSCALL_DEFINE0(name)
will *not* do macro expansion in name and SYSCALL_DEFINE3(name, blah, ...)
will.

The reason is that we have name carried through extra layer of macros
in the latter case.  Argument is *NOT* a subject to expansion when it
is used with ##; however, passing it to another macro will expand it
just fine.

Regardless of the kludge with -D used by uml, I'd say that we want consistency
here; keeping the original behaviour would also be nice.

How about
#define SYSCALL_DEFINE1(name,...)    SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
etc.
with
#define SYSCALL_DEFINEx(x, name, ...)                                   \
        asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
?

That gives consistent behaviour in all cases and avoids the insane side
effects like this one.
