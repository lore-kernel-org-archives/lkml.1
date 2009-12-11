Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbZLKKeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbZLKKeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZLKKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:34:30 -0500
Received: from mga12.intel.com ([143.182.124.36]:14777 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754728AbZLKKe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:34:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="221519010"
Date: Fri, 11 Dec 2009 11:36:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eduardo Valentin <eduardo.valentin@nokia.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Cc: "gadiyar@ti.com" <gadiyar@ti.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       List Linux Omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: twl4030: clarify the return value for read
 and write
Message-ID: <20091211103609.GB5863@sortiz.org>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0309DAC23C@dbde02.ent.ti.com>
 <449d505b874c236e4d0df0c1f765918386a4d58b.1260187781.git.amit.kucheria@verdurent.com>
 <20091207135309.GA23829@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207135309.GA23829@esdhcp037198.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Mon, Dec 07, 2009 at 03:53:09PM +0200, Eduardo Valentin wrote:
> On Mon, Dec 07, 2009 at 01:17:29PM +0100, ext Amit Kucheria wrote:
> > Infact, we can just return -EIO so that caller knows for sure that all
> > messages were not tranferred. Please consider fixed patch instead.
> > 
> > We should be checking if all the messages were tranferred or not. And return
> > -1 for failure. Currently we return success (0) even if none of messages were
> > transferred successfully.
> > 
> > Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> > ---
> >  drivers/mfd/twl4030-core.c |   24 ++++++++++++++++--------
> >  1 files changed, 16 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> > index 56f1de5..3d2c413 100644
> > --- a/drivers/mfd/twl4030-core.c
> > +++ b/drivers/mfd/twl4030-core.c
> > @@ -292,10 +292,14 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
> >  	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
> >  	mutex_unlock(&twl->xfer_lock);
> >  
> > -	/* i2cTransfer returns num messages.translate it pls.. */
> > -	if (ret >= 0)
> > -		ret = 0;
> > -	return ret;
> > +	/* i2c_transfer returns number of messages transferred */
> > +	if (ret != 1) {
> > +		pr_err("%s: i2c_write failed to transfer all messages\n",
> > +			DRIVER_NAME);
> > +		return -EIO;
> 
> How about reporting the actual error that has occurred and reported by i2c_transfer?
> Instead of just masking it as EIO? If i2c_transfer returns something > 0 then EIO should be right.
> But if returns and error code, then that error code must be reported to upper layers.
>
So, I applied a modified version of this patch, see below. If you disagree
with it, please let me know and I wont push it upstream.


commit 8aa7cfd5732dee80aaaf3caa0a1d2f9621126315
Author: Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Fri Dec 11 11:31:11 2009 +0100

    mfd: Clarify twl4030 return value for read and write
    
    We should be checking if all the messages were tranferred. If not, then we
    should propagate the i2c core error code.
    Currently we return success (0) even if none of messages were transferred
    successfully.
    
    Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index e4a5d48..8add16c 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -306,10 +306,14 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
 	mutex_unlock(&twl->xfer_lock);
 
-	/* i2cTransfer returns num messages.translate it pls.. */
-	if (ret >= 0)
-		ret = 0;
-	return ret;
+	/* i2c_transfer returns number of messages transferred */
+	if (ret != 1) {
+		pr_err("%s: i2c_write failed to transfer all messages\n",
+			DRIVER_NAME);
+		return ret;
+	} else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL(twl4030_i2c_write);
 
@@ -358,10 +362,14 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 2);
 	mutex_unlock(&twl->xfer_lock);
 
-	/* i2cTransfer returns num messages.translate it pls.. */
-	if (ret >= 0)
-		ret = 0;
-	return ret;
+	/* i2c_transfer returns number of messages transferred */
+	if (ret != 2) {
+		pr_err("%s: i2c_read failed to transfer all messages\n",
+			DRIVER_NAME);
+		return ret;
+	} else {
+		return 0;
+	}
 }
 EXPORT_SYMBOL(twl4030_i2c_read);
 
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
