Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbXEURFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbXEURFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbXEURFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:05:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:64141 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbXEURFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=q/Uk9+AWPwLBtCqudZL1L3y8QcaI9qSnm6XG1TtrGwBY683Pl8Kj+wrfxP+HflyrUHZhdpGieVTADh3sDkiBlgai6sWzcI4hnrEDb3oHRmsGwAudI8RbU2C6Ats087YdFMxTqROyAsyz20WjqaXrR32BBt3exl7razfVRIV66Rg=
Date: Tue, 22 May 2007 01:58:21 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: fix notifiers when max_drivers is configured
Message-ID: <20070521165821.GA4077@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Markus Lidel <Markus.Lidel@shadowconnect.com>,
	linux-kernel@vger.kernel.org
References: <20070520142728.GB4207@APFDCB5C> <20070520211659.91c84574.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520211659.91c84574.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 09:16:59PM -0700, Andrew Morton wrote:
> > @@ -340,8 +341,7 @@ int __init i2o_driver_init(void)
> >  	spin_lock_init(&i2o_drivers_lock);
> >  
> >  	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64) ||
> > -	    ((i2o_max_drivers ^ (i2o_max_drivers - 1)) !=
> > -	     (2 * i2o_max_drivers - 1))) {
> > +	    !is_power_of_2(i2o_max_drivers)) {
> >  		osm_warn("max_drivers set to %d, but must be >=2 and <= 64 and "
> >  			 "a power of 2\n", i2o_max_drivers);
> >  		i2o_max_drivers = I2O_MAX_DRIVERS;
> 
> Is there any particular reason why i2o_max_drivers must be a power of two? 
> It seems a peculiar constraint.

I can't find the reason.

Subject: [patch -mm] i2o: eliminate a peculiar constraint on i2o_max_drivers

There is no reason i2o_max_drivers must be a power of two.
This patch eliminates such a constraint.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/message/i2o/driver.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: 2.6-mm/drivers/message/i2o/driver.c
===================================================================
--- 2.6-mm.orig/drivers/message/i2o/driver.c
+++ 2.6-mm/drivers/message/i2o/driver.c
@@ -20,7 +20,6 @@
 #include <linux/workqueue.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/log2.h>
 #include "core.h"
 
 #define OSM_NAME	"i2o"
@@ -340,10 +339,9 @@ int __init i2o_driver_init(void)
 
 	spin_lock_init(&i2o_drivers_lock);
 
-	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64) ||
-	    !is_power_of_2(i2o_max_drivers)) {
-		osm_warn("max_drivers set to %d, but must be >=2 and <= 64 and "
-			 "a power of 2\n", i2o_max_drivers);
+	if ((i2o_max_drivers < 2) || (i2o_max_drivers > 64)) {
+		osm_warn("max_drivers set to %d, but must be >=2 and <= 64\n",
+			 i2o_max_drivers);
 		i2o_max_drivers = I2O_MAX_DRIVERS;
 	}
 	osm_info("max drivers = %d\n", i2o_max_drivers);
