Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZESFDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZESFDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZESFD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 01:03:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35833 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZESFD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 01:03:29 -0400
Date: Tue, 19 May 2009 06:03:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
	suspend
Message-ID: <20090519050327.GA22637@srcf.ucam.org>
References: <4A11C126.1000704@dell.com> <20090518210241.GA17755@srcf.ucam.org> <4A11D4E8.1020807@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A11D4E8.1020807@dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 04:36:40PM -0500, Mario Limonciello wrote:

> Dell BT adapters will startup in a HID mode.  In HID mode two logical
> USB devices are exposed, a mouse and a keyboard.  If properly set, the
> BT radio will work with pre-paired keyboards or mice in this mode.  This
> is useful for things like BIOS control via a BT keyboard.  A command is
> sent to one of the descriptors of the mouse to cause the device to
> transition to HCI mode.  When transitioned to HCI mode, a radio device
> is exposed allowing it to pair and operate with any BT device.
> 
> Here's what the utility looks like that ships with bluez:
> http://git.kernel.org/?p=bluetooth/bluez.git;a=blob;f=tools/hid2hci.c;h=11d707fd76e940b884c9078907ab1504cd7350d4;hb=HEAD
> Look at the switch_dell method to see how it works.
> 
> Currently, this is implemented via a set of udev rules shipped with
> bluez that match the Dell device and transition it to HCI mode.
> Here's the udev rule that matches:
> ACTION=="add", ENV{ID_VENDOR}=="413c", ENV{ID_CLASS}=="mouse", ATTRS{bmAttributes}=="e0", KERNEL=="mouse*", RUN+="/usr/sbin/hid2hci --method dell -v $env{ID_VENDOR} -p $env{ID_MODEL} --mode hci"
> 
> When coming out of S3 if the killswitch isn't activated, the logical USB
> mouse isn't coldplugged again preventing the udev rule from being
> matched upon.  You can manually run hid2hci and the device will switch
> modes.

Ok. I don't think the right way to implement this is forcing dell-laptop 
to simulate an unplug. The HCI driver should be responsible for saving 
and restoring state of the device in its suspend/resume method.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
