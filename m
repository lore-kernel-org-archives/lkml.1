Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbXLTTjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbXLTTjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbXLTTjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:39:45 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38716 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXLTTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:39:44 -0500
Message-ID: <476AC51F.70400@davidnewall.com>
Date: Fri, 21 Dec 2007 06:10:15 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hawking.rebel.net.au-4809-1198179583-0001-2"
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel bug: bluetooth meets TTY layer
References: <476A895C.7040903@linux.intel.com>
In-Reply-To: <476A895C.7040903@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hawking.rebel.net.au-4809-1198179583-0001-2
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Arjan,

I've not been able to find this file, "drivers/bluetooth/hci_tty.c", but 
anyway, This seems to be what happens: Hci_uart_close() flushes using 
hci_uart_flush().  Subsequently, in hci_dev_do_close(), (one step in 
hci_unregister_dev()), hci_uart_flush() is called again.  The comment in 
uart_flush_buffer(), relating to the WARN_ON(), indicates you can't 
flush after the port is closed; which sounds reasonable.  I think 
hci_uart_close() should set hdev->flush to NULL before returning.  
Hci_dev_do_close() does check for this.  The code path is rather 
involved and I'm not entirely clear of all steps, but I think that's 
what should be done.

Patch for stupidly obsolete kernel attached.

David

--=_hawking.rebel.net.au-4809-1198179583-0001-2
Content-Type: text/x-diff; name="hci_ldisc.c.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hci_ldisc.c.patch"

--- hci_ldisc.c	2007-09-11 02:54:02.000000000 +0930
+++ hci_ldisc.c.new	2007-12-21 06:03:11.000000000 +1030
@@ -203,16 +203,17 @@
 static int hci_uart_close(struct hci_dev *hdev)
 {
 	BT_DBG("hdev %p", hdev);
 
 	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
 		return 0;
 
 	hci_uart_flush(hdev);
+	hdev->flush = NULL;
 	return 0;
 }
 
 /* Send frames from HCI layer */
 static int hci_uart_send_frame(struct sk_buff *skb)
 {
 	struct hci_dev* hdev = (struct hci_dev *) skb->dev;
 	struct tty_struct *tty;

--=_hawking.rebel.net.au-4809-1198179583-0001-2--
