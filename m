Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0BXLwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:52:31 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:39371 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab0BXLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JWCxLHVq6yAIA8dpePsPk9fVv6mlf8+E2Y6W7Erp8CJZcUJaahCil7fw6a0nO76JGT
         LkT+bFFaL67xhwqtS/2yEtFOHr+2qMEaqiMjXrd8Hx3S1kpel4rlfUd3x3HGZhxKSbKT
         iuOmUF1ZiP7os3BpLtqN/UvOsU8LXh3OBj77M=
MIME-Version: 1.0
Date: Wed, 24 Feb 2010 22:52:27 +1100
Message-ID: <d45a3acc1002240352r43e546c7x4a40aa7d8e187369@mail.gmail.com>
Subject: tuntap with tun_no_pi and X25 question
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting up tun using X25, I can read X25 from the tun but cannot write
to it, hitting this -EINVAL on write.

/* Get packet from user space buffer */
static __inline__ ssize_t tun_get_user(struct tun_struct *tun,
                                       const struct iovec *iv, size_t count,
                                       int noblock)
{

....
       case TUN_TUN_DEV:
                if (tun->flags & TUN_NO_PI) {
                        switch (skb->data[0] & 0xf0) {
                        case 0x40:
                                pi.proto = htons(ETH_P_IP);
                                break;
                        case 0x60:
                                pi.proto = htons(ETH_P_IPV6);
                                break;
                        default:
                                tun->dev->stats.rx_dropped++;
                                kfree_skb(skb);
                                return -EINVAL;
                        }
                }
....

The 0x40 and 0x60 comes from the first byte of the IP which has the
version there?
With X.25 the first byte changes depending on the call sequence, so it
cant be detected and set in the same way.

Is there a way to for a combination of TUNSETIFF with IFF_TUN |
IFF_NO_PI and TUNSETLINK with ARPHRD_X25 to work?
Probably all the non IP type protocols in if_arp.h have the same issue
with IFF_NO_PI?

thanks,
Andrew
