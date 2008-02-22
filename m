Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbYBVUDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbYBVUDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759348AbYBVT7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:59:46 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52717 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761790AbYBVT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:59:41 -0500
Date: Fri, 22 Feb 2008 21:58:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, Greg KH <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] usb/serial/io_ti.c: remove unneeded NULL check
Message-ID: <20080222195852.GL1409@cs181133002.pp.htv.fi>
References: <20080219224915.GN31955@cs181133002.pp.htv.fi> <20080219232556.GB1963@suse.de> <2c0942db0802191538k79f93ca5p93a1883a449f3bb0@mail.gmail.com> <20080222101016.37128803@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080222101016.37128803@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 10:10:16AM +0000, Alan Cox wrote:
> > Either the test of port->tty here is unneeded:
> > 
> >  if (port->tty)
> >                port->tty->low_latency = low_latency;
> > 
> > ...or the lack of test of port->tty here is a mistake:
> > 
> > 	 edge_set_termios (port, port->tty->termios);
> 
> Interesting - so coverity doesn't understand the BKL. It's producing the
> right answer, for the right reason but the assumption it makes isn't 100%
> safe.

Coverity doesn't perform magic.
It simply notices that it's once checked and once dereferenced 
unconditionally.

> The check can go.

Thanks, patch below.

> Alan

cu
Adrian


<--  snip  -->


There's no reason for checking pdev->bus for being NULL here (and we'd 
anyway Oops below if it was).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
afefd6935c788b3e4071092ebc04c4d356dd7496 diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index cd34059..700683c 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1944,8 +1944,7 @@ static int edge_open (struct usb_serial_port *port, struct file * filp)
 	if (edge_port == NULL)
 		return -ENODEV;
 
-	if (port->tty)
-		port->tty->low_latency = low_latency;
+	port->tty->low_latency = low_latency;
 
 	port_number = port->number - port->serial->minor;
 	switch (port_number) {

