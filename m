Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZLBO2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZLBO2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZLBO2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:28:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42763 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZLBO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IlagbqTE56jm8nTGa9cC0Nj7AHxHwzDXsgO5vR+6q5OV8oFRie6HrET3t1z3JjFFPa
         1RB9c5IEtORMeM6mw0xm7XYP5JOnXoDda5Ae8lJY3Nghsm3PZhCE+mZeh0l/2zN6ioeZ
         kHjIeH5adi8RC5Mrzc2w4yd2zRkswUn3uQrDI=
Message-ID: <4B16797C.3010304@tuffmail.co.uk>
Date: Wed, 02 Dec 2009 14:28:12 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] uswsusp: automatically free the in-memory image once s2disk
 has finished with it
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie> <200912012253.08522.rjw@sisk.pl> <4B16545B.3090703@tuffmail.co.uk> <20091202122019.GD1457@csn.ul.ie>
In-Reply-To: <20091202122019.GD1457@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original in-kernel suspend (swsusp) frees the in-memory hibernation
image before powering off the machine.  s2disk doesn't, so there is
_much_ less free memory when it tries to power off.

This is a gratuitous difference.  The userspace suspend interface
/dev/snapshot only allows the hibernation image to be read once.
Once the s2disk program has read the last page, we can free the entire
image.

This avoids a hang after writing the hibernation image which was
triggered by commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61
"page-allocator: split per-cpu list into one-list-per-migrate-type":

    [top of trace lost due to screen height]
    ? shrink_zone
    ? try_to_free_pages
    ? isolate_pages_global
    ? __alloc_pages_nodemask
    ? kthread
    ? __get_free_pages
    ? copy_process
    ? kthread
    ? do_fork
    ...

    INFO: task s2disk:2036 blocked for more than 120 seconds
    ...
    Call Trace:
    ...
    ? wait_for_common
    ? default_wake_function
    ? kthread_create
    ? worker_thread
    ? create_workqueue_thread
    ? worker_thread
    ? __create_workqueue_key
    ? stop_machine_create
    ? disable_nonboot_cpus
    ? hibernation_platform_enter
    ? snapshot_ioctl
    ...
    ? sys_ioctl
    ...

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 kernel/power/user.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index bf0014d..94d0210 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -165,6 +165,10 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 			res = -EFAULT;
 		else
 			*offp = data->handle.offset;
+	} else {
+		swsusp_free();
+		memset(&data->handle, 0, sizeof(struct snapshot_handle));
+		data->ready = 0;
 	}
 
  Unlock:
-- 
1.6.3.3



