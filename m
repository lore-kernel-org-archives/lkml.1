Return-Path: <linux-kernel-owner+w=401wt.eu-S934585AbZGQNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbZGQNIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934568AbZGQNIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:08:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:34500 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934562AbZGQNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fhS6jBmTcFU2ZZeA+JE55bG6wr5gz/dTDxCZfXkY1uqNl6VJChXsxRFE7fYuravNwg
         H6JF7yRZQKq31Lmt2fFvDE6v2huPMlLHz9TXqu2iPmFBMQ5/8Uyph5a0wuKo5Te/gZqQ
         eoh1TRL2E4ASwndSM7y716xbZP7SJVA+TpWyY=
Message-ID: <4A6077DE.6060202@tuffmail.co.uk>
Date: Fri, 17 Jul 2009 14:08:46 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: PM/hibernate swapfile regression
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <200907141821.06101.rjw@sisk.pl>
In-Reply-To: <200907141821.06101.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 14 July 2009, Heiko Carstens wrote:
>   
>> We've seen this bug:
>>
>> Jul  8 13:16:02 h05lp03 kernel: BUG: sleeping function called from invalid context at /home/autobuild/BUILD/linux-2.6.30-20090707/include/linux/writeback.h:87
>> Jul  8 13:16:02 h05lp03 kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 24377, name: bash
>> Jul  8 13:16:02 h05lp03 kernel: 3 locks held by bash/24377:
>> Jul  8 13:16:02 h05lp03 kernel: #0:  (&buffer->mutex){+.+.+.}, at: [<0000000000276e74>] sysfs_write_file+0x4c/0x1ac
>> Jul  8 13:16:02 h05lp03 kernel: #1:  (pm_mutex#2){+.+.+.}, at: [<000000000018f128>] hibernate+0x34/0x200
>> Jul  8 13:16:02 h05lp03 kernel: #2:  (swap_lock){+.+.-.}, at: [<00000000001f371c>] swap_type_of+0x44/0x158
>> Jul  8 13:16:02 h05lp03 kernel: CPU: 8 Not tainted 2.6.30-39.x.20090707-s390xdefault #1
>> Jul  8 13:16:02 h05lp03 kernel: Process bash (pid: 24377, task: 000000012ce84240, ksp: 00000000c262bb00)
>> Jul  8 13:16:02 h05lp03 kernel: 0000000000000000 00000000c262ba88 0000000000000002 0000000000000000
>> Jul  8 13:16:02 h05lp03 kernel:       00000000c262bb28 00000000c262baa0 00000000c262baa0 00000000005448c4
>> Jul  8 13:16:02 h05lp03 kernel:       0000000000000000 000000012ce84718 000000013d5bf1a8 0000000000000000
>> Jul  8 13:16:02 h05lp03 kernel:       000000000000000d 0000000000000000 00000000c262baf8 000000000000000e
>> Jul  8 13:16:02 h05lp03 kernel:       0000000000553da8 0000000000105600 00000000c262ba88 00000000c262bad0
>> Jul  8 13:16:02 h05lp03 kernel: Call Trace:
>> Jul  8 13:16:02 h05lp03 kernel: ([<00000000001054fc>] show_trace+0xf0/0x148)
>> Jul  8 13:16:02 h05lp03 kernel: [<00000000001391ba>] __might_sleep+0x172/0x188
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000021f738>] ifind+0x88/0xe4
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000220b0e>] iget5_locked+0x66/0x1d8
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000023b676>] bdget+0x5e/0x150
>> Jul  8 13:16:02 h05lp03 kernel: [<00000000001f37b2>] swap_type_of+0xda/0x158
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000192342>] swsusp_write+0x4e/0x458
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000018f254>] hibernate+0x160/0x200
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000018d8da>] state_store+0x82/0xa8
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000276f20>] sysfs_write_file+0xf8/0x1ac
>> Jul  8 13:16:02 h05lp03 kernel: [<000000000020663a>] vfs_write+0xae/0x15c
>> Jul  8 13:16:02 h05lp03 kernel: [<00000000002067e0>] SyS_write+0x54/0xac
>> Jul  8 13:16:02 h05lp03 kernel: [<0000000000117a96>] sysc_noemu+0x10/0x16
>> Jul  8 13:16:02 h05lp03 kernel: [<00000047083e36b4>] 0x47083e36b4
>>
>> Looks like this was introduced with git commit a1bb7d61 "PM/hibernate: fix "swap
>> breaks after hibernation failures"".
>> Calling bdget while holding a spinlock doesn't seem to be a good idea...
>>     
>
> Agreed, sorry for missing that.
>
> Alan, can you please prepare a fix?
>
> Rafael
>   

I'm not sure how to reproduce.  I tried pm-hibernate with
CONFIG_DEBUG_SPINLOCK_SLEEP, but nothing showed up in dmesg.

Here's a quick & dirty patch. Please test (or explain how I can test it
myself, whichever is easier :-). swap_unplug_sem is used to avoid
holding swap_lock when calling the block device unplug function.  I
think it can also be used for this bdget call.

Thanks
Alan

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d1ade1a..9176464 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -744,6 +744,7 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 	if (device)
 		bdev = bdget(device);
 
+	down_read(&swap_unplug_sem);
 	spin_lock(&swap_lock);
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *sis = swap_info + i;
@@ -752,10 +753,11 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 			continue;
 
 		if (!bdev) {
+			spin_unlock(&swap_lock);
 			if (bdev_p)
 				*bdev_p = bdget(sis->bdev->bd_dev);
+			up_read(&swap_unplug_sem);
 
-			spin_unlock(&swap_lock);
 			return i;
 		}
 		if (bdev == sis->bdev) {
@@ -764,16 +766,18 @@ int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 			se = list_entry(sis->extent_list.next,
 					struct swap_extent, list);
 			if (se->start_block == offset) {
+				spin_unlock(&swap_lock);
 				if (bdev_p)
 					*bdev_p = bdget(sis->bdev->bd_dev);
+				up_read(&swap_unplug_sem);
 
-				spin_unlock(&swap_lock);
 				bdput(bdev);
 				return i;
 			}
 		}
 	}
 	spin_unlock(&swap_lock);
+	up_read(&swap_unplug_sem);
 	if (bdev)
 		bdput(bdev);
 


