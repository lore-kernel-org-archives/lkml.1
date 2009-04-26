Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZDZULj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZDZULj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZDZULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:11:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10346 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZDZUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:11:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ekqq80l8QqGpp/bc57+p0PnHsstFbvq6yGt3MvwVmNk/Ej9JaS+GQKfddLbVLIeF5
	V+TxjBS6Re76LizuBO36g==
Date: Sun, 26 Apr 2009 13:11:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: jan sonnek <ha2nny@gmail.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: oops on 2.6.30-rc3-mm1
In-Reply-To: <49F4E29F.8030409@gmail.com>
Message-ID: <alpine.DEB.2.00.0904261301310.18988@chino.kir.corp.google.com>
References: <49F4E29F.8030409@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, jan sonnek wrote:

> BUG: unable to handle kernel NULL pointer dereference at 00000040
> IP: [<c015409c>] balance_dirty_pages_ratelimited_nr+0x10/0x29b
> *pde = 36b28067 *pte = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/virtual/dmi/id/chassis_asset_tag
> Modules linked in: sco bnep l2cap bluetooth coretemp hwmon ipv6 fuse iwl3945
> iwlcore sdhci_pci sr_mod sg sdhci ohci1394 ieee1394 cdrom mmc_core battery
> mac80211 led_class ricoh_mmc cfg80211 usb_storage [last unloaded:
> scsi_wait_scan]
> 
> Pid: 2867, comm: X Not tainted (2.6.30-rc3-mm1-hanny #27) F3F

Where has 2.6.30-rc3-mm1 been released?

> EIP: 0060:[<c015409c>] EFLAGS: 00213296 CPU: 0
> EIP is at balance_dirty_pages_ratelimited_nr+0x10/0x29b
> EAX: 00000000 EBX: 00000008 ECX: 00000000 EDX: 00000001
> ESI: 00000000 EDI: 5f372067 EBP: f69a1eec ESP: f69a1e84
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process X (pid: 2867, ti=f69a1000 task=f7164380 task.ti=f69a1000)
> Stack:
>  f69a1e8c c03691fe f69a1eac 00203292 000000d0 00203292 f7001324 f6ad4474
>  000f877d 000f877e f69a1ebc c023ea66 f6b003e0 f6b003e0 f69a1ec4 c03691fe
>  f69a1ed8 c017e704 c1be6e40 f6ad43a8 f6823600 00000000 c049f9c0 c1be6e40
> Call Trace:
>  [<c03691fe>] ? _spin_unlock+0x19/0x24
>  [<c023ea66>] ? drm_vm_open_locked+0x5b/0x94
>  [<c03691fe>] ? _spin_unlock+0x19/0x24
>  [<c017e704>] ? mnt_drop_write+0x6d/0xe6
>  [<c015d26c>] ? __do_fault+0x283/0x2bd
>  [<c015e784>] ? handle_mm_fault+0x1f7/0x454
>  [<c0115472>] ? do_page_fault+0x1e0/0x1ef
>  [<c0115292>] ? do_page_fault+0x0/0x1ef
>  [<c03694dd>] ? error_code+0x6d/0x74
>  [<c0115292>] ? do_page_fault+0x0/0x1ef

This looks like the result of mm-close-page_mkwrite-races-try-3.patch.

Nick, we lost the check for a non-NULL mapping when calling 
balance_dirty_pages_ratelimited(mapping) in set_page_dirty_balance() when 
it was replaced in __do_fault().

Since we're operating on page->mapping and not dirty_page->mapping here, 
perhaps this is necessary (against mmotm, not 2.6.30-rc3-mm1)?
---
diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2905,7 +2905,7 @@ out:
 			page_mkwrite = 1;
 		unlock_page(dirty_page);
 		put_page(dirty_page);
-		if (page_mkwrite)
+		if (page_mkwrite && mapping)
 			balance_dirty_pages_ratelimited(mapping);
 	} else {
 		unlock_page(vmf.page);
