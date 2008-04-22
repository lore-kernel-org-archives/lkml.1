Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYDVMhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYDVMhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYDVMhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:37:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42062 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYDVMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:37:17 -0400
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <20080311225926.6515e18c.akpm@linux-foundation.org>
References: <97a0a9ac0803112235l157706adoa84b131549a46049@mail.gmail.com>
	 <20080311225926.6515e18c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 13:37:11 +0100
Message-Id: <1208867831.9212.582.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 22:59 -0700, Andrew Morton wrote:
> Now, af_unix_init() uses module_init(), which is really __initcall(), which
> is really device_initcall() (ug, don't ask).

... which is really __define_initcall("6", ...);.

> So you can do what you're sugesting here by locating the caller/callers of
> parse_mtd_partitions() and marking them late_initcall().

Better still, just initialise af_unix earlier so that it's there before
any normal drivers which happen to call request_module(). Since core
network stuff is initialised with subsys_initcall() which is really
__define_initcall("4", ...), we can initialise af_unix with
fs_initcall() which is really __define_initcall("5", ...).


---
[AF_UNIX] Initialise UNIX sockets before general device initcalls

When drivers call request_module(), it tries to do something with UNIX
sockets and triggers a 'runaway loop modprobe net-pf-1' warning. Avoid
this by initialising AF_UNIX support earlier.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

--- linux-2.6.24.ppc/net/unix/af_unix.c~	2008-04-13 13:38:25.000000000 +0100
+++ linux-2.6.24.ppc/net/unix/af_unix.c	2008-04-22 13:01:45.000000000 +0100
@@ -2193,7 +2193,11 @@ static void __exit af_unix_exit(void)
 	unregister_pernet_subsys(&unix_net_ops);
 }
 
-module_init(af_unix_init);
+/* Earlier than device_initcall() so that other drivers invoking
+   request_module() don't end up in a loop when modprobe tries
+   to use a UNIX socket. But later than subsys_initcall() because
+   we depend on stuff initialised there */
+fs_initcall(af_unix_init);
 module_exit(af_unix_exit);
 
 MODULE_LICENSE("GPL");


-- 
dwmw2

