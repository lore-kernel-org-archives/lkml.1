Return-Path: <linux-kernel-owner+w=401wt.eu-S967823AbXFHDlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967823AbXFHDlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967647AbXFHDlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:41:19 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:60530 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967613AbXFHDlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:41:17 -0400
Subject: Re: [PATCH]: complete cleanup of check_region]
From: Surya <surya.prabhakar@wipro.com>
To: jesper.juhl@gmail.com, emoenke <emoenke@gwdg.de>
Cc: linux-kernel@vger.kernel.org,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technologies, Bangalore, India.
Date: Fri, 08 Jun 2007 09:10:15 +0530
Message-Id: <1181274015.3275.25.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 08 Jun 2007 03:41:14.0125 (UTC) FILETIME=[DCF33BD0:01C7A97E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

re-sending with a minor correction...

<snip>
> >
> > @@ -5640,6 +5645,7 @@ int __init sbpcd_init(void)
> >         int i=0, j=0;
> >         int addr[2]={1, CDROM_PORT};
> >         int port_index;
> > +       int request_region_flag;
> >
> One could argue that it would be possible to just use the 'j' variable
> for this since it's not used for anything else until the *_region()
> stuff is all done, that would save adding a new variable...
completely eliminated the variable, haven't felt the need for it.

<snip>
> >                 msg(DBG_INI,"check_drives done.\n");
> > +               if(request_region_flag==0)
> > +                       release_region(addr[1],4);
> 
> I know the driver in its current version just tests if the region is
> available and doesn't hang on to it, but I'm wondering if that's not a
> bug.  Shouldn't we actually hold on to this region as long as the
> driver is loaded and only release the region in the sbpcd_exit()
> function, just loke we do with the "CDo_command" region?  
But if any of the conditions fail after the request_region code, it is
returning an error and exiting out of init. Dont we need to cleanup
request_region's allocation before we exit. Infact I had a feeling that
CDo_command region cleanup was not perfect. Did a cleanup of both the
regions wherever we have a return out of the function.

Please have a look at the below patch.

diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
index a1283b1..5078211 100644
--- a/drivers/cdrom/sbpcd.c
+++ b/drivers/cdrom/sbpcd.c
@@ -358,6 +358,10 @@
  * Add bio/kdev_t changes for 2.5.x required to make it work again. 
  * Still room for improvement in the request handling here if anyone
  * actually cares.  Bring your own chainsaw.    Paul G.  02/2002
+ *
+ *
+ * Cleaned up the reference for deprecated check_region to 
+ * request_region.            - Surya Prabhakar N      08/07/2007
  */
 
 
@@ -555,6 +559,8 @@ static struct cdrom_read_audio read_audio;
 static unsigned char msgnum;
 static char msgbuf[80];
 
+static int addr[2]={1, CDROM_PORT};
+
 static int max_drives = MAX_DRIVES;
 module_param(max_drives, int, 0);
 #ifndef MODULE
@@ -5638,7 +5644,6 @@ int __init sbpcd_init(void)
 #endif
 {
 	int i=0, j=0;
-	int addr[2]={1, CDROM_PORT};
 	int port_index;
 
 	sti();
@@ -5670,9 +5675,9 @@ int __init sbpcd_init(void)
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
@@ -5699,6 +5704,7 @@ int __init sbpcd_init(void)
 	if (ndrives==0)
 	{
 		msg(DBG_INF, "No drive found.\n");
+		release_region(addr[1],4);
 #ifdef MODULE
 		return -EIO;
 #else
@@ -5775,6 +5781,7 @@ int __init sbpcd_init(void)
 	if (!request_region(CDo_command,4,major_name))
 	{
 		printk(KERN_WARNING "sbpcd: Unable to request region 0x%x\n", CDo_command);
+		release_region(addr[1],4);
 		return -EIO;
 	}
 
@@ -5788,6 +5795,8 @@ int __init sbpcd_init(void)
 #endif /* SOUND_BASE */
 
 	if (register_blkdev(MAJOR_NR, major_name)) {
+		release_region(CDo_command,4);
+		release_region(addr[1],4);
 #ifdef MODULE
 		return -EIO;
 #else
@@ -5801,6 +5810,7 @@ int __init sbpcd_init(void)
 	sbpcd_queue = blk_init_queue(do_sbpcd_request, &sbpcd_lock);
 	if (!sbpcd_queue) {
 		release_region(CDo_command,4);
+		release_region(addr[1],4);
 		unregister_blkdev(MAJOR_NR, major_name);
 		return -ENOMEM;
 	}
@@ -5834,6 +5844,7 @@ int __init sbpcd_init(void)
 				printk("Can't unregister %s\n", major_name);
 			}
 			release_region(CDo_command,4);
+			release_region(addr[1],4);
 			blk_cleanup_queue(sbpcd_queue);
 			return -EIO;
 		}
@@ -5850,6 +5861,7 @@ int __init sbpcd_init(void)
 		if (sbpcd_infop == NULL)
 		{
                         release_region(CDo_command,4);
+			release_region(addr[1],4);
 			blk_cleanup_queue(sbpcd_queue);
                         return -ENOMEM;
 		}
@@ -5894,6 +5906,7 @@ static void sbpcd_exit(void)
 		return;
 	}
 	release_region(CDo_command,4);
+	release_region(addr[1],4);
 	blk_cleanup_queue(sbpcd_queue);
 	for (j=0;j<NR_SBPCD;j++)
 	{


-surya.

