Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYCDMHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYCDMHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYCDMH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:07:26 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:48122 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751295AbYCDMHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:07:25 -0500
Message-ID: <47CD3B7A.2010106@voltaire.com>
Date: Tue, 04 Mar 2008 14:07:22 +0200
From: Erez Zilber <erezz@voltaire.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Arne Redlich <arne.redlich@xiranet.com>
CC: Roland Dreier <rolandd@cisco.com>,
       ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] IB/iSER: fix list iteration bug
References: <877igkxffl.fsf@confield.dd.xiranet.com>
In-Reply-To: <877igkxffl.fsf@confield.dd.xiranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2008 12:07:23.0154 (UTC) FILETIME=[4DD5CF20:01C87DF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arne Redlich wrote:
> The iteration through the list of "iser_device"s during device
> lookup/creation is broken - it might result in an infinite loop if more
> than 1 HCA is used with iSER. Use list_for_each_entry() instead of the
> custom, flawed list iteration code.
> 
> Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
> ---
>  drivers/infiniband/ulp/iser/iser_verbs.c |   36 ++++++++++++-----------------
>  1 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 714b8db..1c0f968 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -237,33 +237,27 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
>  static
>  struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
>  {
> -	struct list_head    *p_list;
> -	struct iser_device  *device = NULL;
> +	struct iser_device *device;
>  
>  	mutex_lock(&ig.device_list_mutex);
>  
> -	p_list = ig.device_list.next;
> -	while (p_list != &ig.device_list) {
> -		device = list_entry(p_list, struct iser_device, ig_list);
> -		/* find if there's a match using the node GUID */
> +	list_for_each_entry(device, &ig.device_list, ig_list)

I've just added the original comments that are missing in your patch.

>  		if (device->ib_device->node_guid == cma_id->device->node_guid)
> -			break;
> -	}
> -
> -	if (device == NULL) {
> -		device = kzalloc(sizeof *device, GFP_KERNEL);
> -		if (device == NULL)
>  			goto out;
> -		/* assign this device to the device */
> -		device->ib_device = cma_id->device;
> -		/* init the device and link it into ig device list */
> -		if (iser_create_device_ib_res(device)) {
> -			kfree(device);
> -			device = NULL;
> -			goto out;
> -		}
> -		list_add(&device->ig_list, &ig.device_list);
> +
> +	device = kzalloc(sizeof *device, GFP_KERNEL);
> +	if (device == NULL)
> +		goto out;
> +
> +	device->ib_device = cma_id->device;
> +	/* init the device and link it into ig device list */
> +	if (iser_create_device_ib_res(device)) {
> +		kfree(device);
> +		device = NULL;
> +		goto out;
>  	}
> +	list_add(&device->ig_list, &ig.device_list);
> +
>  out:
>  	BUG_ON(device == NULL);
>  	device->refcount++;

The iteration through the list of "iser_device"s during device
lookup/creation is broken - it might result in an infinite loop if more
than 1 HCA is used with iSER. Use list_for_each_entry() instead of the
custom, flawed list iteration code.

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
Signed-off-by: Erez Zilber <erezz@voltaire.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   36 +++++++++++++----------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 714b8db..768ba69 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -237,33 +237,29 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn)
 static
 struct iser_device *iser_device_find_by_ib_device(struct rdma_cm_id *cma_id)
 {
-	struct list_head    *p_list;
-	struct iser_device  *device = NULL;
+	struct iser_device *device;
 
 	mutex_lock(&ig.device_list_mutex);
 
-	p_list = ig.device_list.next;
-	while (p_list != &ig.device_list) {
-		device = list_entry(p_list, struct iser_device, ig_list);
+	list_for_each_entry(device, &ig.device_list, ig_list)
 		/* find if there's a match using the node GUID */
 		if (device->ib_device->node_guid == cma_id->device->node_guid)
-			break;
-	}
-
-	if (device == NULL) {
-		device = kzalloc(sizeof *device, GFP_KERNEL);
-		if (device == NULL)
 			goto out;
-		/* assign this device to the device */
-		device->ib_device = cma_id->device;
-		/* init the device and link it into ig device list */
-		if (iser_create_device_ib_res(device)) {
-			kfree(device);
-			device = NULL;
-			goto out;
-		}
-		list_add(&device->ig_list, &ig.device_list);
+
+	device = kzalloc(sizeof *device, GFP_KERNEL);
+	if (device == NULL)
+		goto out;
+
+	/* assign this device to the device */
+	device->ib_device = cma_id->device;
+	/* init the device and link it into ig device list */
+	if (iser_create_device_ib_res(device)) {
+		kfree(device);
+		device = NULL;
+		goto out;
 	}
+	list_add(&device->ig_list, &ig.device_list);
+
 out:
 	BUG_ON(device == NULL);
 	device->refcount++;
-- 
1.5.3.6


I agree with your patch. It seems that we forgot to add something like p_list=p_list->next. Anyway, using list_for_each_entry is better than what we had.

