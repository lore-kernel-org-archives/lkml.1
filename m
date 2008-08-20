Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYHTQvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYHTQvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYHTQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:51:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53904 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752614AbYHTQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:51:34 -0400
Date: Wed, 20 Aug 2008 17:33:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Cc: "David Howells" <dhowells@redhat.com>, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Further fix execve error handling
Message-ID: <20080820173320.64ea3892@lxorguk.ukuu.org.uk>
In-Reply-To: <a4423d670808200721i3e9add4cn216da7991f0616f3@mail.gmail.com>
References: <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
	<a4423d670808200721i3e9add4cn216da7991f0616f3@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 18:21:59 +0400
"Alexander Beregalov" <a.beregalov@gmail.com> wrote:

> 2008/8/20 David Howells <dhowells@redhat.com>:
> > Further fix [compat_]do_execve() error handling.  free_bprm() will release the
> > cred_exec_mutex, but only if bprm->cred is not NULL.
> >
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> David, I applied this patch and got the following.
> Is it a different problem?
> I think it is. If yes I will create another topic.
> 
> [   91.266507] [ INFO: possible recursive locking detected ]
> [   91.266862] 2.6.27-rc3-next-20080820-dirty #3

Looks like a false trip of the lock debugging code. I've seen the same
and having dumped the values in tty_do_resize plus the entry/exit paths
it seems to be bogus.

> [   91.267170] ---------------------------------------------
> [   91.267522] sshd/1455 is trying to acquire lock:
> [   91.267840]  (&tty->termios_mutex){--..}, at: [<00000000005b8ca0>]
> tty_do_resize+0x44/0x128
> [   91.268405]
> [   91.268411] but task is already holding lock:
> [   91.268885]  (&tty->termios_mutex){--..}, at: [<00000000005b8c74>]
> tty_do_resize+0x18/0x128

Note that the lock is only acquired in one place in this code and that
the second lock is only take if the two locks differ. Also the second
lock take is not &tty->termios_mutex at all but real_tty.

So I'd say either broken compiler or broken lock debug tools but hey I
could be wrong ;)

Alan
