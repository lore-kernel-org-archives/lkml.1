Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbYLTLMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbYLTLMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYLTLMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:12:38 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:17366 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYLTLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=N/ygD8rVpNigec2xL0LoqkWbqNkQYbFfG41H6yUREU6LkE3APgMR2eP0b580Zdg1zb
         59Owfj/Jqlx52cR0TgLMX9GP43vqL7IfmKzvYNLYaN0mPjThVIfVflrGN5mYwGVwxJGx
         FIZdK3J05snkO2ZuoTw2cBY2n7jTa+TOiBvoA=
Date: Sat, 20 Dec 2008 12:14:19 +0100
To: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: fix no_pci_devices() #2
Message-ID: <20081220111419.GA5367@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220105658.GA1760@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 11:56 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sat, Dec 20, 2008 at 9:58 AM, Greg KH <gregkh@suse.de> wrote:
>> Care to make a patch for no_pci_devices() to work properly in this kind
>> of situation?
>
> How does this look?
>
> I have introduced a variable pci_is_initiated, which is set after the bus
> has been registered.

This patch is simpler and also works for me. But I am not too fond of it
either...


Vegard


>From 1f047c86fc7a831d85174452da92344a3582a158 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 20 Dec 2008 12:08:18 +0100
Subject: [PATCH] pci: fix no_pci_devices() #2

In short, no_pci_devices() should not use bus_find_device() before
initcalls have run, because the pci bus structure has not been
initialized yet.

Reference: http://lkml.org/lkml/2008/12/20/21

Cc: Greg KH <gregkh@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/base/bus.c  |    1 +
 drivers/pci/probe.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 5aee1c0..5e83faf 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -931,6 +931,7 @@ bus_devices_fail:
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
 	kfree(bus->p);
+	bus->p = NULL;
 out:
 	return retval;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 003a9b3..d561be7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -35,6 +35,9 @@ int no_pci_devices(void)
 	struct device *dev;
 	int no_devices;
 
+	if (!pci_bus_type.p)
+		return 1;
+
 	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
 	no_devices = (dev == NULL);
 	put_device(dev);
-- 
1.5.6.5

