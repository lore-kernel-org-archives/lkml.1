Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbYBMODJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbYBMODJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYBMOCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:02:55 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22197 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbYBMOCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:02:55 -0500
Message-ID: <47B2F88D.7080300@msgid.tls.msk.ru>
Date: Wed, 13 Feb 2008 17:02:53 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.24: RPC: bad TCP reclen 0x00020090 (large)
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

After upgrading to 2.6.24 (from .23), we're seeing ALOT
of messages like in $subj in dmesg:

Feb 13 13:21:39 paltus kernel: RPC: bad TCP reclen 0x00020090 (large)
Feb 13 13:21:46 paltus kernel: printk: 3586 messages suppressed.
Feb 13 13:21:46 paltus kernel: RPC: bad TCP reclen 0x00020090 (large)
Feb 13 13:21:49 paltus kernel: printk: 371 messages suppressed.
Feb 13 13:21:49 paltus kernel: RPC: bad TCP reclen 0x00020090 (large)
Feb 13 13:21:55 paltus kernel: printk: 2979 messages suppressed.
...

with linux NFS server.  The clients are all linux too, mostly 2.6.23
and some 2.6.22.

I found the "offending" piece of code in net/sunrpc/svcsock.c,
in routine svc_tcp_recvfrom() with condition being:

   if (svsk->sk_reclen > serv->sv_max_mesg) ...

This happens after a server reboot.  At this point, client(s) are trying
to perform some NFS transaction and fail, and server starts generating
the above messages - till I do a umount followed by mount on all clients.
Before, such situation (nfs server reboot) were handled transparently,
ie, there was nothing to do, the mount continued working just fine when
the server comes back online.

Now, I'm not sure if it's really 2.6.24-specific problem or a userspace
problem.  Some time ago we also upgraded nfs-kernel-server (Debian)
package, and the remount-after-nfs-server-reboot problem started to
occur at THAT time (and it is something to worry about as well, I just
had no time to deal with it); but the dmesg spamming only appeared
with 2.6.24.

How to debug the issue further on from this point?

Thanks!

/mjt
