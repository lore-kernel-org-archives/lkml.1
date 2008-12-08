Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYLHWau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYLHWau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYLHWaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:30:17 -0500
Received: from ns.yankeeboysoftware.com ([213.208.101.60]:13347 "EHLO
	smtp.yankeeboysoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbYLHWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:30:15 -0500
X-Greylist: delayed 2933 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 17:30:15 EST
Message-ID: <493D96E8.2070406@yankeeboysoftware.com>
Date: Mon, 08 Dec 2008 21:51:36 +0000
From: Jack <gridley@yankeeboysoftware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 SeaMonkey/1.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Fwd: Minor patch to w1]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
X-Spam-Report: Spam detection software, running on the system "prima.yankeeboysoftware.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  -------- Original Message -------- Subject: Minor patch to
	w1 Date: Mon, 08 Dec 2008 21:46:05 +0000 From: Jack <gridley@yankeeboysoftware.com>
	To: johnpol@2ka.mipt.ru Hello Evgeniy, Please accept my patch for the removal
	of const on a few functions. This resolves a compile time warning in w1.
	The buffer parameter ('buf') is definitely not const, since it is always written
	to after a read. [...] 
	Content analysis details:   (-1.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-------- Original Message --------
Subject: 	Minor patch to w1
Date: 	Mon, 08 Dec 2008 21:46:05 +0000
From: 	Jack <gridley@yankeeboysoftware.com>
To: 	johnpol@2ka.mipt.ru



Hello Evgeniy,

Please accept my patch for the removal of const on a few functions.    
This resolves a compile time warning in w1.  The buffer parameter 
('buf') is definitely not const, since it is always written to after a 
read. 

Of course, I'm a bit new to kernel development, so perhaps I'm missing 
something.  If that is the case, I would appreciate an explanation, so 
that I won't make the same mistake again.

Regards,
Jack
-------------------------------------------------------------------------------------------

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 59ad6e9..603b102 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -819,7 +819,7 @@ static u8 ds9490r_read_byte(void *data)
       return byte;
}

-static void ds9490r_write_block(void *data, const u8 *buf, int len)
+static void ds9490r_write_block(void *data, u8 *buf, int len)
{
       struct ds_device *dev = data;

diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 858c16a..4bbf3b5 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -154,7 +154,7 @@ out_up:
 * @param data The data to write
 * @return     0=Success -1=failure
 */
-static int w1_f23_write(struct w1_slave *sl, int addr, int len, const 
u8 *data)
+static int w1_f23_write(struct w1_slave *sl, int addr, int len, u8 *data)
{
       u8 wrbuf[4];
       u8 rdbuf[W1_PAGE_SIZE + 3];
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 97304bd..d17c45e 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -127,7 +127,7 @@ struct w1_bus_master
       u8              (*read_block)(void *, u8 *, int);

       /** Same as a series of write_byte() calls */
-       void            (*write_block)(void *, const u8 *, int);
+       void            (*write_block)(void *, u8 *, int);

       /**
        * Combines two reads and a smart write for ROM searches
@@ -209,7 +209,7 @@ void w1_write_8(struct w1_master *, u8);
u8 w1_read_8(struct w1_master *);
int w1_reset_bus(struct w1_master *);
u8 w1_calc_crc8(u8 *, int);
-void w1_write_block(struct w1_master *, const u8 *, int);
+void w1_write_block(struct w1_master *, u8 *, int);
u8 w1_read_block(struct w1_master *, u8 *, int);
int w1_reset_select_slave(struct w1_slave *sl);
void w1_next_pullup(struct w1_master *, int);
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 0d15b0e..fe1c7e3 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -240,7 +240,7 @@ EXPORT_SYMBOL_GPL(w1_read_8);
 * @param len     the number of bytes to write
 * @return        the byte read
 */
-void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
+void w1_write_block(struct w1_master *dev, u8 *buf, int len)
{
       int i;



