Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbXHYB0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbXHYB0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXHYB0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:26:34 -0400
Received: from mx.treblig.org ([80.68.94.177]:2628 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbXHYB0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:26:33 -0400
Date: Sat, 25 Aug 2007 02:26:30 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: neilb@suse.de
Cc: bfields@fieldses.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070825012630.GB5431@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 02:02:33 up 11 days,  9:17,  1 user,  load average: 0.52, 0.56, 0.59
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  This patch adds the address of the client that caused an
error in sunrpc/svc.c so that you get errors that look like:

svc: 192.168.66.28, port=709 :unknown version (3 for prog 100003, nfsd)

I've seen machines which get bunches of unknown version or similar
errors from time to time, and while the recent patch to add
the service helps to find which service has the wrong version it doesn't
help find the potentially bad client.

  The patch is against a checkout of Linus's git tree made
on 2007-08-24.

  One observation is that the svc_print_addr function
prints to a buffer which in this case makes life a little more complex;
it just feels as if there must be lots of places that print a
connection address - is there a better function to use anywhere?

I think actually there are a few places with semi duplicated code; e.g.
one_sock_name switches on the address family but only currently
has IPV4; I wonder how many other places are similar.

Dave

	Signed-off-by: Dave Gilbert <linux@treblig.org>

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/


--- linux-2.6/net/sunrpc/svc.c.predag	2007-08-25 00:50:06.000000000 +0100
+++ linux-2.6/net/sunrpc/svc.c	2007-08-25 01:34:56.000000000 +0100
@@ -777,6 +777,28 @@ svc_register(struct svc_serv *serv, int 
 }
 
 /*
+ * Printk the given error with the address of the client that caused it.
+ */
+static int
+svc_printkerr(struct svc_rqst *rqstp, const char* fmt,...)
+{
+	va_list args;
+	int 	r;
+	char 	buf[RPC_MAX_ADDRBUFLEN];
+
+	if (!net_ratelimit())
+		return 0;
+
+	printk("svc: %s :", svc_print_addr(rqstp, buf, sizeof(buf)));
+
+	va_start(args, fmt);
+	r = vprintk(fmt, args);
+	va_end(args);
+
+	return r;
+}
+
+/*
  * Process the RPC request.
  */
 int
@@ -963,14 +985,13 @@ svc_process(struct svc_rqst *rqstp)
 	return 0;
 
 err_short_len:
-	if (net_ratelimit())
-		printk("svc: short len %Zd, dropping request\n", argv->iov_len);
+	svc_printkerr(rqstp, "short len %Zd, dropping request\n",
+			argv->iov_len);
 
 	goto dropit;			/* drop request */
 
 err_bad_dir:
-	if (net_ratelimit())
-		printk("svc: bad direction %d, dropping request\n", dir);
+	svc_printkerr(rqstp, "bad direction %d, dropping request\n", dir);
 
 	serv->sv_stats->rpcbadfmt++;
 	goto dropit;			/* drop request */
@@ -1000,8 +1021,7 @@ err_bad_prog:
 	goto sendit;
 
 err_bad_vers:
-	if (net_ratelimit())
-		printk("svc: unknown version (%d for prog %d, %s)\n",
+	svc_printkerr(rqstp, "unknown version (%d for prog %d, %s)\n",
 		       vers, prog, progp->pg_name);
 
 	serv->sv_stats->rpcbadfmt++;
@@ -1011,16 +1031,14 @@ err_bad_vers:
 	goto sendit;
 
 err_bad_proc:
-	if (net_ratelimit())
-		printk("svc: unknown procedure (%d)\n", proc);
+	svc_printkerr(rqstp, "unknown procedure (%d)\n", proc);
 
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROC_UNAVAIL);
 	goto sendit;
 
 err_garbage:
-	if (net_ratelimit())
-		printk("svc: failed to decode args\n");
+	svc_printkerr(rqstp, "svc: failed to decode args\n");
 
 	rpc_stat = rpc_garbage_args;
 err_bad:
