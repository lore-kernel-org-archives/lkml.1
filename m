Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbXBLAov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbXBLAov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXBLAov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:44:51 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:27850 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXBLAou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:44:50 -0500
Date: Sun, 11 Feb 2007 18:44:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: pcim_enable_device BUGs for libata devices in 2.6.20-git6
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>
Message-id: <45CFB87F.9060802@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing BUGs like these on all libata-driven controllers when 
suspending to disk on 2.6.20-git6:

sata_nv 0000:00:07.0: resuming
BUG: at drivers/pci/pci.c:817 pcim_enable_device()

Call Trace:
  [<ffffffff80337d21>] pcim_enable_device+0x8a/0xa5
  [<ffffffff88099d18>] :libata:ata_pci_device_do_resume+0x20/0x59
  [<ffffffff880bb731>] :sata_nv:nv_pci_device_resume+0x1d/0x100
  [<ffffffff8039d2bf>] resume_device+0xcb/0x12c
  [<ffffffff8039d3ac>] dpm_resume+0x8c/0xec
  [<ffffffff8039d456>] device_resume+0x4a/0x5d
  [<ffffffff802a0a33>] pm_suspend_disk+0x160/0x170
  [<ffffffff8029f4b6>] enter_state+0x52/0x1da
  [<ffffffff8029f69c>] state_store+0x5e/0x79
  [<ffffffff802f2b20>] sysfs_write_file+0xe4/0x118
  [<ffffffff80214b58>] vfs_write+0xce/0x177
  [<ffffffff8021553e>] sys_write+0x45/0x6e
  [<ffffffff8025711e>] system_call+0x7e/0x83

It looks like what's happening is that during the "freezing" stage, we 
suspend and then resume the controllers. ata_pci_device_do_suspend only 
calls pci_disable_device if the event is PM_EVENT_SUSPEND but 
ata_pci_device_do_resume calls pcim_enable_device unconditionally. If 
the event was something else, then pcim_enable_device complains because 
the device was previously enabled and never disabled.

Not sure what the best way to fix this is?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

