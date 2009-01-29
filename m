Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZA2RoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZA2RoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZA2Rnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:43:49 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:42050 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbZA2Rns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:43:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CQHedaPc5G6Mr0HYaHl3Rk3613tUF7ZZ2Ur+c9R8lushWZ5a8DRcoqC15rA4Jsnio4
         gfPTHaMtGedrMW4Y4isTMAMVErK9kdGijQjGwUMu2ANXR113Mt8FSap4gtEfL9GVPoJq
         7HLiLWY4g2DVo4Vrk8KeCR00AsoLYF7qxT1ug=
Date: Thu, 29 Jan 2009 20:49:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/17] proc tty: switch ip2 to ->proc_fops
Message-ID: <20090129174931.GC21643@x200.localdomain>
References: <20090129174830.GA21643@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129174830.GA21643@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/char/ip2/ip2main.c |   74 ++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 70e0ebc..afd9247 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -139,7 +139,7 @@
 #include <linux/seq_file.h>
 
 static const struct file_operations ip2mem_proc_fops;
-static int ip2_read_proc(char *, char **, off_t, int, int *, void * );
+static const struct file_operations ip2_proc_fops;
 
 /********************/
 /* Type Definitions */
@@ -446,9 +446,9 @@ static const struct tty_operations ip2_ops = {
 	.stop            = ip2_stop,
 	.start           = ip2_start,
 	.hangup          = ip2_hangup,
-	.read_proc       = ip2_read_proc,
 	.tiocmget	 = ip2_tiocmget,
 	.tiocmset	 = ip2_tiocmset,
+	.proc_fops	 = &ip2_proc_fops,
 };
 
 /******************************************************************************/
@@ -3029,19 +3029,17 @@ static const struct file_operations ip2mem_proc_fops = {
  * different sources including ip2mkdev.c and a couple of other drivers.
  * The bugs are all mine.  :-)	=mhw=
  */
-static int ip2_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
+static int ip2_proc_show(struct seq_file *m, void *v)
 {
 	int	i, j, box;
-	int	len = 0;
 	int	boxes = 0;
 	int	ports = 0;
 	int	tports = 0;
-	off_t	begin = 0;
 	i2eBordStrPtr  pB;
+	char *sep;
 
-	len += sprintf(page, "ip2info: 1.0 driver: %s\n", pcVersion );
-	len += sprintf(page+len, "Driver: SMajor=%d CMajor=%d IMajor=%d MaxBoards=%d MaxBoxes=%d MaxPorts=%d\n",
+	seq_printf(m, "ip2info: 1.0 driver: %s\n", pcVersion);
+	seq_printf(m, "Driver: SMajor=%d CMajor=%d IMajor=%d MaxBoards=%d MaxBoxes=%d MaxPorts=%d\n",
 			IP2_TTY_MAJOR, IP2_CALLOUT_MAJOR, IP2_IPL_MAJOR,
 			IP2_MAX_BOARDS, ABS_MAX_BOXES, ABS_BIGGEST_BOX);
 
@@ -3053,7 +3051,8 @@ static int ip2_read_proc(char *page, char **start, off_t off,
 			switch( pB->i2ePom.e.porID & ~POR_ID_RESERVED ) 
 			{
 			case POR_ID_FIIEX:
-				len += sprintf( page+len, "Board %d: EX ports=", i );
+				seq_printf(m, "Board %d: EX ports=", i);
+				sep = "";
 				for( box = 0; box < ABS_MAX_BOXES; ++box )
 				{
 					ports = 0;
@@ -3065,79 +3064,74 @@ static int ip2_read_proc(char *page, char **start, off_t off,
 							++ports;
 						}
 					}
-					len += sprintf( page+len, "%d,", ports );
+					seq_printf(m, "%s%d", sep, ports);
+					sep = ",";
 					tports += ports;
 				}
-
-				--len;	/* Backup over that last comma */
-
-				len += sprintf( page+len, " boxes=%d width=%d", boxes, pB->i2eDataWidth16 ? 16 : 8 );
+				seq_printf(m, " boxes=%d width=%d", boxes, pB->i2eDataWidth16 ? 16 : 8);
 				break;
 
 			case POR_ID_II_4:
-				len += sprintf(page+len, "Board %d: ISA-4 ports=4 boxes=1", i );
+				seq_printf(m, "Board %d: ISA-4 ports=4 boxes=1", i);
 				tports = ports = 4;
 				break;
 
 			case POR_ID_II_8:
-				len += sprintf(page+len, "Board %d: ISA-8-std ports=8 boxes=1", i );
+				seq_printf(m, "Board %d: ISA-8-std ports=8 boxes=1", i);
 				tports = ports = 8;
 				break;
 
 			case POR_ID_II_8R:
-				len += sprintf(page+len, "Board %d: ISA-8-RJ11 ports=8 boxes=1", i );
+				seq_printf(m, "Board %d: ISA-8-RJ11 ports=8 boxes=1", i);
 				tports = ports = 8;
 				break;
 
 			default:
-				len += sprintf(page+len, "Board %d: unknown", i );
+				seq_printf(m, "Board %d: unknown", i);
 				/* Don't try and probe for minor numbers */
 				tports = ports = 0;
 			}
 
 		} else {
 			/* Don't try and probe for minor numbers */
-			len += sprintf(page+len, "Board %d: vacant", i );
+			seq_printf(m, "Board %d: vacant", i);
 			tports = ports = 0;
 		}
 
 		if( tports ) {
-			len += sprintf(page+len, " minors=" );
-
+			seq_puts(m, " minors=");
+			sep = "";
 			for ( box = 0; box < ABS_MAX_BOXES; ++box )
 			{
 				for ( j = 0; j < ABS_BIGGEST_BOX; ++j )
 				{
 					if ( pB->i2eChannelMap[box] & (1 << j) )
 					{
-						len += sprintf (page+len,"%d,",
+						seq_printf(m, "%s%d", sep,
 							j + ABS_BIGGEST_BOX *
 							(box+i*ABS_MAX_BOXES));
+						sep = ",";
 					}
 				}
 			}
-
-			page[ len - 1 ] = '\n';	/* Overwrite that last comma */
-		} else {
-			len += sprintf (page+len,"\n" );
-		}
-
-		if (len+begin > off+count)
-			break;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
 		}
+		seq_putc(m, '\n');
 	}
+	return 0;
+ }
 
-	if (i >= IP2_MAX_BOARDS)
-		*eof = 1;
-	if (off >= len+begin)
-		return 0;
+static int ip2_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ip2_proc_show, NULL);
+}
 
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
- }
+static const struct file_operations ip2_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ip2_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
  
 /******************************************************************************/
 /* Function:   ip2trace()                                                     */
-- 
1.5.6.5

