Return-Path: <linux-kernel-owner+w=401wt.eu-S1422778AbXCGRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbXCGRN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422777AbXCGRN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:13:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:42813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422772AbXCGRN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:56 -0500
Message-Id: <20070307171216.439254980@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Daniel Walker <dwalker@mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 018/101] Fix ATM initcall ordering.
Content-Disposition: inline; filename=fix-atm-initcall-ordering.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>

[ATM]: Fix for crash in adummy_init()

This was reported by Ingo Molnar here,

http://lkml.org/lkml/2006/12/18/119

The problem is that adummy_init() depends on atm_init() , but adummy_init()
is called first.

So I put atm_init() into subsys_initcall which seems appropriate, and it
will still get module_init() if it becomes a module.

Interesting to note that you could crash your system here if you just load
the modules in the wrong order.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/atm/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/net/atm/common.c
+++ linux-2.6.20.1/net/atm/common.c
@@ -816,7 +816,8 @@ static void __exit atm_exit(void)
 	proto_unregister(&vcc_proto);
 }
 
-module_init(atm_init);
+subsys_initcall(atm_init);
+
 module_exit(atm_exit);
 
 MODULE_LICENSE("GPL");

--
