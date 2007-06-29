Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXF2Cnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXF2Cnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbXF2Cnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:43:46 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:56473 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbXF2Cnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:43:45 -0400
Subject: updated sbpcd.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: emoenke <emoenke@gwdg.de>
Cc: linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Fri, 29 Jun 2007 08:17:13 +0530
Message-Id: <1183085233.3037.19.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 29 Jun 2007 02:43:56.0437 (UTC) FILETIME=[569A6C50:01C7B9F7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi emoenke,
   Can this patch be verified and pulled into your tree.

thanks.
Surya.



From: Jesper Juhl <jesper.juhl@gmail.com>
To: Surya <surya.prabhakar@wipro.com>
Cc: , Linux Kernel <linux-kernel@vger.kernel.org>,
kernel-janitors@lists.osdl.org
Subject: Re: [PATCH]: check_region cleanup in sbpcd.c
Date: Tue, 26 Jun 2007 01:07:41 +0200

On 12/06/07, Surya <surya.prabhakar@wipro.com> wrote:
[snip]
> >
> I am sending with all the corrections, if its ok to acknowledge it?
>
Looks good to me.

>
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
Reviewed-by: Jesper Juhl <jesper.juhl@gmail.com>



----snip------

Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
--- 

diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
index a1283b1..5414172 100644
--- a/drivers/cdrom/sbpcd.c
+++ b/drivers/cdrom/sbpcd.c
@@ -358,6 +358,9 @@
  * Add bio/kdev_t changes for 2.5.x required to make it work again. 
  * Still room for improvement in the request handling here if anyone
  * actually cares.  Bring your own chainsaw.    Paul G.  02/2002
+ *
+ * Deprecated check_region cleanup to request_region 
+ *				-Surya Prabhakar N    08/07/2007
  */
 

@@ -555,6 +558,7 @@ static struct cdrom_read_audio read_audio;
 static unsigned char msgnum;
 static char msgbuf[80];
 
+static int addr[2] = {1, CDROM_PORT};
 static int max_drives = MAX_DRIVES;
 module_param(max_drives, int, 0);
 #ifndef MODULE
@@ -5638,7 +5642,6 @@ int __init sbpcd_init(void)
 #endif
 {
 	int i=0, j=0;
-	int addr[2]={1, CDROM_PORT};
 	int port_index;
 
 	sti();
@@ -5670,9 +5673,9 @@ int __init sbpcd_init(void)
 	{
 		addr[1]=sbpcd[port_index];
 		if (addr[1]==0) break;
-		if (check_region(addr[1],4))
+		if (!request_region(addr[1],4, "sbpcd driver"))
 		{
-			msg(DBG_INF,"check_region: %03X is not free.\n",addr[1]);
+			msg(DBG_INF,"request_region: %03X is not free.\n",addr[1]);
 			continue;
 		}
 		if (sbpcd[port_index+1]==2) type=str_sp;
@@ -5699,6 +5702,7 @@ int __init sbpcd_init(void)
 	if (ndrives==0)
 	{
 		msg(DBG_INF, "No drive found.\n");
+		release_region(addr[1],4);
 #ifdef MODULE
 		return -EIO;
 #else
@@ -5775,6 +5779,7 @@ int __init sbpcd_init(void)
 	if (!request_region(CDo_command,4,major_name))
 	{
 		printk(KERN_WARNING "sbpcd: Unable to request region 0x%x\n", CDo_command);
+		release_region(addr[1],4);
 		return -EIO;
 	}
 
@@ -5788,6 +5793,8 @@ int __init sbpcd_init(void)
 #endif /* SOUND_BASE */
 
 	if (register_blkdev(MAJOR_NR, major_name)) {
+		release_region(CDo_command,4);
+		release_region(addr[1],4);
 #ifdef MODULE
 		return -EIO;
 #else
@@ -5801,6 +5808,7 @@ int __init sbpcd_init(void)
 	sbpcd_queue = blk_init_queue(do_sbpcd_request, &sbpcd_lock);
 	if (!sbpcd_queue) {
 		release_region(CDo_command,4);
+		release_region(addr[1],4);
 		unregister_blkdev(MAJOR_NR, major_name);
 		return -ENOMEM;
 	}
@@ -5834,6 +5842,7 @@ int __init sbpcd_init(void)
 				printk("Can't unregister %s\n", major_name);
 			}
 			release_region(CDo_command,4);
+			release_region(addr[1],4);
 			blk_cleanup_queue(sbpcd_queue);
 			return -EIO;
 		}
@@ -5850,6 +5859,7 @@ int __init sbpcd_init(void)
 		if (sbpcd_infop == NULL)
 		{
                         release_region(CDo_command,4);
+			release_region(addr[1],4);
 			blk_cleanup_queue(sbpcd_queue);
                         return -ENOMEM;
 		}
@@ -5894,6 +5904,7 @@ static void sbpcd_exit(void)
 		return;
 	}
 	release_region(CDo_command,4);
+	release_region(addr[1],4);
 	blk_cleanup_queue(sbpcd_queue);
 	for (j=0;j<NR_SBPCD;j++)
 	{

-surya.
