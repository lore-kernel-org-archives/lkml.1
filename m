Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbXKDNj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbXKDNj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbXKDNjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:39:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:36712 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXKDNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PrHn4vgHfRtiaJZ7VIgv0kkaLkq2tj2OgFeGAx+zJ6N61F1ybZ0QnCaNDXt8WbBLt/PT5CH5qrW58equMGQlu5m3BFfPnm3qlaz5TIPloG79z7/0waNiVacA5aaaL9sXjqofwtH5lHY10GGJL/5YZnF5URimt5qbXEqdBg1Fr1Y=
Message-ID: <9e4733910711040539h5714faeeq6a9985fa5a63963@mail.gmail.com>
Date: Sun, 4 Nov 2007 08:39:49 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [i2c] [PATCH] Fix i2c module parameter permissions for read/write
Cc: lkml <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
In-Reply-To: <20071104105501.380a840a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910711032155j1649a3b8u56a59e754d77f61b@mail.gmail.com>
	 <20071104105501.380a840a@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi John,
>
> On Sun, 4 Nov 2007 00:55:15 -0400, Jon Smirl wrote:
> > The permissions of i2c module parameters were set to zero making the
> > parameters invisible and unsettable from the kernel command line. This
> > patch changes the permissions to the standard 0644 read/write.
>
> These permissions have nothing to do with the kernel command line. They
> define whether a file is created in sysfs for the respective module
> parameter. Even with permissions set to 0, you can still set the value
> in question from the kernel command line with <module>.<parm>=<value>.

I figured out later by inserting printks into the driver that they
were being set from the command line, but without changing the
permissions there was no way to read them to verify.  The permissions
should at least be set to 0444 to allow them to be read.

IMHO the I2C_CLIENT_INSMOD macros could use some rework since they use
side effects to set variables without being explicit about it.

The real problem was unrelated to this, it was an off by one error in
the i2c bus numbering code of my embedded processor. That made the
parameters not work since I was setting them on a different bus.

Changed to 0444.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 8033e6b..395e430 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -588,7 +588,7 @@ union i2c_smbus_data {
 #define I2C_CLIENT_MODULE_PARM(var,desc) \
  static unsigned short var[I2C_CLIENT_MAX_OPTS] = I2C_CLIENT_DEFAULTS; \
  static unsigned int var##_num; \
-  module_param_array(var, short, &var##_num, 0); \
+  module_param_array(var, short, &var##_num, 0444); \
  MODULE_PARM_DESC(var,desc)

 #define I2C_CLIENT_MODULE_PARM_FORCE(name)                             \


-- 
Jon Smirl
jonsmirl@gmail.com
