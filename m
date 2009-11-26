Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZKZLKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZKZLKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZKZLKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:10:31 -0500
Received: from blue-labs.org ([72.34.249.230]:60782 "EHLO blue-labs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbZKZLK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:10:29 -0500
X-Greylist: delayed 2143 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2009 06:10:29 EST
X-Authenticated-Colt: Submitter authenticated to send mail
Message-ID: <4B0E5994.1000108@blue-labs.org>
Date: Thu, 26 Nov 2009 05:33:56 -0500
From: David Ford <david@blue-labs.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091123)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] additional update of dev_net(net) to struct *net in ip_fragment.c,
 NULL ptr OOPS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipv4 ip_frag_reasm(), fully replace 'dev_net(dev)' with 'net', defined
previously patched into 2.6.29.

--- linux-2.6.32-rc8/net/ipv4/ip_fragment.c.orig 2009-09-09
18:13:59.000000000 -0400
+++ linux-2.6.32-rc8/net/ipv4/ip_fragment.c      2009-11-26
05:02:43.000000000 -0500
@@ -563,7 +563,7 @@
                printk(KERN_INFO "Oversized IP packet from %pI4.\n",
                        &qp->saddr);
 out_fail:
-       IP_INC_STATS_BH(dev_net(dev), IPSTATS_MIB_REASMFAILS);
+       IP_INC_STATS_BH(net, IPSTATS_MIB_REASMFAILS);
        return err;
 }

Signed-off-by: David Ford <david@blue-labs.org>



Between 2.6.28.10 and 2.6.29, net/ipv4/ip_fragment.c was patched,
changing from dev_net(dev) to container_of(...).  Unfortunately the goto
section (out_fail) on oversized packets inside ip_frag_reasm() didn't
get touched up as well.  Oversized IP packets cause a NULL pointer
dereference and immediate hang.

I discovered this running openvasd and my previous email on this is
titled:  NULL pointer dereference at 2.6.32-rc8:net/ipv4/ip_fragment.c:566

-david

