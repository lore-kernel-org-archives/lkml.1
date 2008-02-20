Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYBTRF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYBTRF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYBTRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:05:44 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:6077 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYBTRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:05:42 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: pnp_bus_resume(): inconsequent NULL checking
Date: Wed, 20 Feb 2008 09:59:21 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org
References: <20080219224908.GM31955@cs181133002.pp.htv.fi> <47BB6DAB.5050506@keyaccess.nl>
In-Reply-To: <47BB6DAB.5050506@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200959.21814.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 05:00:43 pm Rene Herman wrote:
> On 19-02-08 23:49, Adrian Bunk wrote:
> 
> > The Coverity checker spotted the following inconsequent NULL checking 
> > introduced by commit 5d38998ed15b31f524bde9a193d60150af30d916:
> > 
> > <--  snip  -->
> > 
> > ...
> > static int pnp_bus_resume(struct device *dev)
> > {
> > ...
> >         if (pnp_dev->protocol && pnp_dev->protocol->resume)
> >                 pnp_dev->protocol->resume(pnp_dev);
> > 
> >         if (pnp_can_write(pnp_dev)) {
> > ...
> > 
> > <--  snip  -->
> > 
> > pnp_can_write(pnp_dev) dereferences pnp_dev->protocol.
> 
> I see, thanks. pnp_bus_suspend() has the same problem (I added this test to 
> complete the mirror in fact) and/but is not a real problem since the tests 
> are also the first things done inside the blocks they protect -- if 
> pnp_dev->protocol isn't set here, we're dead anyway therefore.
> 
> That probably means we can just delete the pnp_dev->protocol tests but this 
>   would need an ack from for example Bjorn Helgaas who might have an idea 
> about how generically useful this is designed to be. The no brain thing to 
> do would be just as per attached.

I agree with you that we can just delete the dev->protocol tests
completely. So I'd rather see something like this (built but untested):


PNP: remove dev->protocol NULL checks

Every PNP device should have a valid protocol pointer.  If it doesn't,
something's wrong and we should oops so we can find and fix the problem.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work6/drivers/pnp/driver.c
===================================================================
--- work6.orig/drivers/pnp/driver.c	2008-02-20 09:46:01.000000000 -0700
+++ work6/drivers/pnp/driver.c	2008-02-20 09:46:28.000000000 -0700
@@ -167,7 +167,7 @@
 			return error;
 	}
 
-	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
+	if (pnp_dev->protocol->suspend)
 		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
 }
@@ -181,7 +181,7 @@
 	if (!pnp_drv)
 		return 0;
 
-	if (pnp_dev->protocol && pnp_dev->protocol->resume)
+	if (pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
 	if (pnp_can_write(pnp_dev)) {
