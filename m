Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZAEV3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZAEV3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZAEV3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:29:30 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43911 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbZAEV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:29:28 -0500
Date: Mon, 5 Jan 2009 22:31:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
Message-ID: <20090105213107.GA27293@uranus.ravnborg.org>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Probably the same issue. The problem is that the first use of a variable 
> is in the OR section of an if statement that does a return.
> 
> 	if (x || !(y = init_me())
> 		return;
> 
> 	use_me(y);
> 

More warnings:
fs/partitions/check.c: In function `rescan_partitions':
fs/partitions/check.c:511: warning: 'state' might be used uninitialized in this function

=> follow same pattern

fs/compat_ioctl.c: In function `ppp_sock_fprog_ioctl_trans':
fs/compat_ioctl.c:859: warning: 'fptr32' might be used uninitialized in this function
fs/compat_ioctl.c: In function `do_fontx_ioctl':
fs/compat_ioctl.c:1082: warning: 'data' might be used uninitialized in this function
fs/compat_ioctl.c: In function `do_atmif_sioc':
fs/compat_ioctl.c:1302: warning: 'data' might be used uninitialized in this function
fs/compat_ioctl.c: In function `do_atm_ioctl':
fs/compat_ioctl.c:1272: warning: 'data' might be used uninitialized in this function
fs/compat_ioctl.c: In function `mtd_rw_oob':
fs/compat_ioctl.c:1421: warning: 'data' might be used uninitialized in this function
fs/compat_ioctl.c: In function `do_usbdevfs_discsignal':
fs/compat_ioctl.c:1650: warning: 'uctx' might be used uninitialized in this function

This is:
        if (get_user(flen, &u_fprog32->len) ||
            get_user(fptr32, &u_fprog32->filter))
                return -EFAULT;


which is a common pattern. I have at least one in sparc64 code too.
I did not come up with a nice solution on this one.

drivers/char/vt_ioctl.c: In function `vt_ioctl':
drivers/char/vt_ioctl.c:945: warning: 'cc' might be used uninitialized in this function

get_user() || get_user() again.

net/core/skbuff.c: In function `___pskb_trim':
net/core/skbuff.c:1041: warning: 'err' might be used uninitialized in this function

if (xxx && err = foo())

net/core/dev.c: In function `skb_gso_segment':
net/core/dev.c:1537: warning: 'err' might be used uninitialized in this function
net/core/dev.c: In function `netif_receive_skb':
net/core/dev.c:2075: warning: 'port' might be used uninitialized in this function

if (xx && err = ...)
if (xx || port = ...)

net/core/neighbour.c: In function `neigh_resolve_output':
net/core/neighbour.c:1188: warning: 'neigh' might be used uninitialized in this function
net/core/neighbour.c: In function `neigh_create':
net/core/neighbour.c:411: warning: 'error' might be used uninitialized in this function

if (xx || neigh = ...)

net/ipv4/ip_output.c: In function `ip_append_data':
net/ipv4/ip_output.c:1006: warning: 'left' might be used uninitialized in this function


net/ipv4/tcp.c: In function `tcp_sendpage':
net/ipv4/tcp.c:687: warning: 'copy' might be used uninitialized in this function
net/ipv4/tcp.c: In function `tcp_sendmsg':
net/ipv4/tcp.c:862: warning: 'copy' might be used uninitialized in this function
net/ipv4/tcp.c: In function `tcp_recvmsg':
net/ipv4/tcp.c:1598: warning: 'chunk' might be used uninitialized in this function


net/ipv4/tcp_ipv4.c: In function `listening_get_next':
net/ipv4/tcp_ipv4.c:1874: warning: 'node' might be used uninitialized in this function
net/ipv4/tcp_ipv4.c: In function `established_get_next':
net/ipv4/tcp_ipv4.c:2012: warning: 'node' might be used uninitialized in this function

net/ipv4/raw.c: In function `__raw_v4_lookup':
net/ipv4/raw.c:113: warning: 'node' might be used uninitialized in this function

net/ipv4/udp.c: In function `__udp4_lib_rcv':
net/ipv4/udp.c:325: warning: 'node' might be used uninitialized in this function
net/ipv4/udp.c:325: warning: 'node' might be used uninitialized in this function

net/ipv4/devinet.c: In function `inet_gifconf':
net/ipv4/devinet.c:821: warning: 'ifa' might be used uninitialized in this function

net/ipv4/ipmr.c: In function `ipmr_get_route':
net/ipv4/ipmr.c:1629: warning: 'vif' might be used uninitialized in this function

net/ipv4/syncookies.c: In function `cookie_v4_check':
net/ipv4/syncookies.c:263: warning: 'mss' might be used uninitialized in this function


I have two warnings in sparc code I will deal with.
One of them is the get_user() || get_user() pattern
so I dunno how to fix it atm.

The above is from a:
make ARCH=sparc64 allmodconfig
make ARCH=sparc64 vmlinux

I did not try to build modules...

	Sam
