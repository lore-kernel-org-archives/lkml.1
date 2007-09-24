Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXIXQbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXIXQbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760612AbXIXQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47394 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384AbXIXQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:04 -0400
Date: Mon, 24 Sep 2007 09:21:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <trond@netapp.com>,
       Neil Brown <neilb@suse.de>,
       Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [19/50] rpc: fix garbage in printk in svc_tcp_accept()
Message-ID: <20070924162100.GT13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="rpc-fix-garbage-in-printk-in-svc_tcp_accept.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>

commit 9db619e66503494e41159de3c76fafabe80d016b in mainline.

we upgraded the kernel of a nfs-server from 2.6.17.11 to 2.6.22.6. Since
then we get the message

lockd: too many open TCP sockets, consider increasing the number of nfsd threads
lockd: last TCP connect from ^\\236^\É^D

These random characters in the second line are caused by a bug in
svc_tcp_accept.

(Note: there are two previous __svc_print_addr(sin, buf, sizeof(buf))
calls in this function, either of which would initialize buf correctly;
but both are inside "if"'s and are not necessarily executed.  This is
less obvious in the second case, which is inside a dprintk(), which is a
macro which expands to an if statement.)

Signed-off-by: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svcsock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1090,7 +1090,8 @@ svc_tcp_accept(struct svc_sock *svsk)
 						   serv->sv_name);
 				printk(KERN_NOTICE
 				       "%s: last TCP connect from %s\n",
-				       serv->sv_name, buf);
+				       serv->sv_name, __svc_print_addr(sin,
+							buf, sizeof(buf)));
 			}
 			/*
 			 * Always select the oldest socket. It's not fair,

-- 
