Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001Ab0A2Qdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0A2Qdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215Ab0A2Qdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:33:38 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47640 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0A2Qdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:33:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bJWrLkKURXMb8iy4jz1IRkic5FK5bcpnZUJgS48RuycMarVYzNzDu8Brklo+x3/mFQ
         FK4pMDQGJZbDTUFGWEXuJHZ1483yaK5FEx0f+sAl48BMZWj8hpAYH61bmi3dVS0a4NUD
         yjvr/ChEwri6cY1JEpPNi57mcfYy3+SXVyeUs=
Subject: [PATCH] xfrm: Change initializations order in ipsec_pfkey_init()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <1264778549.3184.28.camel@edumazet-laptop>
References: <20100129094822.GA8294@nb-core2.darkstar.lan>
	 <b6fcc0a1001290217l4edb0a0btbafa0c26b6f14ad5@mail.gmail.com>
	 <1264778549.3184.28.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 17:33:26 +0100
Message-ID: <1264782806.3184.42.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 janvier 2010 à 16:22 +0100, Eric Dumazet a écrit :
> Le vendredi 29 janvier 2010 à 12:17 +0200, Alexey Dobriyan a écrit :
> > On Fri, Jan 29, 2010 at 11:48 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> > > with recent kernels I'm seeing this BUG - triggered by racoon - at boot:
> > >
> > > NET: Registered protocol family 15
> > > ------------[ cut here ]------------
> > > kernel BUG at /home/kronos/src/linux-2.6.git/include/net/netns/generic.h:43!
> > > invalid opcode: 0000 [#1] PREEMPT SMP
> > > last sysfs file: /sys/kernel/uevent_seqnum
> > > CPU 1
> > > Pid: 1941, comm: racoon Not tainted 2.6.33-rc5-00271-gbe8cde8-dirty #238 F3Sa      /F3Sa
> > > RIP: 0010:[<ffffffffa03035be>]  [<ffffffffa03035be>] pfkey_create+0x36/0x18b [af_key]
> > 
> > Does it triggers after succesfull boot if you do
> > 
> >     rmmod af_key; modprobe af_key
> > 
> > a couple of times?
> > 
> > Post .config, just in case.
> 
> I am looking at ipsec_pfkey_init()
> 
> We call sock_register(&pfkey_family_ops) before pfkey_net_id being
> initialized (by the call to register_pernet_subsys(&pfkey_net_ops);
> 
> As soon as sock_register(&pfkey_family_ops) is done, another thread can
> open a socket and call pfkey_create()  -> crash
> 
> We should change order of initializations somehow
> 

Something like this (compiled but not tested) patch ?

Should probably be sent to stable team...

[PATCH] xfrm: Change initializations order in ipsec_pfkey_init()

Before allowing other threads to create PF_KEY sockets, we must make
sure pfkey_net_id is properly initialized.

That means calling register_pernet_subsys(&pfkey_net_ops) before 
sock_register(&pfkey_family_ops)

Reported-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/key/af_key.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 76fa6fe..e399ddf 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3807,21 +3807,24 @@ static int __init ipsec_pfkey_init(void)
 	if (err != 0)
 		goto out;
 
-	err = sock_register(&pfkey_family_ops);
-	if (err != 0)
-		goto out_unregister_key_proto;
 	err = xfrm_register_km(&pfkeyv2_mgr);
 	if (err != 0)
-		goto out_sock_unregister;
+		goto out_unregister_key_proto;
+
 	err = register_pernet_subsys(&pfkey_net_ops);
 	if (err != 0)
 		goto out_xfrm_unregister_km;
+
+	err = sock_register(&pfkey_family_ops);
+	if (err != 0)
+		goto out_unregister_pernet;
 out:
 	return err;
+
+out_unregister_pernet:
+	unregister_pernet_subsys(&pfkey_net_ops);
 out_xfrm_unregister_km:
 	xfrm_unregister_km(&pfkeyv2_mgr);
-out_sock_unregister:
-	sock_unregister(PF_KEY);
 out_unregister_key_proto:
 	proto_unregister(&key_proto);
 	goto out;


