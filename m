Return-Path: <linux-kernel-owner+w=401wt.eu-S966935AbXLTPsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966935AbXLTPsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935155AbXLTP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:28:28 -0500
Received: from mga06.intel.com ([134.134.136.21]:48998 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935137AbXLTP2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:28:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,190,1196668800"; 
   d="scan'208";a="243917287"
Message-ID: <476A895C.7040903@linux.intel.com>
Date: Thu, 20 Dec 2007 16:25:16 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcel Holtmann <marcel@holtmann.org>
CC: linux-kernel@vger.kernel.org
Subject: Kernel bug: bluetooth meets TTY layer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with the help of kerneloops.org I've spotted a nice little interaction
between the TTY layer and the bluetooth code, however the tty layer is
not something I'm all too familiar with so I rather ask than brute-force
fix the code incorrectly.

The raw details are at:
http://www.kerneloops.org/search.php?search=uart_flush_buffer

What happens is that, on closing the bluetooth tty,
the tty layer goes into the release_dev() function,
which first does a bunch of stuff, then sets the file->private_data to NULL,
does some more stuff  and then calls the ldisc close function. Which in this
case, is hci_uart_tty_close().

Now, hci_uart_tty_close() calls hci_uart_close() which clears some internal bit,
and then calls hci_uart_flush()... which calls back to the tty layers' uart_flush_buffer() function.
(in drivers/bluetooth/hci_tty.c around line 194)
Which then WARN_ON()'s because that's not allowed/supposed to be called
this late in the shutdown of the port....

should the bluetooth driver even call this flush function at all??

Greetings,
    Arjan van de Ven


