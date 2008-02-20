Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbYBSX6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbYBSX6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbYBSX60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:58:26 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:60955 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYBSX6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:58:25 -0500
Message-ID: <47BB6DAB.5050506@keyaccess.nl>
Date: Wed, 20 Feb 2008 01:00:43 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: ambx1@neo.rr.com, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: pnp_bus_resume(): inconsequent NULL checking
References: <20080219224908.GM31955@cs181133002.pp.htv.fi>
In-Reply-To: <20080219224908.GM31955@cs181133002.pp.htv.fi>
Content-Type: multipart/mixed;
 boundary="------------010405010000090802070009"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010405010000090802070009
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 19-02-08 23:49, Adrian Bunk wrote:

> The Coverity checker spotted the following inconsequent NULL checking 
> introduced by commit 5d38998ed15b31f524bde9a193d60150af30d916:
> 
> <--  snip  -->
> 
> ...
> static int pnp_bus_resume(struct device *dev)
> {
> ...
>         if (pnp_dev->protocol && pnp_dev->protocol->resume)
>                 pnp_dev->protocol->resume(pnp_dev);
> 
>         if (pnp_can_write(pnp_dev)) {
> ...
> 
> <--  snip  -->
> 
> pnp_can_write(pnp_dev) dereferences pnp_dev->protocol.

I see, thanks. pnp_bus_suspend() has the same problem (I added this test to 
complete the mirror in fact) and/but is not a real problem since the tests 
are also the first things done inside the blocks they protect -- if 
pnp_dev->protocol isn't set here, we're dead anyway therefore.

That probably means we can just delete the pnp_dev->protocol tests but this 
  would need an ack from for example Bjorn Helgaas who might have an idea 
about how generically useful this is designed to be. The no brain thing to 
do would be just as per attached.

Bjorn?

--------------010405010000090802070009
Content-Type: text/plain;
 name="coverity-pnp_bus_suspend_resume.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="coverity-pnp_bus_suspend_resume.diff"

pnp: be consistent about testing pnp_dev->protocol in pnp_bus_{suspend,resume}

pnp_can_{disable,write}() dereference pnp_dev->protocol. So do the
pnp_{stop,start}_dev() the tests protect, but let's be consistent
at least.

Spotted by Adrian Bunk <bunk@kernel.org> and the Coverity checker.

Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index 12a1645..170af61 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -160,15 +160,15 @@ static int pnp_bus_suspend(struct device *dev, pm_message_t state)
 		if (error)
 			return error;
 	}
-
-	if (pnp_can_disable(pnp_dev)) {
-		error = pnp_stop_dev(pnp_dev);
-		if (error)
-			return error;
+	if (pnp_dev->protocol) {
+		if (pnp_can_disable(pnp_dev)) {
+			error = pnp_stop_dev(pnp_dev);
+			if (error)
+				return error;
+		}
+		if (pnp_dev->protocol->suspend)
+			pnp_dev->protocol->suspend(pnp_dev, state);
 	}
-
-	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
-		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
 }
 
@@ -181,21 +181,21 @@ static int pnp_bus_resume(struct device *dev)
 	if (!pnp_drv)
 		return 0;
 
-	if (pnp_dev->protocol && pnp_dev->protocol->resume)
-		pnp_dev->protocol->resume(pnp_dev);
+	if (pnp_dev->protocol) {
+		if (pnp_dev->protocol->resume)
+			pnp_dev->protocol->resume(pnp_dev);
 
-	if (pnp_can_write(pnp_dev)) {
-		error = pnp_start_dev(pnp_dev);
-		if (error)
-			return error;
+		if (pnp_can_write(pnp_dev)) {
+			error = pnp_start_dev(pnp_dev);
+			if (error)
+				return error;
+		}
 	}
-
 	if (pnp_drv->resume) {
 		error = pnp_drv->resume(pnp_dev);
 		if (error)
 			return error;
 	}
-
 	return 0;
 }
 

--------------010405010000090802070009--
