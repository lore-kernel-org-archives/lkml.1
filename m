Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZCDCjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZCDCjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCDCjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:39:03 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:29119 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZCDCjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:39:00 -0500
Message-ID: <49ADE9BE.2040303@hp.com>
Date: Tue, 03 Mar 2009 21:38:54 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrey Borzenkov <arvidjaar@mail.ru>,
       Vladislav Yasevich <vladislav.yasevich@hp.com>,
       Chuck Lever <chuck.lever@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       bonding-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?=22J=2EA=2E_Magall?= =?ISO-8859-1?Q?=F3n=22?= 
	<jamagallon@ono.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Vosburgh <fubar@us.ibm.com>
Subject: [PATCH 2/2] SCTP: change sctp_ctl_sock_init() to try IPv4 if IPv6
 fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change sctp_ctl_sock_init() to try IPv4 if IPv6 socket registration
fails.  Required if the IPv6 module is loaded with "disable=1",
else SCTP will fail to load.


Signed-off-by: Brian Haley <brian.haley@hp.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
  net/sctp/protocol.c |   11 ++++++++---
  1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c1e316e..e8c6287 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -692,15 +692,20 @@ static int sctp_inetaddr_event(struct notifier_block 
*this, unsigned long ev,
  static int sctp_ctl_sock_init(void)
  {
  	int err;
-	sa_family_t family;
+	sa_family_t family = PF_INET;

  	if (sctp_get_pf_specific(PF_INET6))
  		family = PF_INET6;
-	else
-		family = PF_INET;

  	err = inet_ctl_sock_create(&sctp_ctl_sock, family,
  				   SOCK_SEQPACKET, IPPROTO_SCTP, &init_net);
+
+	/* If IPv6 socket could not be created, try the IPv4 socket */
+	if (err < 0 && family == PF_INET6)
+		err = inet_ctl_sock_create(&sctp_ctl_sock, AF_INET,
+					   SOCK_SEQPACKET, IPPROTO_SCTP,
+					   &init_net);
+
  	if (err < 0) {
  		printk(KERN_ERR
  		       "SCTP: Failed to create the SCTP control socket.\n");
-- 
1.5.4.3

