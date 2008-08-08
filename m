Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbYHHWtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbYHHWtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYHHWs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:48:58 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:47555 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751421AbYHHWs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:48:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=oGj0AeZXpqOrm0jXaspVYokHk45Nd0c+cMZnRAxd+wG0mgBWUqlrHdg6LKk2nbABR8rkWlfZr4Q9YOl9wEsPaRvnohZRHPplq/kcxZVGX58YXVgi2rRNGO02NOiWgESyh6/7DDjTg5LdRexatsro80RXYBeaZWzY4hqLbIRVg1A=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 8 Aug 2008 15:48:56 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <17912.65177.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, suffering from insomnia this morning, I added printk()'s to
net/ipv4/af_inet.c in order to find the code where the freeze
happens.  One of 2 loops was the culprit:

===== BEGIN CODE =======================
#ifdef CONFIG_IP_MULTICAST
    if (inet_add_protocol(&igmp_protocol, IPPROTO_IGMP) < 0)
        printk(KERN_CRIT "inet_init: Cannot add IGMP protocol\n");
#endif
  
    /* Register the socket-side information for inet_create. */
    for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
        INIT_LIST_HEAD(r);

    for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
        inet_register_protosw(q);
  
    /*
     *    Set the ARP module up
     */
===== END CODE =======================

Feeling better, I tried to get a few hours of sleep before I had to
go to work.

Knowing where to focus more attention, I restored the original version
of af_inet.c from the git tree with

    git show HEAD:net/ivp4/af_inet.c

and then made the following changes to discover which loop was
the problem:

===== BEGIN DIFF ========================
  #ifdef CONFIG_IP_MULTICAST
      if (inet_add_protocol(&igmp_protocol, IPPROTO_IGMP) < 0)
          printk(KERN_CRIT "inet_init: Cannot add IGMP protocol\n");
  #endif
  
+     printk("           First loop:\n");
+     printk("             SOCK_MAX = %d\n", SOCK_MAX);
+     int dwindex=0;
      /* Register the socket-side information for inet_create. */
      for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
+       {
+         printk("             initializing:  &inetsw[%d] = %p\n", dwindex, r);
          INIT_LIST_HEAD(r);
+         ++dwindex;
+       }
  
+     printk("           Second loop:\n");
+     printk("             INETSW_ARRAY_LEN = %d\n", INETSW_ARRAY_LEN);
+     printk("             Initial q = %p\n", inetsw_array);
+     printk("             Final   q = %p\n", &inetsw_array[INETSW_ARRAY_LEN]);
+     dwindex=0;
      for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
+       {
+         printk("             initializing:  &q[%d]\n", dwindex);
          inet_register_protosw(q);
+         ++dwindex;
+       }
  
      /*
       *    Set the ARP module up
       */
===== END DIFF ========================

I then built the kernel, installed it, and rebooted.  The following
output was observed:

===== BEGIN OUTPUT ========================
...
NET: Registered protocol family 2
           First loop:
             SOCK_MAX = 11
             initializing:  &initsw[0] = ffffffff809c8460
             initializing:  &initsw[1] = ffffffff809c8470
             initializing:  &initsw[2] = ffffffff809c8480
             initializing:  &initsw[3] = ffffffff809c8490
             initializing:  &initsw[4] = ffffffff809c84a0
             initializing:  &initsw[5] = ffffffff809c84b0
             initializing:  &initsw[6] = ffffffff809c84c0
             initializing:  &initsw[7] = ffffffff809c84d0
             initializing:  &initsw[8] = ffffffff809c84e0
             initializing:  &initsw[9] = ffffffff809c84f0
             initializing:  &initsw[10] = ffffffff809c8500
           Second loop:
             INETSW_ARRAY_LEN = 3
             Initial q = ffffffff806f8a20
             Final   q = ffffffff806f8a60
             initializing:  &q[0]

===== END OUTPUT ========================


This is where my kernels (2.6.26* and 2.6.27*) are freezing, in
the call of inet_register_protosw().

As I find time, I will keep trying to dig deeper.  Hopefully one
of you on the LKML has an idea of what's wrong, because even
though I am familiar with C and C++ I have no background at all
with Linux kernel code itself.


Dave W.
