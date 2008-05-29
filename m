Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYE2DXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYE2DXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYE2DX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:23:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYE2DX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:23:28 -0400
Message-ID: <483E2156.9020108@cn.fujitsu.com>
Date: Thu, 29 May 2008 11:21:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: [BUG ?] kmalloc() with GFP_KERNEL while holding spinlock ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the following issue in the code:

in drivers/ata/libata-acpi.c:

static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
				    u32 event)
{
	...
	spin_lock_irqsave(ap->lock, flags);
	...

	if (dev) {
		if (dev->sdev)
			kobj = &dev->sdev->sdev_gendev.kobj;
	} else
		kobj = &ap->dev->kobj;

	if (kobj) {
		sprintf(event_string, "BAY_EVENT=%d", event);
		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
	}

	spin_unlock_irqrestore(ap->lock, flags);
	...
}

and kobject_uevent_env() calls kzalloc(..., GFP_KERNEL);
