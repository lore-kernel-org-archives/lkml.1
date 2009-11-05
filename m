Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZKENLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZKENLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZKENLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:11:22 -0500
Received: from bamako.nerim.net ([62.4.17.28]:50188 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbZKENLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:11:20 -0500
Date: Thu, 5 Nov 2009 14:11:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: Shared i2c adapter locking
Message-ID: <20091105141122.56b6b4f8@hyperion.delvare>
In-Reply-To: <1256828976.2827.27.camel@achroite>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	<20091029154317.651904b9@hyperion.delvare>
	<1256828976.2827.27.camel@achroite>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, 29 Oct 2009 15:09:36 +0000, Ben Hutchings wrote:
> On Thu, 2009-10-29 at 15:43 +0100, Jean Delvare wrote:
> > Hi Stephen,
> > 
> > On Mon, 26 Oct 2009 13:37:57 +1100, Stephen Rothwell wrote:
> > > Today's linux-next merge of the net tree got a conflict in
> > > drivers/net/sfc/sfe4001.c between commit
> > > 3f7c0648f727a6d5baf6117653e4001dc877b90b ("i2c: Prevent priority
> > > inversion on top of bus lock") from the i2c tree and commit
> > > c9597d4f89565b6562bd3026adbe6eac6c317f47 ("sfc: Merge sfe4001.c into
> > > falcon_boards.c") from the net tree.
> > > 
> > > I have applied the following merge fixup patch (after removing
> > > drivers/net/sfc/sfe4001.c) and can carry it as necessary.
> > 
> > Thanks for fixing it. The core problem here IMHO is that the sfc
> > network driver touches i2c internals which it would rather leave alone.
> 
> I'm just a little proud of having the idea that we could avoid using an
> I/O-expander on this board, but yes, the software side of this
> multiplexing is a hack.
> 
> > This is the only driver I know of which does this.
> > 
> > I can think of 3 different ways to address the issue.
> > 
> > Method #1: add a public API to grab/release an I2C segment.
> > 
> > void i2c_adapter_lock(struct i2c_adapter *adapter)
> > {
> > 	rt_mutex_lock(&adapter->bus_lock);
> > }
> > 
> > void i2c_adapter_unlock(struct i2c_adapter *adapter)
> > {
> > 	rt_mutex_unlock(&adapter->bus_lock);
> > }
> [...]
> > I'm not really sure if I have a preference yet, so please speak up if
> > you do.
> 
> Indirect lock operations are a recipe for deadlock, and there doesn't
> seem to be any other user for this, so method 1 seems best.

Well, all 3 methods rely on indirect lock operations to some degree.
But I am fine with method #1 for now. We can always move to something
more complex if the need ever arises.

What about the following patch?

From: Jean Delvare <khali@linux-fr.org>
Subject: i2c: Add an interface to lock/unlock I2C bus segment

Some drivers need to be able to prevent access to an I2C bus segment
for a specific period of time. Add an interface for them to do so
without twiddling with i2c-core internals.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
---
 drivers/net/sfc/sfe4001.c |    4 ++--
 include/linux/i2c.h       |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

--- linux-2.6.32-rc6.orig/drivers/net/sfc/sfe4001.c	2009-11-05 10:51:56.000000000 +0100
+++ linux-2.6.32-rc6/drivers/net/sfc/sfe4001.c	2009-11-05 13:40:17.000000000 +0100
@@ -188,7 +188,7 @@ static int sfn4111t_reset(struct efx_nic
 	efx_oword_t reg;
 
 	/* GPIO 3 and the GPIO register are shared with I2C, so block that */
-	mutex_lock(&efx->i2c_adap.bus_lock);
+	i2c_lock_adapter(&efx->i2c_adap);
 
 	/* Pull RST_N (GPIO 2) low then let it up again, setting the
 	 * FLASH_CFG_1 strap (GPIO 3) appropriately.  Only change the
@@ -204,7 +204,7 @@ static int sfn4111t_reset(struct efx_nic
 	falcon_write(efx, &reg, GPIO_CTL_REG_KER);
 	msleep(1);
 
-	mutex_unlock(&efx->i2c_adap.bus_lock);
+	i2c_unlock_adapter(&efx->i2c_adap);
 
 	ssleep(1);
 	return 0;
--- linux-2.6.32-rc6.orig/include/linux/i2c.h	2009-11-05 10:51:56.000000000 +0100
+++ linux-2.6.32-rc6/include/linux/i2c.h	2009-11-05 14:03:53.000000000 +0100
@@ -361,6 +361,24 @@ static inline void i2c_set_adapdata(stru
 	dev_set_drvdata(&dev->dev, data);
 }
 
+/**
+ * i2c_lock_adapter - Prevent access to an I2C bus segment
+ * @adapter: Target I2C bus segment
+ */
+static inline void i2c_lock_adapter(struct i2c_adapter *adapter)
+{
+	mutex_lock(&adapter->bus_lock);
+}
+
+/**
+ * i2c_unlock_adapter - Reauthorize access to an I2C bus segment
+ * @adapter: Target I2C bus segment
+ */
+static inline void i2c_unlock_adapter(struct i2c_adapter *adapter)
+{
+	mutex_unlock(&adapter->bus_lock);
+}
+
 /*flags for the client struct: */
 #define I2C_CLIENT_PEC	0x04		/* Use Packet Error Checking */
 #define I2C_CLIENT_TEN	0x10		/* we have a ten bit chip address */


-- 
Jean Delvare
