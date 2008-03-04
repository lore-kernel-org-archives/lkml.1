Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbYCDMMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbYCDMMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYCDML7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:11:59 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:51110 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbYCDML6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:11:58 -0500
Message-ID: <47CD3C8A.20405@voltaire.com>
Date: Tue, 04 Mar 2008 14:11:54 +0200
From: Erez Zilber <erezz@voltaire.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Arne Redlich <arne.redlich@xiranet.com>
CC: Roland Dreier <rolandd@cisco.com>,
       ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] IB/iSER: handle iser_device allocation error gracefully
References: <87zltgw0ut.fsf@confield.dd.xiranet.com>
In-Reply-To: <87zltgw0ut.fsf@confield.dd.xiranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2008 12:11:54.0982 (UTC) FILETIME=[EFDB7860:01C87DF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arne Redlich wrote:
> "iser_device" allocation failure is "handled" with a BUG_ON() right
> before dereferencing the NULL-pointer - fix this!
> 

I agree with this patch. I'm resending it because it depends on the 1st patch that has changed, so the 2nd patch can be applied over the new 1st patch. 

> Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
> ---
>  drivers/infiniband/ulp/iser/iser_verbs.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 1c0f968..cf70d15 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -243,7 +243,7 @@ struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
>  
>  	list_for_each_entry(device, &ig.device_list, ig_list)
>  		if (device->ib_device->node_guid == cma_id->device->node_guid)
> -			goto out;
> +			goto inc_refcnt;
>  
>  	device = kzalloc(sizeof *device, GFP_KERNEL);
>  	if (device == NULL)
> @@ -258,9 +258,9 @@ struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
>  	}
>  	list_add(&device->ig_list, &ig.device_list);
>  
> -out:
> -	BUG_ON(device == NULL);
> +inc_refcnt:
>  	device->refcount++;
> +out:
>  	mutex_unlock(&ig.device_list_mutex);
>  	return device;
>  }
> @@ -366,6 +366,12 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
>  	int    ret;
>  
>  	device = iser_device_find_by_ib_device(cma_id);
> +	if (!device) {
> +		iser_err("device lookup/creation failed\n");
> +		iser_connect_error(cma_id);
> +		return;
> +	}
> +
>  	ib_conn = (struct iser_conn *)cma_id->context;
>  	ib_conn->device = device;
>  
> @@ -374,7 +380,6 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
>  		iser_err("resolve route failed: %d\n", ret);
>  		iser_connect_error(cma_id);
>  	}
> -	return;
>  }
>  
>  static void iser_route_handler(struct rdma_cm_id *cma_id)


iser_device" allocation failure is "handled" with a BUG_ON() right
before dereferencing the NULL-pointer - fix this!

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
Signed-off-by: Erez Zilber <erezz@voltaire.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 768ba69..993f0a8 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -244,7 +244,7 @@ struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 	list_for_each_entry(device, &ig.device_list, ig_list)
 		/* find if there's a match using the node GUID */
 		if (device->ib_device->node_guid == cma_id->device->node_guid)
-			goto out;
+			goto inc_refcnt;
 
 	device = kzalloc(sizeof *device, GFP_KERNEL);
 	if (device == NULL)
@@ -260,9 +260,9 @@ struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 	}
 	list_add(&device->ig_list, &ig.device_list);
 
-out:
-	BUG_ON(device == NULL);
+inc_refcnt:
 	device->refcount++;
+out:
 	mutex_unlock(&ig.device_list_mutex);
 	return device;
 }
@@ -368,6 +368,12 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 	int    ret;
 
 	device = iser_device_find_by_ib_device(cma_id);
+	if (!device) {
+		iser_err("device lookup/creation failed\n");
+		iser_connect_error(cma_id);
+		return;
+	}
+
 	ib_conn = (struct iser_conn *)cma_id->context;
 	ib_conn->device = device;
 
@@ -376,7 +382,6 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 		iser_err("resolve route failed: %d\n", ret);
 		iser_connect_error(cma_id);
 	}
-	return;
 }
 
 static void iser_route_handler(struct rdma_cm_id *cma_id)
-- 
1.5.3.6


