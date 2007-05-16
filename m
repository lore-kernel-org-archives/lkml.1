Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXEPL7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXEPL7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbXEPL7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:59:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:14508 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbXEPL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pdce6j2MpzCE7EI6+Vg3d3WOd8RGMUXRAauEjzfRhe2kGJZ3uXiBMCcSqaPUMuWqFSd4nENKMDGjNejVCPdggOJz5d0t/xMlz6PqUlLRUInt57IWV36Q4aE8wi7mwgwPmvR4yVMGxRxy2pVs18G2Zt7ZyE7wpdiH+LwCgH4QOIg=
Message-ID: <a781481a0705160459p2d538d7fu8096bd594d6df2f9@mail.gmail.com>
Date: Wed, 16 May 2007 17:29:34 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: 2.6.21-rc7: BUG: sleeping function called from invalid context at net/core/sock.c:1523
Cc: "Jiri Kosina" <jikos@jikos.cz>, "Greg KH" <gregkh@suse.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, "Cedric Le Goater" <clg@fr.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <a781481a0705160456q778cfb4dk67d754317d57e9bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <462D1B09.9050005@goop.org>
	 <Pine.LNX.4.64.0704232257090.20657@twin.jikos.cz>
	 <Pine.LNX.4.64.0704261625410.20657@twin.jikos.cz>
	 <a781481a0705110629n7c7130c1x3a89fa958b271f20@mail.gmail.com>
	 <Pine.LNX.4.64.0705161124030.25986@twin.jikos.cz>
	 <a781481a0705160436s3564022aybd9b318ec0947d94@mail.gmail.com>
	 <1179315904.10069.67.camel@violet>
	 <a781481a0705160456q778cfb4dk67d754317d57e9bb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Marcel,
> [...]
> > > > > (later)
> > > > > I Googled a bit to see if this problem was faced elsewhere in the kernel
> > > > > too. Saw the following commit by Ingo Molnar
> > > > > (9883a13c72dbf8c518814b6091019643cdb34429):
> > > > > -     lock_sock(sock->sk);
> > > > > +     local_bh_disable();
> > > > > +     bh_lock_sock_nested(sock->sk);
> > > > >       rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
> > > > > -     release_sock(sock->sk);
> > > > > +     bh_unlock_sock(sock->sk);
> > > > > +     local_bh_enable();
> > > > > Is it _really_ *this* simple?
> > > > [...]
> > > > actually this *seems* to be proper solution also for our case, thanks for
> > > > pointing this out. I will think about it once again, do some more tests
> > > > with this locking scheme, and will let you know.
> > >
> > > Yes, I can almost confirm that this (open-coding of spin_lock_bh,
> > > effectively) is the proper solution (Rusty's unreliable guide to
> > > kernel-locking needs to be next to every developer's keyboard :-)
> > > I also came across this idiom in other places in the networking code
> > > so it seems to be pretty much the standard way. I wish I owned
> > > bluetooth hardware, could've tested this for you myself.
> >
> > does this mean we should revert previous changes to the locking or only
> > apply this on top of it?
>
> I've fixed a simple patch on top of 2.6.22-rc1 below.

Eek, please ignore previous one. This one's correct.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

diff -ruNp a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c	2007-05-16 17:31:06.000000000 +0530
+++ b/net/bluetooth/hci_sock.c	2007-05-16 17:38:35.000000000 +0530
@@ -665,7 +665,8 @@ static int hci_sock_dev_event(struct not
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, node, &hci_sk_list.head) {
-			lock_sock(sk);
+			local_bh_disable();
+			bh_lock_sock_nested(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -674,7 +675,8 @@ static int hci_sock_dev_event(struct not

 				hci_dev_put(hdev);
 			}
-			release_sock(sk);
+			bh_unlock_sock(sk);
+			local_bh_enable();
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
