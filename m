Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYHHKce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYHHKce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYHHKcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:32:22 -0400
Received: from web82106.mail.mud.yahoo.com ([209.191.84.219]:46377 "HELO
	web82106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753445AbYHHKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:32:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Vh5Sq/5DUHqxA9f/aizoKApTYbu8ggNNZPier8aJZfLEgtfFMuY9woB08/URW+dE4dlRjnAd+F+njYlkMQ5BVmJZnbiEdMH1LTo5ylF9voV9R4wRlW1NE59SBmpfVr3NKkzsph6Jr0m55gXQmeQM+gpSdRnI7diNe1A1jLdZCQk=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 8 Aug 2008 03:32:19 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <890839.70039.qm@web82106.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, even though I am not a developer, I _hate_ feeling powerless to help...
so I went looking for more details about where the freeze is occuring.

First, I updated my git tree:
===== BEGIN INFO ========================

$ head Makefile    
VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 27
EXTRAVERSION = -rc2
NAME = Rotary Wombat

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
# More info can be located in ./README
# Comments in this file are targeted only to the developer, do not


$ git show |head
commit 685d87f7ccc649ab92b55e18e507a65d0e694eb9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Aug 6 19:24:47 2008 -0700

    Revert "pcm_native.c: remove unused label"
    
    This reverts commit 680db0136e0778a0d7e025af7572c6a8d82279e2.  The label
    is actually used, but hidden behind CONFIG_SND_DEBUG and the horrible
    snd_assert() macro.
===== END INFO ========================

Since the last initcall function listed before the freeze was inet_init(), 
I decided to try to locate the files involved using 'grep -R'.  I found
that inet_init() is defined in 'net/ipv4/af_inet.c'.  So, I thought it
wouldn't hurt to print some more info during the kernel boot process, and
I added some debugging printk() calls to af_inetc.:

===== BEGIN DIFF ========================
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8a3ac1f..8e98094 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1421,14 +1421,17 @@ static int __init inet_init(void)

    BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));

+   printk("           Calling proto_register(&tcp_prot, 1)\n");
    rc = proto_register(&tcp_prot, 1);
    if (rc)
        goto out;

+   printk("           Calling proto_register(&udp_prot, 1)\n");
    rc = proto_register(&udp_prot, 1);
    if (rc)
        goto out_unregister_tcp_proto;

+   printk("           Calling proto_register(&raw_prot, 1)\n");
    rc = proto_register(&raw_prot, 1);
    if (rc)
        goto out_unregister_udp_proto;
@@ -1437,15 +1440,18 @@ static int __init inet_init(void)
     *    Tell SOCKET that we are alive...
     */

+   printk("           Calling sock_register()\n");
    (void)sock_register(&inet_family_ops);

 #ifdef CONFIG_SYSCTL
+   printk("           Calling ip_static_sysctl_init()\n");
    ip_static_sysctl_init();
 #endif

    /*
     *    Add all the base protocols.
     */
+   printk("           Adding base protocols\n");

    if (inet_add_protocol(&icmp_protocol, IPPROTO_ICMP) < 0)
        printk(KERN_CRIT "inet_init: Cannot add ICMP protocol\n");
@@ -1459,6 +1465,7 @@ static int __init inet_init(void)
 #endif

    /* Register the socket-side information for inet_create. */
+   printk("           Initializing lists for inet_create\n");
    for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
        INIT_LIST_HEAD(r);

@@ -1469,23 +1476,31 @@ static int __init inet_init(void)
     *    Set the ARP module up
     */

+   printk("           Calling arp_init()\n");
    arp_init();

    /*
     *    Set the IP module up
     */

+   printk("           Calling\n");
+
+   printk("           Calling ip_init()\n");
    ip_init();

+   printk("           Calling tcp_v4_init()\n");
    tcp_v4_init();

    /* Setup TCP slab cache for open requests. */
+   printk("           Calling tcp_init()\n");
    tcp_init();

    /* Setup UDP memory threshold */
+   printk("           Calling udp_init()\n");
    udp_init();

    /* Add UDP-Lite (RFC 3828) */
+   printk("           Calling udplit4_register()\n");
    udplite4_register();

    /*
@@ -1509,10 +1524,13 @@ static int __init inet_init(void)
    if (init_ipv4_mibs())
        printk(KERN_CRIT "inet_init: Cannot init ipv4 mibs\n");

+   printk("           Calling ipv4_proc_init()\n");
    ipv4_proc_init();

+   printk("           Calling ipfrag_init()\n");
    ipfrag_init();

+   printk("           Calling dev_add_pack(&ip_packet_type)\n");
    dev_add_pack(&ip_packet_type);

    rc = 0;
===== END DIFF ========================

[Hopefully the text formatting is preserved in the emails.  The
archived messages via the web interface have their  whitespace 
formatting totally destroyed!]


After building and running the kernel, the last line on the terminal was:

    Initializing lists for inet_create

So the freeze occurs in this "for" loop (or the loop immediately 
following it):

    for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
        INIT_LIST_HEAD(r);


HTH,
Dave W.
