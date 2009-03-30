Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZC3S3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZC3S3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZC3SYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:24:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:2412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbZC3SYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iBeFB3cPQNdmhytZYZPL1z7UMJdNqNsjsBsO7s7flkHJZbpbw9yN1sfSvTtE9/nQfI
         nK5Fm25ECPy5MZBZBfCy9GnblcPJi71wYoU1gWa1eTD/6qEI+gD/kPgEzY9wFjNC6dmJ
         eIbJeLkQD+iLQhizWzj3LYWxf2T5r/E0nPHnw=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510903291106k27902bafpa8231d6781f8f5c@mail.gmail.com>
References: <49CF9BA1.5030400@archlinux.org>
	 <20090329091148.16a618bf@infradead.org>
	 <49CFA436.5080000@archlinux.org>
	 <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com>
	 <49CFB553.1020800@archlinux.org>
	 <ac3eb2510903291106k27902bafpa8231d6781f8f5c@mail.gmail.com>
Date: Mon, 30 Mar 2009 11:23:57 -0700
X-Google-Sender-Auth: 89aeae1f1a858741
Message-ID: <e9c3a7c20903301123l3f05264cvb8522dd4cb030b2f@mail.gmail.com>
Subject: Re: fastboot/async and initramfs: How am I supposed to know when 
	devices are finished initializing?
From: Dan Williams <dan.j.williams@intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 11:06 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> Assembling meta devices, or multi-volume devices should be triggered
> directly when the underlying devices show up. If auto-assembly (which
> kind of works today with md's --incremental) is properly implemented,
> you should still be able to just wait for the specified root device to
> show up...

Incremental assembly mostly works but it would be nice to have some
event to signal "proceed with degraded assembly because I do not think
any more disks are coming".  With the below patch my thought is that
we can have a rule that:
1/ checks if incremental assembly is in progress (to prevent adding
timeouts to the non-raid path)
2/ checks if the udev event queue is empty
3/ upon finding an idle queue pause to allow last chance discovery
4/ assuming the queue remains idle proceed with degraded assembly

Thoughts?  Perhaps (3) can be eliminated after loading scsi_wait_scan.

Thanks,
Dan

---ws damaged patch---
settle: allow --timeout=0 to test for "queue busy"

From: Dan Williams <dan.j.williams@intel.com>

Allow udevadm settle to be used as a "queue busy" detector.  For use in
a early raid discovery where we want to hold off committing to the
current list of disks while devices might still be arriving.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 udev/udevadm-settle.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/udev/udevadm-settle.c b/udev/udevadm-settle.c
index 867bbed..2fa85a4 100644
--- a/udev/udevadm-settle.c
+++ b/udev/udevadm-settle.c
@@ -85,6 +85,9 @@ int udevadm_settle(struct udev *udev, int argc, char *argv[])
 		usleep(1000 * 1000 / LOOP_PER_SECOND);
 	}

+	if (!udev_queue_get_queue_is_empty(udev_queue))
+		rc = 1;
+
 	/* if we reached the timeout, print the list of remaining events */
 	if (loop <= 0) {
 		struct udev_list_entry *list_entry;
@@ -97,7 +100,6 @@ int udevadm_settle(struct udev *udev, int argc, char *argv[])
 				       udev_list_entry_get_name(list_entry),
 				       udev_list_entry_get_value(list_entry));
 		}
-		rc = 1;
 	}
 exit:
 	udev_queue_unref(udev_queue);
