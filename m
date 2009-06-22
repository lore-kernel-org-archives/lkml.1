Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZFVMPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZFVMPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZFVMPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:15:39 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:26682
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750731AbZFVMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:15:38 -0400
Message-ID: <4A3F75EB.7090107@panasas.com>
Date: Mon, 22 Jun 2009 15:15:39 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd mailing-list <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH] open-osd: osdblk User Mode utility
References: <4A391373.3050301@panasas.com> <4A3A370D.10704@panasas.com> <4A3A393F.4010101@panasas.com>
In-Reply-To: <4A3A393F.4010101@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 12:15:41.0659 (UTC) FILETIME=[292EE2B0:01C9F333]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2009 03:55 PM, Boaz Harrosh wrote:
> A minimal user-mode application to Create / Remove / Resize
> OSD objects from a device, for use with the osdblk.ko block
> device driver.
> 
> See inside patch for Usage instructions.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---

This version had a bug which, if the partition did not exist
it would fail to create the object.

I have squashed the below patch into this one, on the open-osd
git tree

---
Subject: [PATCH] {SQUASHME} open-osd: usr/osdblk: Need to also create the partition

A fall out of the usr/osdblk application

Boaz
---
 usr/osdblk.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/usr/osdblk.c b/usr/osdblk.c
index f7df257..b9982c0 100644
--- a/usr/osdblk.c
+++ b/usr/osdblk.c
@@ -74,7 +74,7 @@ static void usage(void)
 	"       pid_no is the partition 64bit number of the object in question\n"
 	"       Both 0xabc hex or decimal anotation can be used\n"
 	"\n"
-	"--obj=obj_no | -o obj_no\n"
+	"--oid=obj_no | -o obj_no\n"
 	"       obj_no is the object 64bit number of the object in question\n"
 	"       Both 0xabc hex or decimal anotation can be used\n"
 	"\n"
@@ -198,6 +198,19 @@ static int do_create(struct osd_dev *od, struct osd_obj_id *obj, u64 size)
 		return -ENOMEM;
 
 	osdblk_make_credential(creds, obj, osd_req_is_ver1(or));
+
+	/* Create partition OK to fail (all ready exist) */
+	osd_req_create_partition(or, obj->partition);
+	ret = osdblk_exec(or, creds);
+	osd_end_request(or);
+
+	if (ret)
+		OSDBLK_INFO("pid=0x%llx exists\n", _LLU(obj->partition));
+
+	or = osd_start_request(od, GFP_KERNEL);
+	if (unlikely(!or))
+		return -ENOMEM;
+
 	osd_req_create_object(or, obj);
 	ret = osdblk_exec(or, creds);
 	osd_end_request(or);
@@ -280,7 +293,7 @@ int main(int argc, char *argv[])
 		{.name = "resize", .has_arg = 0, .flag = NULL, .val = 's'} ,
 		{.name = "pid", .has_arg = 1, .flag = NULL, .val =  'p'} ,
 		{.name = "oid", .has_arg = 1, .flag = NULL, .val =  'o'} ,
-		{.name = "size", .has_arg = 1, .flag = NULL, .val = 'l'} ,
+		{.name = "length", .has_arg = 1, .flag = NULL, .val = 'l'} ,
 
 		{.name = 0, .has_arg = 0, .flag = 0, .val = 0} ,
 	};
-- 
1.6.2.1

