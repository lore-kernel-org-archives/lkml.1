Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYLEISN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYLEISN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYLEIRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:17:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:26883 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYLEIRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=IyrsimBOqx56ypzTgqyi3XWlQDI4CY44h1MBIWdcbE9hOYOjVrv6qxHorqHdJ8qVlu
         IgdlEjAQyhhsrzHwGA9zKuFr4IhYU7P8zJbi67iYVXcBfO8omuCK5y7IYmpG2xKNAJDP
         SVLB+SOvpyksg9+8SlNFNWdLuSBrgVErW9pdg=
Message-ID: <35476bd20812050017y70c3c729v450cdc3d0c1188de@mail.gmail.com>
Date: Fri, 5 Dec 2008 09:17:51 +0100
From: "m m" <olsajiri@gmail.com>
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: netlink - notify when the socket gets closed
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using netlink in my module. Based on the communication,
this module dynamically creates some internal structure, which
needs to be destroyed when the user level socket is closed (or
the application dies).

I found I could use the netlink_register_notifier function to register
NETLINK_URELEASE callback during the netlink_release function.
But since my module uses the multicast netlink socket communication,
it wont be called:

static int netlink_release(struct socket *sock)
{
        ...

        if (nlk->pid && !nlk->subscriptions) {
                struct netlink_notify n = {
                                                .net = sock_net(sk),
                                                .protocol = sk->sk_protocol,
                                                .pid = nlk->pid,
                                          };
                atomic_notifier_call_chain(&netlink_chain,
                                NETLINK_URELEASE, &n);
        }
        ...

Whats the reason this callback is not called for multicast sockets?

To workaround it I created simple misc device which the user application
opens before creating the netlink socket. This way I get some callbacks
inside the module when the application dies, at least.. pretty ugly :)

Is there a netlink mechanism to be notified when the netlink socket is
closed on the user level side? (when using multicast communication)

Or is there any other design I could use, since I think I'm not alone in
using internal module data which needs to be removed once the application dies.

thanks,
jirka
