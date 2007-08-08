Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbXHHJ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbXHHJ6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbXHHJ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:58:15 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:25295 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757874AbXHHJ6O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:58:14 -0400
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: linux-kernel@vger.kernel.org
Subject: Serial buffer memory leak
Date: Wed, 8 Aug 2007 11:58:06 +0200
User-Agent: KMail/1.9.5
Cc: paulkf@microgate.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708081158.06843.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody.

Patch c5c34d4862e18ef07c1276d233507f540fb5a532 (tty: flush flip buffer on 
ldisc input queue flush) introduces a race condition which can lead to memory 
leaks.

The problem can be triggered when tcflush() is called when data are being 
pushed to the line discipline driver by flush_to_ldisc().

flush_to_ldisc() releases tty->buf.lock when calling the line discipline 
receive_buf function. At that poing tty_buffer_flush() kicks in and sets both 
tty->buf.head and tty->buf.tail to NULL. When flush_to_ldisc() finishes, it 
restores tty->buf.head but doesn't touch tty->buf.tail. This corrups the 
buffer queue, and the next call to tty_buffer_request_room() will allocate a 
new buffer and overwrite tty->buf.head. The previous buffer is then lost 
forever without being released.

I'm not familiar enough with the tty code to decide what the proper fix should 
be. I'll try to write a patch if someone could point me in the right 
direction.

Please CC me when answering, as I'm not subscribed to the list.

Regards,

-- 
Laurent Pinchart
CSE Semaphore Belgium

Chaussée de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
F +32 (2) 387 42 75
