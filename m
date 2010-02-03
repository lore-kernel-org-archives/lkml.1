Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0BCTsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:48:16 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:54099 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab0BCTsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:48:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=date:from:to:cc
	:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=kMMxzA
	x6w3X15+Yk8TPPHBKmXti1JbN8k+HNsM+xiNmyAPSxkzZcCP3aBLVfCStPQ+EdJy
	u99SQfMMKZsKXPjNRDMu8TXP6XFPPWJ/URU5dLNoiMmdNOIIinhURzOavlm1K2uF
	XbAaEAAS2fwxfXZEBF0dOEcHF/KNuharPhMDo=
Date: Wed, 3 Feb 2010 13:47:55 -0600
From: Corey Wright <undefined@pobox.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
Message-Id: <20100203134755.a56e2314.undefined@pobox.com>
In-Reply-To: <Pine.LNX.4.44L0.1002031306220.1260-100000@iolanthe.rowland.org>
References: <20100203115956.cb479447.undefined@pobox.com>
 <Pine.LNX.4.44L0.1002031306220.1260-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Pobox-Relay-ID: 0966EC0A-10FD-11DF-8E92-6AF7ED7EF46B-06295150!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 13:09:45 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 3 Feb 2010, Corey Wright wrote:
> 
> > > Please build a kernel with CONFIG_USB_DEBUG enabled and post a dmesg 
> > > log showing the problem during the second hibernation attempt.
> > 
> > [  675.443474] PM: Syncing filesystems ... done.
> > [  675.576353] Freezing user space processes ... (elapsed 0.00 seconds)
> > done.
> > [  675.606968] Freezing remaining freezable tasks ... (elapsed 0.00
> > seconds) done.
> > [  675.629249] PM: Shrinking memory...  -\|done (3129 pages freed)
> > [  679.547522] PM: Freed 12516 kbytes in 3.90 seconds (3.20 MB/s)
> > [  679.565065] Suspending console(s) (use no_console_suspend to debug)
> > [  679.585425] uhci_hcd 0000:00:10.0: release dev 2 ep81-INT, period 8,
> > phase 4, 118 us
> > [  679.585453] hub 2-0:1.0: hub_suspend
> > [  679.585460] usb usb2: bus suspend
> > [  679.585463] usb usb2: suspend_rh
> > [  679.585534] hub 1-0:1.0: hub_suspend
> > [  679.585538] usb usb1: bus suspend
> > [  679.585542] ehci_hcd 0000:00:10.4: suspend root hub
> > [  679.585547] ehci_hcd 0000:00:10.4: suspend failed because port 8 is
> > resuming
> 
> There you have it.  What is the USB device attached to port 8 on bus 1 
> (i.e., /sys/bus/usb/devices/1-8)?

the device is a usb SD reader w/ SD card in it.

# cat /sys/bus/usb/devices/1-8/product
USB 2.0  SD MMC READER 

i removed the media reader after the failed suspend (it is only used at
boot-up to hold the LUKS key material to decrypt the filesystem) but the
message is the same:

[ 4002.585329] ehci_hcd 0000:00:10.4: suspend root hub
[ 4002.585334] ehci_hcd 0000:00:10.4: suspend failed because port 8 is
resuming
[ 4002.585338] usb usb1: bus suspend fail, err -16

and /sys/bus/usb/devices/1-8 no longer exists (little
alone /sys/bus/usb/devices/1-8/power/wakeup):

# ls -1 /sys/bus/usb/devices/
1-0:1.0
1-7
1-7:1.0
2-0:1.0
2-1
2-1:1.0
3-0:1.0
4-0:1.0
5-0:1.0
usb1
usb2
usb3
usb4
usb5

> And what happens if you do:
> 
> 	echo disabled >/sys/bus/usb/devices/1-8/power/wakeup
> 
> before trying to hibernate?

it's the same immediately after a reboot (and before suspending), a
successful suspend, or a failed suspend:

# echo disabled >/sys/bus/usb/devices/1-8/power/wakeup 
bash: echo: write error: Invalid argument

and as previously said, that sysfs entry does not exist if the media reader
is removed, though the error appears to continue to refer to that
port/device.

corey
-- 
undefined@pobox.com
