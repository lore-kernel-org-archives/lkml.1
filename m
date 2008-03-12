Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbYCLRgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbYCLRgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYCLRex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:34:53 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:64346 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbYCLRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:34:51 -0400
Message-ID: <47D8142E.6060305@pobox.com>
Date: Wed, 12 Mar 2008 13:34:38 -0400
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, mlord@pobox.com, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] pciehp hang on hp ia64 rx6600
References: <20080312064755.GA31493@ldl.fc.hp.com>
In-Reply-To: <20080312064755.GA31493@ldl.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hi Mark, Kristin,
> 
> On my hp ia64 rx6600, 'modprobe pciehp' causes lockups and a
> system hang on 2.6.25-rc4. My system often hangs when only pciehp
> is loaded and my console is sitting idle, but I can accelerate
> the hang 100% of the time by immediately doing a 'modprobe
> acpiphp' right afterwards.
..

Does this patch fix things for you?

* * *

Invoke pciehp_enable_slot() at startup only when pciehp_force=1.
Some HP equipment apparently cannot cope with it otherwise.

This restores the (previously working) 2.6.24 behaviour here,
while allowing machines that need a kick to use pciehp_force=1.

Signed-off-by: Mark Lord <mlord@pobox.com>
---

--- linux-2.6.25-rc5-git2/drivers/pci/hotplug/pciehp_core.c	2008-03-12 13:21:46.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2008-03-12 13:23:54.000000000 -0400
@@ -467,7 +467,7 @@
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
-	if (value) {
+	if (value && pciehp_force) {
 		rc = pciehp_enable_slot(t_slot);
 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
 			value = 0;
