Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbYHETYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbYHETYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYHETYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:24:00 -0400
Received: from submit-tmp.sysedata.no ([195.159.29.133]:60788 "EHLO
	submit-tmp.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbYHETX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:23:59 -0400
Message-ID: <4898A8C2.2080307@db.org>
Date: Tue, 05 Aug 2008 21:23:46 +0200
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
 #2
References: <200806271424.50425.oliver@neukum.org> <200808041356.57928.oliver@neukum.org> <489767D3.6070408@db.org> <200808050008.48846.oliver@neukum.org>
In-Reply-To: <200808050008.48846.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Montag 04 August 2008 22:34:27 schrieb Alfred E. Heggestad:
>>> Looks like urb_irq is not properly initialised. Is there really nothing in the syslog?
>>> Please print out urb->interval
>>>
>> urb->interval == 32
>>
>> I added some more debugging in the driver, and after the module is loaded,
>> I press "TAB" in a shell to force Bell/Buzzer.
> 
> Can you printk the interval and the dev pointer in 
> cm109_urb_irq_callback?
> 

sure. it looks like the interval remains unchanged at 32.

from the log below you can see two scenarios; first the key '1' is pressed on the
CM109 device. then TAB is pressed in shell to get the Buzzer.

in the first case the two URBs urb_irq and urb_ctl are called every other
time, to scan the whole key matrix. calling usb_submit_urb() does not give
-EINVAL error here.

in the second case the URB is triggered by input-subsystem and cm109_input_ev()
and finally calls usb_submit_urb() on urb_ctl, but in the callback handler
of urb_ctl, the usb_submit_urb() on urb_irq fails with -EINVAL.


log:

;;;
;;; CM109 device inserted
;;;
Aug  5 21:11:08 io kernel: cm109: Keymap for Komunikate KIP1000 phone loaded
Aug  5 21:11:08 io kernel: cm109 1-2:1.3: usb_probe_interface
Aug  5 21:11:08 io kernel: cm109 1-2:1.3: usb_probe_interface - got id
Aug  5 21:11:08 io kernel: cm109: urb_irq init: interval=32
Aug  5 21:11:08 io kernel: input: CM109 USB driver as /class/input/input9
Aug  5 21:11:08 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=0
Aug  5 21:11:08 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:08 io kernel: usbcore: registered new interface driver cm109
Aug  5 21:11:08 io kernel: cm109: CM109 phone driver: 20080726 (C) Alfred E. Heggestad

;;;
;;; Press key '1' on CM109 device
;;;

Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us

;;;
;;; Press 'TAB' in shell to force Bell/Buzzer
;;;

Aug  5 21:11:22 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=0 buzzer_pending=0
Aug  5 21:11:22 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=1
Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22     <--- note -EINVAL
Aug  5 21:11:22 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=0 buzzer_pending=0
Aug  5 21:11:22 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=0
Aug  5 21:11:22 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=1 buzzer_pending=0
Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=1, ctl_urb_pending=1
Aug  5 21:11:22 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=0
Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22     <--- note -EINVAL

;;;
;;; modprobe -r cm109
;;;

Aug  5 21:11:28 io kernel: usbcore: deregistering interface driver cm109
Aug  5 21:11:28 io kernel: uhci_hcd 0000:00:1f.2: shutdown urb cef647e0 ep3in-intr
Aug  5 21:11:28 io kernel: cm109: cm109_urb_irq_callback: dev=cd7a4400 urb_irq->interval=32
Aug  5 21:11:28 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
