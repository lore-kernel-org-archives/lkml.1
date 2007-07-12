Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXGLMy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXGLMy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbXGLMyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:54:52 -0400
Received: from smtp2.utsp.utwente.nl ([130.89.2.9]:45450 "EHLO smtp.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758456AbXGLMyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:54:52 -0400
X-Greylist: delayed 1395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 08:54:51 EDT
Date: Thu, 12 Jul 2007 14:31:31 +0200 (CEST)
From: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
To: linux-kernel@vger.kernel.org
Subject: RFH: Converting a driver from semaphore to mutex in 2.6.21
Message-ID: <Pine.LNX.4.62.0707121414540.17278@sarijopen.student.utwente.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-UTwente-MailScanner-Information: Scanned by MailScanner. Contact helpdesk@ITBE.utwente.nl for more information.
X-UTwente-MailScanner: Found to be clean
X-UTwente-MailScanner-From: mp3project@sarijopen.student.utwente.nl
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ave lkml folks.

I'm trying to convert the out of tree bt869 driver in 2.6.21 from using a 
semaphore to using a mutex. I followed the guidelines at 
http://lwn.net/Articles/164802/ and used 
http://lkml.org/lkml/2006/1/13/127 aa an example.
The original driver source can be found at 
http://sarijopen/~caligula/kernel/patches/bt869-2.6.21.patch

---------------

At first I only changed "struct semaphore update_lock" into "struct 
mutex_debug update_lock;"

However gcc gave me a
drivers/i2c/chips/bt869.c:63: error: field `update_lock' has incomplete type
make[1]: *** [drivers/i2c/chips/bt869.o] Error 1
make: *** [drivers/i2c/chips/bt869.ko] Error 2

----------------
Then I did a full conversion:

--- drivers/i2c/chips/bt869.c--orig	2007-07-12 07:14:18.000000000 +0200
+++ drivers/i2c/chips/bt869.c	2007-07-12 10:54:04.000000000 +0200
@@ -31,6 +31,7 @@
  #include <linux/init.h>
  #include <linux/slab.h>
  #include <linux/i2c.h>
+#include <linux/mutex.h>

  /* Addresses to scan */
  /* found only at 0x44 or 0x45 */
@@ -59,7 +60,7 @@ struct bt869_data {
  	struct i2c_client client;
  	int sysctl_id;

-	struct semaphore update_lock;
+	struct mutex_debug update_lock;
  	char valid;		/* !=0 if following fields are valid */
  	unsigned long last_updated;	/* In jiffies */

@@ -547,7 +548,7 @@ int bt869_detect(struct i2c_adapter *ada

  	//new_client->id = bt869_id++;
  	data->valid = 0;
-	init_MUTEX(&data->update_lock);
+	mutex_init(&data->update_lock);

  	/* Tell the I2C layer a new client has arrived */
  	if ((err = i2c_attach_client(new_client)))
@@ -650,7 +651,7 @@ static struct bt869_data *bt869_update_c
  	struct i2c_client *client = to_i2c_client(dev);
  	struct bt869_data *data = i2c_get_clientdata(client);

-	down(&data->update_lock);
+	mutex_lock(&data->update_lock);

  	if ((jiffies - data->last_updated > HZ + HZ / 2) ||
  	    (jiffies < data->last_updated) || !data->valid) {
@@ -732,7 +733,7 @@ static struct bt869_data *bt869_update_c
  		data->last_updated = jiffies;
  		data->valid = 1;
  	}
-	up(&data->update_lock);
+	mutex_unlock(&data->update_lock);

  	return data;
  }


Still gcc gives me a :
drivers/i2c/chips/bt869.c:63: error: field `update_lock' has incomplete 
type
make[1]: *** [drivers/i2c/chips/bt869.o] Error 1
make: *** [drivers/i2c/chips/bt869.ko] Error 2


I must miss something really really obvious, but I really can't find it.
Can someone guide me to the Right Way (TM) to convert this semaphore?
Thanks

Martijn Uffing



