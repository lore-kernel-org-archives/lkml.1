Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZGFFsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZGFFsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZGFFsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:48:35 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:53997 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZGFFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:48:34 -0400
Date: Mon, 6 Jul 2009 07:48:35 +0200
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Eugene Kapun <abacabadabacaba@gmail.com>, maxk@qualcomm.com,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: tun/tap crashes if open() /dev/net/tun and then poll()
 it.
Message-ID: <20090706074835.3fe641f0@mako-desktop>
In-Reply-To: <20090706011230.GC15156@gondor.apana.org.au>
References: <4A4F1480.70203@gmail.com>
	<20090706001114.2d4517be@mako-desktop>
	<20090706011230.GC15156@gondor.apana.org.au>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 09:12:30 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, Jul 06, 2009 at 12:11:14AM +0200, Mariusz Kozlowski wrote:
> >
> > 	Can you try this patch?
... 
> Good catch.  Can you please resend with a sign-off?

Sure. Just wanted to wait for confirmation from Eugene.

Fix NULL pointer dereference in tun_chr_pool() introduced by
commit 33dccbb050bbe35b88ca8cf1228dcf3e4d4b3554 and triggered
by this code:

	int fd;
	struct pollfd pfd;
	fd = open("/dev/net/tun", O_RDWR);
	pfd.fd = fd;
	pfd.events = POLLIN | POLLOUT;
	poll(&pfd, 1, 0);

Reported-by: Eugene Kapun <abacabadabacaba@gmail.com>
Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a1b0697..bcbb25e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -482,12 +482,14 @@ static unsigned int tun_chr_poll(struct file *file, poll_table * wait)
 {
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = __tun_get(tfile);
-	struct sock *sk = tun->sk;
+	struct sock *sk;
 	unsigned int mask = 0;
 
 	if (!tun)
 		return POLLERR;
 
+	sk = tun->sk;
+
 	DBG(KERN_INFO "%s: tun_chr_poll\n", tun->dev->name);
 
 	poll_wait(file, &tfile->read_wait, wait);

