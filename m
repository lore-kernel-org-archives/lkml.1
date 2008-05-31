Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYEaJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYEaJva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 05:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYEaJvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 05:51:21 -0400
Received: from gw.goop.org ([64.81.55.164]:57435 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbYEaJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 05:51:20 -0400
Message-ID: <48411F70.5020100@goop.org>
Date: Sat, 31 May 2008 10:50:40 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on
 the	resume path
References: <c692f3a12da1e99a4a43.1212192095@localhost> <4840B0C5.4020606@pobox.com>
In-Reply-To: <4840B0C5.4020606@pobox.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeremy Fitzhardinge wrote:
>> From: Ian Campbell <ian.campbell@citrix.com>
>>
>> Avoid allocations causing swap activity on the resume path by allowing
>> such allocations to access the emergency pools otherwise a
>> save/restore/migration of a guest which is low on memory can
>> deadlock.
>>
>> [ linux-2.6.18-xen changesets e8b49cfbdac, fdb998e79aba ]
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> ---
>>  drivers/block/xen-blkfront.c       |    5 +++--
>>  drivers/net/xen-netfront.c         |    4 ++--
>>  drivers/xen/xenbus/xenbus_client.c |    2 +-
>>  drivers/xen/xenbus/xenbus_xs.c     |   10 +++++-----
>>  4 files changed, 11 insertions(+), 10 deletions(-)
>
> IMO I am not qualified enough to ACK or NAK this VM-related patch...

Yeah, I'm not quite sure about which GFP_ flags to use in what 
circumstance.  In this case the potential for deadlock exists because 
this is the code which is reconnecting the virtual devices after a 
resume, which will probably include its storage (either block device, or 
some kind of network storage).  Should GFP_NOFS also be in there?  
Something else?  Does __GFP_HIGH necessarily mean that it won't try to 
do IO to push pages out?

Thanks,
    J


Patch again for reference:

Subject: xen: Avoid allocations causing swap activity on the resume path

From: Ian Campbell <ian.campbell@citrix.com>

Avoid allocations causing swap activity on the resume path by allowing
such allocations to access the emergency pools otherwise a
save/restore/migration of a guest which is low on memory can
deadlock.

[ linux-2.6.18-xen changesets e8b49cfbdac, fdb998e79aba ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 drivers/block/xen-blkfront.c       |    5 +++--
 drivers/net/xen-netfront.c         |    4 ++--
 drivers/xen/xenbus/xenbus_client.c |    2 +-
 drivers/xen/xenbus/xenbus_xs.c     |   10 +++++-----
 4 files changed, 11 insertions(+), 10 deletions(-)

===================================================================
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -584,7 +584,7 @@
 
 	info->ring_ref = GRANT_INVALID_REF;
 
-	sring = (struct blkif_sring *)__get_free_page(GFP_KERNEL);
+	sring = (struct blkif_sring *)__get_free_page(GFP_KERNEL | __GFP_HIGH);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -741,7 +741,8 @@
 	int j;
 
 	/* Stage 1: Make a safe copy of the shadow state. */
-	copy = kmalloc(sizeof(info->shadow), GFP_KERNEL);
+	copy = kmalloc(sizeof(info->shadow),
+		       GFP_KERNEL | __GFP_NOFAIL | __GFP_HIGH);
 	if (!copy)
 		return -ENOMEM;
 	memcpy(copy, info->shadow, sizeof(info->shadow));
===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1324,7 +1324,7 @@
 		goto fail;
 	}
 
-	txs = (struct xen_netif_tx_sring *)get_zeroed_page(GFP_KERNEL);
+	txs = (struct xen_netif_tx_sring *)get_zeroed_page(GFP_KERNEL | __GFP_HIGH);
 	if (!txs) {
 		err = -ENOMEM;
 		xenbus_dev_fatal(dev, err, "allocating tx ring page");
@@ -1340,7 +1340,7 @@
 	}
 
 	info->tx_ring_ref = err;
-	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_KERNEL);
+	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_KERNEL | __GFP_HIGH);
 	if (!rxs) {
 		err = -ENOMEM;
 		xenbus_dev_fatal(dev, err, "allocating rx ring page");
===================================================================
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -117,7 +117,7 @@
 	char *path;
 
 	va_start(ap, pathfmt);
-	path = kvasprintf(GFP_KERNEL, pathfmt, ap);
+	path = kvasprintf(GFP_KERNEL | __GFP_HIGH, pathfmt, ap);
 	va_end(ap);
 
 	if (!path) {
===================================================================
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -283,9 +283,9 @@
 	char *buffer;
 
 	if (strlen(name) == 0)
-		buffer = kasprintf(GFP_KERNEL, "%s", dir);
+		buffer = kasprintf(GFP_KERNEL | __GFP_HIGH, "%s", dir);
 	else
-		buffer = kasprintf(GFP_KERNEL, "%s/%s", dir, name);
+		buffer = kasprintf(GFP_KERNEL | __GFP_HIGH, "%s/%s", dir, name);
 	return (!buffer) ? ERR_PTR(-ENOMEM) : buffer;
 }
 
@@ -297,7 +297,7 @@
 	*num = count_strings(strings, len);
 
 	/* Transfer to one big alloc for easy freeing. */
-	ret = kmalloc(*num * sizeof(char *) + len, GFP_KERNEL);
+	ret = kmalloc(*num * sizeof(char *) + len, GFP_KERNEL | __GFP_HIGH);
 	if (!ret) {
 		kfree(strings);
 		return ERR_PTR(-ENOMEM);
@@ -751,7 +751,7 @@
 	}
 
 
-	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg = kmalloc(sizeof(*msg), GFP_KERNEL | __GFP_HIGH);
 	if (msg == NULL) {
 		err = -ENOMEM;
 		goto out;
@@ -763,7 +763,7 @@
 		goto out;
 	}
 
-	body = kmalloc(msg->hdr.len + 1, GFP_KERNEL);
+	body = kmalloc(msg->hdr.len + 1, GFP_KERNEL | __GFP_HIGH);
 	if (body == NULL) {
 		kfree(msg);
 		err = -ENOMEM;



