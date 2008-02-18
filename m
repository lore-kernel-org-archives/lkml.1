Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYBRNAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYBRNAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYBRNAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:00:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbYBRM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:59:58 -0500
Date: Mon, 18 Feb 2008 04:58:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: 2.6.24: RPC: bad TCP reclen 0x00020090 (large)
Message-Id: <20080218045812.f1dc6f71.akpm@linux-foundation.org>
In-Reply-To: <47B2F88D.7080300@msgid.tls.msk.ru>
References: <47B2F88D.7080300@msgid.tls.msk.ru>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(suitable cc added)

(regression)

On Wed, 13 Feb 2008 17:02:53 +0300 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Hello!
> 
> After upgrading to 2.6.24 (from .23), we're seeing ALOT
> of messages like in $subj in dmesg:
> 
> Feb 13 13:21:39 paltus kernel: RPC: bad TCP reclen 0x00020090 (large)
> Feb 13 13:21:46 paltus kernel: printk: 3586 messages suppressed.
> Feb 13 13:21:46 paltus kernel: RPC: bad TCP reclen 0x00020090 (large)
> Feb 13 13:21:49 paltus kernel: printk: 371 messages suppressed.
> Feb 13 13:21:49 paltus kernel: RPC: bad TCP reclen 0x00020090 (large)
> Feb 13 13:21:55 paltus kernel: printk: 2979 messages suppressed.
> ...
> 
> with linux NFS server.  The clients are all linux too, mostly 2.6.23
> and some 2.6.22.
> 
> I found the "offending" piece of code in net/sunrpc/svcsock.c,
> in routine svc_tcp_recvfrom() with condition being:
> 
>    if (svsk->sk_reclen > serv->sv_max_mesg) ...
> 
> This happens after a server reboot.  At this point, client(s) are trying
> to perform some NFS transaction and fail, and server starts generating
> the above messages - till I do a umount followed by mount on all clients.
> Before, such situation (nfs server reboot) were handled transparently,
> ie, there was nothing to do, the mount continued working just fine when
> the server comes back online.
> 
> Now, I'm not sure if it's really 2.6.24-specific problem or a userspace
> problem.  Some time ago we also upgraded nfs-kernel-server (Debian)
> package, and the remount-after-nfs-server-reboot problem started to
> occur at THAT time (and it is something to worry about as well, I just
> had no time to deal with it); but the dmesg spamming only appeared
> with 2.6.24.
> 
> How to debug the issue further on from this point?
> 


