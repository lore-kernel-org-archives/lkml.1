Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbYDHMnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbYDHMnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYDHMmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:42:55 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:40188 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751068AbYDHMmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:42:54 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2008 08:42:54 EDT
X-YMail-OSG: GlRR1nAVM1kPToavz6y5r2HdXCFpEzdpZF0HkR0fdgWAUXOoLeRgZaFe2XarLOwRTUf5JAE44yB8jCFOrjhrRWOQjVHafV_nLTrXe1ZgmGGonDEv4e53tQVnVzB7oA--
X-RocketYMMF: eusu_kefuin
Date: Tue, 8 Apr 2008 05:36:12 -0700 (PDT)
From: Eus <eus@member.fsf.org>
Reply-To: eus@member.fsf.org
Subject: proto_register() - Justification for requesting slab allocation
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <722741.62734.qm@web37601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ho!

Currently I am trying to implement a new type of socket in Linux kernel 2.6.21.5.
I am really curious about this function:
        int proto_register(struct proto *prot, int alloc_slab)

I have investigated the source code and knew that, if alloc_slab is set to a
non-zero integer, kmem_cache_create() will create a memory slab for prot->slab.
At the end, when a socket needs to be created and sk_alloc() is invoked to create
the socket object, if prot->slab has been initialized with kmem_cache_create(),
sk_alloc() will simply create the socket object in the slab with
kmem_cache_alloc. Otherwise, sk_alloc() will create the socket object in the
ordinary way with kmalloc().

IMO, kmem_cache_alloc() should be less expensive than kmalloc() and, therefore,
it is a good thing to request slab allocation when invoking proto_register().
But, from all networking protocols that invoke proto_register(), 50% of them,
most of them are data link protocols, does not request slab allocation. The rest
that request slab allocation mainly is network layer protocols. That is why I
wonder whether or not there is an advantage of using kmalloc() over using
kmem_cache_alloc().

A friend of mine said that those that do not request slab allocation do so
because they are rarely used. But, I disagree because, although they are rarely
used, once they are used, they are used heavily, for example AF_PACKET, so that
it is a good idea to request slab allocation.

Therefore, what is the justification for requesting slab allocation or not?

Thank you very much.

Best regards,
Eus


      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com
