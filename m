Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbXGZTB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbXGZTB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934316AbXGZTA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:00:59 -0400
Received: from [12.38.223.190] ([12.38.223.190]:10083 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934239AbXGZTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18088.61269.5608.925496@zeus.sw.starentnetworks.com>
Date: Thu, 26 Jul 2007 15:00:37 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: Re: [PATCH] SCTP: IPv4 mapped addr not returned in SCTPv6 accept()
In-Reply-To: <46A8E027.10802@hp.com>
References: <18087.57737.908842.337891@zeus.sw.starentnetworks.com>
	<46A8E027.10802@hp.com>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad Yasevich writes:
> Can you explain why the sctp_v4 changes are need for the this case?
> I don't see how the code in sctp/protocol.c comes into play for this
> particular bug.

connect() on v6 socket to v4 mapped address will trigger
sctp_v4_to_sk_daddr:

strace:

socket(PF_INET6, SOCK_STREAM, 0x84 /* IPPROTO_??? */) = 3
bind(3, {sa_family=AF_INET6, sin6_port=htons(0), inet_pton(AF_INET6, "::", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 128) = 0
connect(3, {sa_family=AF_INET6, sin6_port=htons(33333), inet_pton(AF_INET6, "::ffff:192.168.207.231", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 128) = 0
getsockname(3, {sa_family=AF_INET6, sin6_port=htons(32771), inet_pton(AF_INET6, "::ffff:192.168.207.234", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28]) = 0
getpeername(3, {sa_family=AF_INET6, sin6_port=htons(33333), inet_pton(AF_INET6, "::ffff:192.168.207.231", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28]) = 0

stack dump:

 [<f8c539de>] sctp_v4_to_sk_daddr+0x3e/0x80 [sctp]
 [<f8c5f6c4>] __sctp_connect+0x2a4/0x520 [sctp]
 [<f8c61810>] sctp_connect+0x60/0x70 [sctp]
 [<c02c4b2c>] inet_dgram_connect+0x4c/0x80
 [<c026dbab>] sys_connect+0x8b/0xd0
 [<c026e711>] sys_socketcall+0xb1/0x260
 [<c0103013>] syscall_call+0x7/0xb

I'm unsure if there is a path to call sctp_v4_to_sk_saddr() but it was
added just to be complete.

v4mapped in sctp_v4_create_accept_sk() probably isn't needed, but
since v4mapped is in sctp_sock not sctp6_sock copying it seems like a
good idea.

-- 
Dave Johnson
Starent Networks

