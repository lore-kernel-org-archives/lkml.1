Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYE2D7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYE2D7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYE2D7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:59:36 -0400
Received: from saeurebad.de ([85.214.36.134]:39794 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbYE2D7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:59:35 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [BUG ?] kmalloc() with GFP_KERNEL while holding spinlock ?
References: <483E2156.9020108@cn.fujitsu.com>
Date: Thu, 29 May 2008 05:59:03 +0200
In-Reply-To: <483E2156.9020108@cn.fujitsu.com> (Li Zefan's message of "Thu, 29
	May 2008 11:21:58 +0800")
Message-ID: <87fxs1rcag.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Li Zefan <lizf@cn.fujitsu.com> writes:

> I noticed the following issue in the code:
>
> in drivers/ata/libata-acpi.c:
>
> static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
> 				    u32 event)
> {
> 	...
> 	spin_lock_irqsave(ap->lock, flags);
> 	...
>
> 	if (dev) {
> 		if (dev->sdev)
> 			kobj = &dev->sdev->sdev_gendev.kobj;
> 	} else
> 		kobj = &ap->dev->kobj;
>
> 	if (kobj) {
> 		sprintf(event_string, "BAY_EVENT=%d", event);
> 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
> 	}
>
> 	spin_unlock_irqrestore(ap->lock, flags);
> 	...
> }
>
> and kobject_uevent_env() calls kzalloc(..., GFP_KERNEL);

Fixed by commit ae6c23c4e1ec9720b99e1e6850fe47c6c7fddbb3 "Fixups to ATA
ACPI hotplug" by Matthew Garrett.

	Hannes
