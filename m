Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXFLEQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXFLEQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbXFLEQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:16:01 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:37121 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXFLEQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:16:00 -0400
Subject: [PATCH]: check_region cleanup in sbpcd.c
From: Surya <surya.prabhakar@wipro.com>
To: Jesper Juhl <jesper.juhl@gmail.com>, emoenke@gwdg.de
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@lists.osdl.org
In-Reply-To: <9a8748490706110418m70d4b26ege20a51f04b8ff7ff@mail.gmail.com>
References: <1181209169.2422.12.camel@bluegenie>
	 <9a8748490706070308m7c2212fq30fe712e26e2463b@mail.gmail.com>
	 <1181215018.3275.2.camel@bluegenie>
	 <9a8748490706070902i218e01bdq1c418c770e99ca4@mail.gmail.com>
	 <1181270772.3275.15.camel@bluegenie>
	 <9a8748490706110418m70d4b26ege20a51f04b8ff7ff@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technologies, Bangalore, India.
Date: Tue, 12 Jun 2007 09:45:45 +0530
Message-Id: <1181621746.28392.9.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 12 Jun 2007 04:16:00.0406 (UTC) FILETIME=[621F7360:01C7ACA8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > + *
> > + *
> 
> Why two blank comment lines?  Isn't one enough?
cleaned it up.
> 
>  sti();
> Just in case you are bored, at some point those cli()/sti() need to go
> away as well and be replaced with proper locking. But that's a
> different patch :-)
sure will take it up in the next patch.
> 
> > Kindly update if this is Ok. I will proceed with the original patch.
> This looks a lot better to me. I have only given it a quick look, but
> I don't see any major problems.
> 
I am sending with all the corrections, if its ok to acknowledge it?

> Please tell your mail client not to include crap like that when
> sending to public mailing lists.
Really sorry, I have no control over this.

Attaching the new patch with all the corrections.. thanks.


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
