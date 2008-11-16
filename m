Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYKPRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYKPRZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 12:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYKPRZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 12:25:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbYKPRZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 12:25:24 -0500
Date: Sun, 16 Nov 2008 09:25:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Len Brown <len.brown@intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Linux 2.6.28-rc5
In-Reply-To: <20081116140421.644e9ab2@neptune.home>
Message-ID: <alpine.LFD.2.00.0811160917220.3468@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org> <20081116140421.644e9ab2@neptune.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2008, Bruno Prémont wrote:
> 
> The following change is guilty on my machine (though I could not find
> the matching commit on git.kernel.org :( )

It's commit 0794469da3f7b2093575cbdfc1108308dd3641ce: "ACPI: struct device 
- replace bus_id with dev_name(), dev_set_name()", and yes, it seems 
totally buggy. It replaced a test for "dev->bus" with "dev_name(dev)", 
which makes no sense.

> Reverting the change below makes the error go away.

Does this smaller patch just make it go away?

That said, that whole function looks potentially buggy. Len - why is it 
safe to do "list_for_each_safe()" when you drop the acpi_device_lock in 
the middle? The "next" pointer that we look up may go away while the lock 
is dropped, I think.

		Linus

---
 drivers/acpi/sleep/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index 64e591b..4dbc227 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -366,7 +366,7 @@ acpi_system_wakeup_device_seq_show(struct seq_file *seq, void *offset)
 			   dev->wakeup.state.enabled ? "enabled" : "disabled");
 		if (ldev)
 			seq_printf(seq, "%s:%s",
-				   dev_name(ldev) ? ldev->bus->name : "no-bus",
+				   ldev->bus ? ldev->bus->name : "no-bus",
 				   dev_name(ldev));
 		seq_printf(seq, "\n");
 		put_device(ldev);
