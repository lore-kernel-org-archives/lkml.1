Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYDHTki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYDHTki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbYDHTk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:40:27 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:50620 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYDHTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:40:23 -0400
From: Roland Dreier <rdreier@cisco.com>
To: akepner@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v6] IB: expand ib_umem_get() prototype
References: <20080401013744.GE29410@sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 08 Apr 2008 12:40:21 -0700
In-Reply-To: <20080401013744.GE29410@sgi.com> (akepner@sgi.com's message of
	"Mon, 31 Mar 2008 18:37:44 -0700")
Message-ID: <adar6dgm8yi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2008 19:40:22.0199 (UTC) FILETIME=[62443470:01C899B0]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of this looks good to me, and I'm happy we are finally fixing this
up.  However, now that it is finally ready to merge, I started thinking
about the libmthca changes required to handle this, and I realized that
we can actually avoid this:

 > --- a/drivers/infiniband/hw/mthca/mthca_user.h
 > +++ b/drivers/infiniband/hw/mthca/mthca_user.h
 > @@ -41,7 +41,7 @@
 >   * Increment this value if any changes that break userspace ABI
 >   * compatibility are made.
 >   */
 > -#define MTHCA_UVERBS_ABI_VERSION	1
 > +#define MTHCA_UVERBS_ABI_VERSION	2

Instead the mthca kernel driver can look at the size of the data passed
in from userspace, and fall back to the old behavior if it's talking to
old userspace.

I think this is a net win.  The current patch gives the following:

 old kernel, old userspace: current behavior (subtle failure on Altix)
 new kernel, old userspace: refuses to run (on all systems)
 old kernel, new userspace: current behavior (broken on Altix),
 new kernel, new userspace: works everywhere

with my proposed change, the only difference is:

 new kernel, old userspace: current behavior (subtle failure on Altix),
                            plus print a warning telling people to
                            update userspace.

and given that the vast majority of the systems where mthca is used are
*not* Altix systems, it seems more friendly to leave them working across
a kernel update.

Andrew: if Arthur agrees with this, please roll the patch below into the
current IB patch you have as part of the dma attrs series.

Thanks,
  Roland

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index ca5bab0..d2e1429 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -367,6 +367,8 @@ static struct ib_ucontext *mthca_alloc_ucontext(struct ib_device *ibdev,
 		return ERR_PTR(-EFAULT);
 	}
 
+	context->reg_mr_warned = 0;
+
 	return &context->ibucontext;
 }
 
@@ -1013,7 +1015,15 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int err = 0;
 	int write_mtt_size;
 
-	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
+	if (udata->inlen < sizeof ucm) {
+		if (!to_mucontext(pd->uobject->context)->reg_mr_warned) {
+			mthca_warn(dev, "Process %s did not pass in MR attrs\n",
+				   current->comm);
+			mthca_warn(dev, "  Update libmthca to fix this.\n");
+		}
+		++to_mucontext(pd->uobject->context)->reg_mr_warned;
+		ucmd.mr_attrs = 0;
+	} else if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
 		return ERR_PTR(-EFAULT);
 
 	mr = kmalloc(sizeof *mr, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.h b/drivers/infiniband/hw/mthca/mthca_provider.h
index 262616c..934bf95 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.h
+++ b/drivers/infiniband/hw/mthca/mthca_provider.h
@@ -67,6 +67,7 @@ struct mthca_ucontext {
 	struct ib_ucontext          ibucontext;
 	struct mthca_uar            uar;
 	struct mthca_user_db_table *db_tab;
+	int			    reg_mr_warned;
 };
 
 struct mthca_mtt;
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index f8cb3b6..e1262c9 100644
--- a/drivers/infiniband/hw/mthca/mthca_user.h
+++ b/drivers/infiniband/hw/mthca/mthca_user.h
@@ -41,7 +41,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MTHCA_UVERBS_ABI_VERSION	2
+#define MTHCA_UVERBS_ABI_VERSION	1
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -62,10 +62,12 @@ struct mthca_alloc_pd_resp {
 };
 
 struct mthca_reg_mr {
+/*
+ * Mark the memory region with a DMA attribute that causes
+ * in-flight DMA to be flushed when the region is written to:
+ */
+#define MTHCA_MR_DMASYNC	0x1
 	__u32 mr_attrs;
-#define MTHCA_MR_DMASYNC 0x1
-/* mark the memory region with a DMA attribute that causes
- * in-flight DMA to be flushed when the region is written to */
 	__u32 reserved;
 };
 
