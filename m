Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYBYJ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYBYJ4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYBYJzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:55:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:24336 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbYBYJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T25ZmIe7ygMvixw3/k6jMp61KX7mbIn07xNhVJ8t2zfBOnaaKIE5DAMvhG2elo1+wv4q4Pa/sgUyIqkEVtxxjLbUZ1uABgrpCtXk6mYTCY6HNfK6ow5lBxs8pGPv105f85XSmS5kw9g6ZLCGY5tgYICGbrq8ryjrXnQVeHr3xXU=
Message-ID: <a8e1da0802250155u1b7af481va203849f68d9106b@mail.gmail.com>
Date: Mon, 25 Feb 2008 17:55:43 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Louis JANG" <louis@mizi.com>
Subject: Re: [Bluez-devel] forcing SCO connection patch
Cc: linux-bluetooth@vger.kernel.org, "Marcel Holtmann" <marcel@holtmann.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, bmidgley@gmail.com,
       "David Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
In-Reply-To: <47C28A33.4070102@mizi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47666E1F.2000902@mizi.com>
	 <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>
	 <47C28A33.4070102@mizi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 5:28 PM, Louis JANG <louis@mizi.com> wrote:
>
>  > I ever asked marcel about the coding style. please see following thread:
>  > http://lkml.org/lkml/2008/1/22/91
>  >
>  > I think the style problem marcel said is
>  > 1. using kernel codeing style
>  > 2. marcel's style
>  > container_of or get_user_data calls at the top of the variable declaration
>  > using the empty lines to seperate code blocks
>  >
>  > Please rework your patch and resend if you fixed them.
>  >
>  > BTW, please use the new bluetooth mailing list for kerne issue.
>  > linux-bluetooth@vger.kernel.org
>  >
>  > (Thanks for andrew and davem)
>  >
>  > Regards
>  > dave
>  >
>  > Regards
>  > dave
>  >
>  >
>
>  Hi all,
>
>  I adjusted indentation of the patches

Not enough.

Please first read Documentation/CodingStyle, fix them, and
then use scripts/checkpatch.pl to check your patch.

>but I'm not sure what's wrong
>  about second comment of Marcel. please let me know if there are another
>  problems in this patch.
>
>  Thanks in advance,
>  Louis JANG
>
>
> --- net/bluetooth/hci_event.c.orig      2008-02-25 17:17:11.000000000 +0900
>  +++ net/bluetooth/hci_event.c   2008-02-25 17:30:23.000000000 +0900
>  @@ -1313,8 +1313,17 @@
>         hci_dev_lock(hdev);
>
>         conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
>  -       if (!conn)
>  -               goto unlock;
>  +       if (!conn) {
>  +               if (ev->link_type != ACL_LINK) {
>  +                       __u8 link_type = (ev->link_type == ESCO_LINK) ? SCO_LINK : ESCO_LINK;
>  +
>  +                       conn = hci_conn_hash_lookup_ba(hdev, link_type, &ev->bdaddr);
>  +                       if (conn)
>  +                               conn->type = ev->link_type;
>  +               }
>  +               if (!conn)
>  +                       goto unlock;
>  +       }
>
>         if (!ev->status) {
>                 conn->handle = __le16_to_cpu(ev->handle);
>
> diff -uNr include/net/bluetooth-orig/sco.h include/net/bluetooth/sco.h
>  --- include/net/bluetooth-orig/sco.h    2007-10-10 05:31:38.000000000 +0900
>  +++ include/net/bluetooth/sco.h 2008-02-25 18:04:20.000000000 +0900
>  @@ -51,6 +51,8 @@
>         __u8  dev_class[3];
>   };
>
>  +#define SCO_FORCESCO   0x03
>  +
>   /* ---- SCO connections ---- */
>   struct sco_conn {
>         struct hci_conn *hcon;
>  @@ -74,6 +76,7 @@
>         struct bt_sock  bt;
>         __u32           flags;
>         struct sco_conn *conn;
>  +       unsigned int    force_sco :1;
>   };
>
>   #endif /* __SCO_H */
>  diff -uNr net/bluetooth-orig/hci_conn.c net/bluetooth/hci_conn.c
>  --- net/bluetooth-orig/hci_conn.c       2008-02-25 17:58:27.000000000 +0900
>  +++ net/bluetooth/hci_conn.c    2008-02-25 18:02:04.000000000 +0900
>  @@ -354,7 +354,7 @@
>
>         if (acl->state == BT_CONNECTED &&
>                         (sco->state == BT_OPEN || sco->state == BT_CLOSED)) {
>  -               if (lmp_esco_capable(hdev))
>  +               if (type == ESCO_LINK)
>                         hci_setup_sync(sco, acl->handle);
>                 else
>                         hci_add_sco(sco, acl->handle);
>  diff -uNr net/bluetooth-orig/sco.c net/bluetooth/sco.c
>  --- net/bluetooth-orig/sco.c    2008-02-25 17:58:27.000000000 +0900
>  +++ net/bluetooth/sco.c 2008-02-25 18:08:51.000000000 +0900
>  @@ -200,7 +200,10 @@
>
>         err = -ENOMEM;
>
>  -       type = lmp_esco_capable(hdev) ? ESCO_LINK : SCO_LINK;
>  +       if (sco_pi(sk)->force_sco)
>  +               type = SCO_LINK;
>  +       else
>  +               type = lmp_esco_capable(hdev) ? ESCO_LINK : SCO_LINK;
>
>         hcon = hci_connect(hdev, type, dst);
>         if (!hcon)
>  @@ -660,12 +663,21 @@
>   {
>         struct sock *sk = sock->sk;
>         int err = 0;
>  +       unsigned int force_sco;
>
>         BT_DBG("sk %p", sk);
>
>         lock_sock(sk);
>
>         switch (optname) {
>  +       case SCO_FORCESCO:
>  +               if (copy_from_user((char *)&force_sco, optval, sizeof(unsigned int))) {
>  +                       err = -EFAULT;
>  +                       break;
>  +               }
>  +               sco_pi(sk)->force_sco = (force_sco != 0);
>  +               break;
>  +
>         default:
>                 err = -ENOPROTOOPT;
>                 break;
>  @@ -681,6 +693,7 @@
>         struct sco_options opts;
>         struct sco_conninfo cinfo;
>         int len, err = 0;
>  +       unsigned int force_sco;
>
>         BT_DBG("sk %p", sk);
>
>  @@ -721,6 +734,13 @@
>
>                 break;
>
>  +       case SCO_FORCESCO:
>  +               force_sco = sco_pi(sock)->force_sco;
>  +               if (copy_to_user(optval, (char *)&force_sco, sizeof(unsigned int)))
>  +                       err = -EFAULT;
>  +
>  +               break;
>  +
>         default:
>                 err = -ENOPROTOOPT;
>                 break;
>
>
