Return-Path: <linux-kernel-owner+w=401wt.eu-S1765322AbYHDUes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765322AbYHDUes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765239AbYHDUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:34:34 -0400
Received: from submit-tmp.sysedata.no ([195.159.29.133]:48175 "EHLO
	submit-tmp.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765223AbYHDUec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:34:32 -0400
Message-ID: <489767D3.6070408@db.org>
Date: Mon, 04 Aug 2008 22:34:27 +0200
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
 #2
References: <200806271424.50425.oliver@neukum.org> <200807262045.22722.oliver@neukum.org> <48962B8A.8030307@db.org> <200808041356.57928.oliver@neukum.org>
In-Reply-To: <200808041356.57928.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Montag 04 August 2008 00:04:58 schrieb Alfred E. Heggestad:
>> Oliver Neukum wrote:
>>> Am Samstag 26 Juli 2008 17:55:35 schrieb Alfred E. Heggestad:
>>>> Jul 26 17:32:33 io kernel: hald-addon-keyb[23629]: segfault at 6f6f6c5f ip b7e9855b sp bf9d89dc error 4 in libc-2.6.1.so[b7e28000+144000]
>>>> Jul 26 17:32:43 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
>>>> Jul 26 17:33:21 io last message repeated 6 times
>>>> Jul 26 17:34:28 io last message repeated 17 times
>>> This should not happen. Please provide more context. If possible
>>> recompile your kernel with CONFIG_USB_DEBUG.
>>>
>> Hi Oliver
>>
>> sorry for the delay, I was out travelling with no access to CM109 hardware..
>>
>> I recompiled the latest kernel from input-branch with CONFIG_USB_DEBUG enabled,
>> the version reported is 2.6.27-rc1. Below you can see the syslog and the
>> context of events:
> 
> Looks like urb_irq is not properly initialised. Is there really nothing in the syslog?
> Please print out urb->interval
> 

urb->interval == 32

I added some more debugging in the driver, and after the module is loaded,
I press "TAB" in a shell to force Bell/Buzzer.


the syslog reports:


;;;
;;; Insert device:
;;;

Aug  4 22:20:43 io kernel: cm109: Keymap for Komunikate KIP1000 phone loaded
Aug  4 22:20:43 io kernel: cm109 1-2:1.3: usb_probe_interface
Aug  4 22:20:43 io kernel: cm109 1-2:1.3: usb_probe_interface - got id
Aug  4 22:20:43 io kernel: cm109: urb_irq init: interval=32
Aug  4 22:20:43 io kernel: input: CM109 USB driver as /class/input/input13
Aug  4 22:20:43 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=0
Aug  4 22:20:43 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  4 22:20:43 io kernel: usbcore: registered new interface driver cm109
Aug  4 22:20:43 io kernel: cm109: CM109 phone driver: 20080726 (C) Alfred E. Heggestad

;;;
;;; Bell/Alarm -> buzzer
;;;

Aug  4 22:20:50 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=0 buzzer_pending=0
Aug  4 22:20:50 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=1
Aug  4 22:20:50 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  4 22:20:50 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22     <----- error -EINVAL
Aug  4 22:20:50 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=0 buzzer_pending=0
Aug  4 22:20:50 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=0
Aug  4 22:20:50 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=1 buzzer_pending=0
Aug  4 22:20:50 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=1, ctl_urb_pending=1
Aug  4 22:20:50 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=0
Aug  4 22:20:50 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
Aug  4 22:20:50 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22     <---- error -EINVAL

;;;
;;; unplug device:
;;;

Aug  4 22:20:58 io kernel: usbcore: deregistering interface driver cm109
Aug  4 22:20:58 io kernel: uhci_hcd 0000:00:1f.2: shutdown urb cec1a760 ep3in-intr
Aug  4 22:20:58 io kernel: cm109: urb_irq_cb: urb_irq->interval=32
Aug  4 22:20:58 io kernel: uhci_hcd 0000:00:1f.2: release dev 2 ep83-INT, period 32, phase 16, 14 us
Aug  4 22:20:58 io kernel: cm109: cm109_toggle_buzzer_sync: usb_control_msg() failed 4




/alfred
