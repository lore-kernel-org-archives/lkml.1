Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYFJOos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYFJOos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYFJOoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:44:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54195 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYFJOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:44:38 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org
Subject: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
Date: Tue, 10 Jun 2008 16:44:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During corner case testing, we noticed that some versions of ehca 
do not properly transition to interrupt done in special load situations.
This can be resolved by periodically triggering EOI through H_EOI, 
if eqes are pending.

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>

---
This patch replaces my previous patch-set.
As Paul suggested, this version of the patch calls H_EOI directly and doesn't need
any ibmebus changes.
 
 drivers/infiniband/hw/ehca/ehca_main.c |   11 +++++++++--
 drivers/infiniband/hw/ehca/hcp_if.c    |   11 +++++++++++
 drivers/infiniband/hw/ehca/hcp_if.h    |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 482103e..add4ff4 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -937,6 +937,7 @@ static struct of_platform_driver ehca_driver = {
 void ehca_poll_eqs(unsigned long data)
 {
 	struct ehca_shca *shca;
+	u64 ret;
 
 	spin_lock(&shca_list_lock);
 	list_for_each_entry(shca, &shca_list, shca_list) {
@@ -955,8 +956,14 @@ void ehca_poll_eqs(unsigned long data)
 				spin_unlock_irqrestore(&eq->spinlock, flags);
 				max--;
 			} while (q_ofs == q_ofs2 && max > 0);
-			if (q_ofs == q_ofs2)
-				ehca_process_eq(shca, 0);
+			if (q_ofs == q_ofs2) {
+				ret = hipz_h_eoi(eq->ist);
+				if (ret != H_SUCCESS)
+					ehca_err(&shca->ib_device,
+						 "bad return code EOI -"
+						 "rc = %ld\n", ret);
+				tasklet_hi_schedule(&shca->eq.interrupt_task);
+			}
 		}
 	}
 	mod_timer(&poll_eqs_timer, round_jiffies(jiffies + HZ));
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 5245e13..7084efd 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -933,3 +933,14 @@ u64 hipz_h_error_data(const struct ipz_adapter_handle adapter_handle,
 				       r_cb,
 				       0, 0, 0, 0);
 }
+
+u64 hipz_h_eoi(int irq)
+{
+	int value;
+	unsigned long xirr;
+
+	iosync();
+	value = (0xff << 24) | irq;
+	xirr = value & 0xffffffff;
+	return plpar_hcall_norets(H_EOI, xirr);
+}
diff --git a/drivers/infiniband/hw/ehca/hcp_if.h b/drivers/infiniband/hw/ehca/hcp_if.h
index 60ce02b..2c3c6e0 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.h
+++ b/drivers/infiniband/hw/ehca/hcp_if.h
@@ -260,5 +260,6 @@ u64 hipz_h_error_data(const struct ipz_adapter_handle adapter_handle,
 		      const u64 ressource_handle,
 		      void *rblock,
 		      unsigned long *byte_count);
+u64 hipz_h_eoi(int irq);
 
 #endif /* __HCP_IF_H__ */
-- 
1.5.5

