Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbYCZSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbYCZSnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbYCZSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:43:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:14562 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbYCZSn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O8HRO7kEg8nVDimlB/mP86fKi8SawoOfUtNVHnp0JXqHMQBstj84aex+FPToNUpZaFvnVUS6/ymJxUg2dTIrl0KFW7xUctJQ58MjHHBikVg5/lwIUFj0m9GCN2xibyTo5DyH5GOcfXlgfub3QH+aP/9v8T9KGhAPIvEIwh+N+c0=
Message-ID: <170fa0d20803261143s1ab258b2ra470c158ac5744a@mail.gmail.com>
Date: Wed, 26 Mar 2008 14:43:23 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: nbd: Oops because nbd doesn't prevent NBD_CLEAR_SOCK while sock_xmit() is working on a receive
Cc: nbd-general-request@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing that nbd_device's socket is getting set to NULL in the
middle of nbd_read_stat()'s sock_xmit().

There appears to be a race where 'nbd-client -d' requests that an NBD
device first disconnect from the nbd-server (via NBD_DISCONNECT ioctl)
and then set the NBD device's socket to NULL, etc (via
NBD_CLEAR_SOCK).

Both NBD_DISCONNECT and NBD_CLEAR_SOCK take the nbd_device's tx_lock
(which protects the socket during transmits) _but_ for receives the
socket can be set to NULL (via NBD_CLEAR_SOCK) at any time while
inside sock_xmit(); as such NBD_CLEAR_SOCK can cause a NULL pointer in
sock_xmit().

Analyzing the crash it is clear that the NULL pointer comes when
sock_xmit()'s do {} while() dereferences the nbd_device's socket with:
sock->sk->sk_allocation = GFP_NOIO;
I also saw that the sock_xmit() caller is nbd_read_stat().

The sequence looks like this:

nbd1: NBD_DISCONNECT
[NOTE: a sock_xmit() send attempt is made on behalf of NBD_DISCONNECT]
nbd1: Send control failed (result -32)
...
[NBD is still dequeueing requests]
...
Race: [NBD_CLEAR_SOCK ioctl][FATAL: nbd_read_stat()'s sock_xmit()
receive attempt causes NULL pointer]

In practice this looks like:

nbd1: NBD_DISCONNECT
nbd1: Send control failed (result -32)
end_request: I/O error, dev nbd1, sector 0
end_request: I/O error, dev nbd1, sector 8032264
md: super_written gets error=-5, uptodate=0
raid1: Disk failure on nbd1, disabling device.
        Operation continuing on 1 devices
Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
 [<ffffffff88b1e125>] :nbd:sock_xmit+0x9d/0x301

The fact that sock_xmit() in receive mode is unprotected seems to be
the WHY a NULL pointer is possible; but I'm still trying to identify
the HOW.

But for me this begs the question:  why isn't the nbd_device's socket
always protected during sock_xmit() for both
transmits and receives; rather than just transmits (via tx_lock)!?

Any help on the "right" fix would be appreciated, thanks.
Mike
