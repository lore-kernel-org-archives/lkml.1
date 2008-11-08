Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYKHXbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYKHXbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 18:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYKHXbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 18:31:06 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4184 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYKHXbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 18:31:05 -0500
Message-ID: <49162135.50502@shikadi.net>
Date: Sun, 09 Nov 2008 09:31:01 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
CC: Jiri Slaby <jirislaby@gmail.com>
Subject: hid class and USB access
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Okay, hopefully one last question.  When writing a hid driver, what's 
the best way of accessing the USB device?  Are there custom hid 
functions you should use instead of the standard USB functions?  I don't 
want to tread on the toes of the hid class driver.

There is a usbhid_submit_report() which seems to send a control message 
to the device which works well, but my device sends interrupt messages 
in response to control messages, and I'm not sure of the best way of 
receiving these.  For example, from usbmon:

3059935847 S Co:8:002:0 s 21 09 0200 0000 0005 5 = 02010101 01
3059939037 C Co:8:002:0 0 5 >
3059943035 C Ii:8:002:1 0:8 8 = 2b181515 140f000b
3059945841 S Ii:8:002:1 -115:8 8 <
3059956862 S Co:8:002:0 s 21 09 0200 0000 0005 5 = 03010101 01
3060121048 C Co:8:002:0 0 5 >
3060127044 C Ii:8:002:1 0:8 8 = 050407dc 00000000
3060131063 S Ii:8:002:1 -115:8 8 <

I can send these control messages like this:

odin_psu->report->field[0]->value[0] = 0x02;
odin_psu->report->field[0]->value[1] = 0x01;
odin_psu->report->field[0]->value[2] = 0x01;
odin_psu->report->field[0]->value[3] = 0x01;
odin_psu->report->field[0]->value[4] = 0x01;
usbhid_submit_report(odin_psu->hdev, odin_psu->report, USB_DIR_OUT);

Resulting in usbmon output like this:

3710917380 S Co:8:002:0 s 21 09 0200 0000 0005 5 = 02010101 01
3710920638 C Co:8:002:0 -71 0

3714917416 S Co:8:002:0 s 21 09 0200 0000 0005 5 = 02010101 01
3714920639 C Co:8:002:0 -71 0

Which seems to send the correct messages (I think - I'm not sure what 
the second Co line is for), but I'm not quite sure how to receive the 
Interrupt responses from within the hid framework.  Can I use 
usbhid_submit_report(), or do I need to create an URB etc.

Many thanks,
Adam.
