Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0BBGCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:02:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60293 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0BBGB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:01:58 -0500
Date: Tue, 2 Feb 2010 17:01:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the driver-core tree with the suspend
 tree
Message-Id: <20100202170155.0fa4ce45.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/power/main.c between commit
de20f9bde404252647645f9f948c8c5de16cc51d ("PM: Asynchronous suspend and
resume of devices") from the suspend tree and commit
df5a0aec4591ae8a5deb67bc8cb6be3d0812abb2 ("drivers/base: Convert dev->sem
to mutex") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/power/main.c
index 0e26a6f,05848a9..0000000
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@@ -507,11 -476,8 +507,11 @@@ static int device_resume(struct device 
  	TRACE_DEVICE(dev);
  	TRACE_RESUME(0);
  
 +	dpm_wait(dev->parent, async);
- 	down(&dev->sem);
+ 	mutex_lock(&dev->mutex);
  
 +	dev->power.status = DPM_RESUMING;
 +
  	if (dev->bus) {
  		if (dev->bus->pm) {
  			pm_dev_dbg(dev, state, "");
@@@ -543,8 -509,7 +543,8 @@@
  		}
  	}
   End:
- 	up(&dev->sem);
+ 	mutex_unlock(&dev->mutex);
 +	complete_all(&dev->power.completion);
  
  	TRACE_RESUME(error);
  	return error;
@@@ -808,12 -740,8 +808,12 @@@ static int __device_suspend(struct devi
  {
  	int error = 0;
  
 +	dpm_wait_for_children(dev, async);
- 	down(&dev->sem);
+ 	mutex_lock(&dev->mutex);
  
 +	if (async_error)
 +		goto End;
 +
  	if (dev->class) {
  		if (dev->class->pm) {
  			pm_dev_dbg(dev, state, "class ");
@@@ -844,13 -772,8 +844,13 @@@
  			error = legacy_suspend(dev, state, dev->bus->suspend);
  		}
  	}
 +
 +	if (!error)
 +		dev->power.status = DPM_OFF;
 +
   End:
- 	up(&dev->sem);
+ 	mutex_unlock(&dev->mutex);
 +	complete_all(&dev->power.completion);
  
  	return error;
  }
