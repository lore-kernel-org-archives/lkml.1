Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbYBTUdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbYBTUdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760599AbYBTUda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:33:30 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57586 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYBTUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:33:29 -0500
Date: Wed, 20 Feb 2008 12:41:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 1/4] make dev_to_node return online node
In-reply-to: <200802200032.04915.yinghai.lu@sun.com>
To: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802201241.52638.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802200015.43547.yinghai.lu@sun.com>
 <200802200032.04915.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please use this one instead. this one is less intrusive, and pcibus_to_node will work too
and don't need other changes.

YH

---

[PATCH] make dev_to_node return online node v2

some numa system ( with multi HT chains) may return node without ram. aka it
is not online.
try to get one online node, otherwise return -1

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c163ad1..2c1a651 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -213,6 +213,9 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 		set_mp_bus_to_node(busnum, node);
 	else
 		node = get_mp_bus_to_node(busnum);
+
+	if (node != -1 && !node_online(node))
+		node = -1;
 #endif
 
 	/* Allocate per-root-bus (not per bus) arch-specific data.
