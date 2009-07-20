Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632AbZGTO64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbZGTO64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZGTO6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:58:55 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52202 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZGTO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:58:54 -0400
Message-ID: <4A64862C.6030704@linux.vnet.ibm.com>
Date: Mon, 20 Jul 2009 09:58:52 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi: possible double spin_lock_irqsave
References: <Pine.LNX.4.64.0907181722060.26792@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907181722060.26792@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If both the test on rport and the call to get_device fail, then the lock is
> already held.  The re-lock is thus moved up into the two branches.
> 
> On the other hand if kref_put should not be called with the lock held then
> something else should be done.

kref_put should not be called with the lock held. Updated patch below.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


Fixes a potential deadlock in the ibmvfc driver in the rport
add thread if it encounters an rport it wants to add which
it cannot get a reference to.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_add_locking drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_add_locking	2009-07-20 09:49:28.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-07-20 09:54:54.000000000 -0500
@@ -4283,7 +4283,8 @@ static void ibmvfc_rport_add_thread(stru
 					tgt_dbg(tgt, "Setting rport roles\n");
 					fc_remote_port_rolechg(rport, tgt->ids.roles);
 					put_device(&rport->dev);
-				}
+				} else
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
 				spin_lock_irqsave(vhost->host->host_lock, flags);
_
