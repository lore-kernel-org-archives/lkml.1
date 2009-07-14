Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZGNDqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZGNDqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZGNDqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:46:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53884 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZGNDqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:46:47 -0400
Date: Tue, 14 Jul 2009 13:46:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: manual merge of the ttydev tree with Linus' tree
Message-Id: <20090714134644.644cb3fc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Today's linux-next merge of the ttydev tree got a conflict in
drivers/usb/serial/sierra.c between commit
7bae0a070db4bc2761dd9515f450cdfa3f3f248c ("USB: Sierra: fix oops upon
device close") from Linus' tree and commit
2db76e5f8b74d5eb0d26a55d4b4e0b2b1c76ff4d ("tty-usb-sierra-updates-pm")
from the ttydev tree.

Just context changes.  I fixed ti up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/sierra.c
index f48d05e,9b22dff..0000000
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@@ -841,7 -884,11 +884,10 @@@ static void sierra_release(struct usb_s
  		portdata = usb_get_serial_port_data(port);
  		if (!portdata)
  			continue;
+ 		portdata->suspend_status = 0;
+ 		device_remove_file(&port->dev, &dev_attr_suspend_status);
+ 
  		kfree(portdata);
 -		usb_set_serial_port_data(port, NULL);
  	}
  }
  
@@@ -864,8 -979,11 +978,11 @@@ static struct usb_serial_driver sierra_
  	.tiocmget          = sierra_tiocmget,
  	.tiocmset          = sierra_tiocmset,
  	.attach            = sierra_startup,
 -	.disconnect        = sierra_disconnect,
 +	.release           = sierra_release,
+ 	.port_probe	   = sierra_create_sysfs_attrs,
  	.read_int_callback = sierra_instat_callback,
+ 	.suspend           = sierra_suspend,
+ 	.resume            = sierra_resume,
  };
  
  /* Functions used by new usb-serial code. */
