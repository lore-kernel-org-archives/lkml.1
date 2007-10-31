Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbXJaJ77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbXJaJ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXJaJ7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:59:50 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:34158 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXJaJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:59:50 -0400
Subject: Re: [PATCH]bluetooth: hci_sysfs connection bus_id add support for
	diffrent hci device
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <a8e1da0710310213r1e4f3d7ckcbdf2e6bf854745e@mail.gmail.com>
References: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
	 <20071031.000141.241824894.davem@davemloft.net>
	 <1193817409.32459.10.camel@violet>
	 <a8e1da0710310213r1e4f3d7ckcbdf2e6bf854745e@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-ymq5j0ZohrYXUT6+QU9b"
Date: Wed, 31 Oct 2007 10:59:32 +0100
Message-Id: <1193824773.32459.22.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ymq5j0ZohrYXUT6+QU9b
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Dave,

> > > > diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
> > > > --- linux/net/bluetooth/hci_sysfs.c 2007-10-31 10:21:00.000000000 +0800
> > > > +++ linux.new/net/bluetooth/hci_sysfs.c     2007-10-31 10:21:55.000000000 +0800
> > > > @@ -302,7 +302,8 @@ void hci_conn_add_sysfs(struct hci_conn
> > > >     conn->dev.release = bt_release;
> > > >
> > > >     snprintf(conn->dev.bus_id, BUS_ID_SIZE,
> > > > -                   "%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > > > +                   "%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > > > +                   hdev->name,
> > > >                     conn->type == ACL_LINK ? "acl" : "sco",
> > > >                     ba->b[5], ba->b[4], ba->b[3],
> > > >                     ba->b[2], ba->b[1], ba->b[0]);
> > >
> > > This might not work.
> > >
> > > Your device's name is already 15 characters long,
> > > BUS_ID_SIZE is 20, and it seems hdev->name could
> > > easily overflow the 4 or 5 characters of space
> > > remaining.
> >
> > and should also be not needed since their parents are different. However
> > we had to add the connections to a bus. Otherwise the userspace will
> > never see them. I have to think about the right solution for this
> > problem.
> 
> Maybe we can use this instead:
>  	snprintf(conn->dev.bus_id, BUS_ID_SIZE,
> -			"%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> +			"%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> +			hdev->name + 3,
>  			conn->type == ACL_LINK ? "acl" : "sco",
>  			ba->b[5], ba->b[4], ba->b[3],
>  			ba->b[2], ba->b[1], ba->b[0]);

I had a look on how other subsystems handle this case and yes, they
duplicate the id number from its parent device. So I applied the
attached patch to my tree.

The best would be to use '"%d-%d", hdev->id, conn->handle', but at the
time we create the hci_conn structure and add the sysfs entry the
connection handle is not know yet. I have to look into that and see if
that can be changed.

Regards

Marcel


--=-ymq5j0ZohrYXUT6+QU9b
Content-Disposition: attachment; filename=patch
Content-Type: text/x-patch; name=patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index cef1e3e..0cd9bd5 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -302,8 +302,8 @@ void hci_conn_add_sysfs(struct hci_conn *conn)
 	conn->dev.release = bt_release;
 
 	snprintf(conn->dev.bus_id, BUS_ID_SIZE,
-			"%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
-			conn->type == ACL_LINK ? "acl" : "sco",
+			"%d-%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
+			hdev->id, conn->type == ACL_LINK ? "acl" : "sco",
 			ba->b[5], ba->b[4], ba->b[3],
 			ba->b[2], ba->b[1], ba->b[0]);
 

--=-ymq5j0ZohrYXUT6+QU9b--

