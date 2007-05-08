Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbXEHGaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbXEHGaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbXEHGaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:30:16 -0400
Received: from gw.goop.org ([64.81.55.164]:43483 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbXEHGaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:30:14 -0400
Message-ID: <464018F2.7050409@goop.org>
Date: Mon, 07 May 2007 23:30:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 25/29] xen: Add the Xen virtual network device driver.
References: <20070504232051.411946839@goop.org>	 <20070504232121.492190579@goop.org> <20070505091624.GA8890@infradead.org>	 <463F9608.40803@goop.org> <1178577322.28438.16.camel@localhost.localdomain>
In-Reply-To: <1178577322.28438.16.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Looks good, you can slightly improve it to be the model use of new
> module_param types by calling your functions param_set_rx_mode and
> param_get_rx_mode, then simply using "module_param(rx_mode, rx_mode,
> 0400)"
>   

Cute.  I tried it out, but it doesn't yield an obvious improvement:

diff -r 83d67449bff4 drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c	Mon May 07 18:44:11 2007 -0700
+++ b/drivers/net/xen-netfront.c	Mon May 07 22:58:36 2007 -0700
@@ -67,13 +67,16 @@ struct netfront_cb {
  * For fully-virtualised guests there is no option - copying must be used.
  * For paravirtualised guests, flipping is the default.
  */
-static enum rx_mode {
+typedef enum rx_mode {
 	RX_COPY = 0,
 	RX_FLIP = 1,
-} rx_mode = RX_FLIP;
-MODULE_PARM_DESC(rx_mode, "How to get packets from card: \"copy\" or \"flip\"");
-
-static int set_rx_mode(const char *val, struct kernel_param *kp)
+} rx_mode_t;
+
+static enum rx_mode rx_mode = RX_FLIP;
+
+#define param_check_rx_mode_t(name, p) __param_check(name, p, rx_mode_t)
+
+static int param_set_rx_mode_t(const char *val, struct kernel_param *kp)
 {
 	enum rx_mode *rxmp = kp->arg;
 	int ret = 0;
@@ -88,14 +91,15 @@ static int set_rx_mode(const char *val, 
 	return ret;
 }
 
-static int get_rx_mode(char *buffer, struct kernel_param *kp)
+static int param_get_rx_mode_t(char *buffer, struct kernel_param *kp)
 {
 	enum rx_mode *rxmp = kp->arg;
 
 	return sprintf(buffer, "%s", *rxmp == RX_COPY ? "copy" : "flip");
 }
 
-module_param_call(rx_mode, set_rx_mode, get_rx_mode, &rx_mode, 0400);
+MODULE_PARM_DESC(rx_mode, "How to get packets from card: \"copy\" or \"flip\"");
+module_param(rx_mode, rx_mode_t, 0400);
 
 #define RX_COPY_THRESHOLD 256
 


