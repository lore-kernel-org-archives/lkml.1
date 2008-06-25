Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYFYWQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYFYWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYFYWQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:16:16 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57804 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYFYWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:16:14 -0400
Message-ID: <4862C3D6.4060100@keyaccess.nl>
Date: Thu, 26 Jun 2008 00:16:54 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNP: have quirk_system_pci_resources() include io resources.
References: <4862873C.3070507@keyaccess.nl> <20080625141621.28639b58.akpm@linux-foundation.org> <4862BCA3.8020005@keyaccess.nl>
In-Reply-To: <4862BCA3.8020005@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------080503050906060609010503"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080503050906060609010503
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 25-06-08 23:46, Rene Herman wrote:

> On 25-06-08 23:16, Andrew Morton wrote:
> 
>> On Wed, 25 Jun 2008 19:58:20 +0200
>> Rene Herman <rene.herman@keyaccess.nl> wrote:
>>
>>> +            unsigned int type;
>>> +
>>> +            type = pci_resource_flags(pdev, i) &
>>> +                    (IORESOURCE_IO | IORESOURCE_MEM);
>>
>> pci_resource_flags() returns an unsigned long.
>>
>> But I think you're right and resource.flags is wrong.  Because there's
>> no way in which we'll ever be able to use bits 32-63 of that field
>> anyway.
>>
>> I suppose that Someone(tm) should convert resource.flags to a u32 or
>> something.  Minor issue.
> 
> Yes, did notice but pnp_get_resource() then takes those same flags as an 
> unsigned int -- had to pick one or the other and "the smallest one" then 
> seemed best...

semi-arguably, the pnp_get_resource() is simply wrong though, so maybe 
this patch. After this, the quirks one should indeed be an unsigned long 
also. Bjorn?

Rene.


--------------080503050906060609010503
Content-Type: text/plain;
 name="0001-PNP-make-the-resource-type-an-unsigned-long.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-make-the-resource-type-an-unsigned-long.patch"

>From c54f1a8a4d82a5b2891c3b15c9935ba5f8ece531 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Thu, 26 Jun 2008 00:14:08 +0200
Subject: [PATCH] PNP: make the resource type an unsigned long

PnP encodes the resource type directly as it's struct resource->flags
value which is an unsigned long. Make it so...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/pnp/base.h     |    2 +-
 drivers/pnp/resource.c |    4 ++--
 include/linux/pnp.h    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index e3fa9a2..45690ff 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -148,7 +148,7 @@ char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_free_resources(struct pnp_dev *dev);
-int pnp_resource_type(struct resource *res);
+unsigned long pnp_resource_type(struct resource *res);
 
 struct pnp_resource {
 	struct list_head list;
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index e0e853d..5d27df1 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -468,14 +468,14 @@ int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 #endif
 }
 
-int pnp_resource_type(struct resource *res)
+unsigned long pnp_resource_type(struct resource *res)
 {
 	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
 			     IORESOURCE_IRQ | IORESOURCE_DMA);
 }
 
 struct resource *pnp_get_resource(struct pnp_dev *dev,
-				  unsigned int type, unsigned int num)
+				  unsigned long type, unsigned int num)
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 116abdc..c2e844c 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -21,7 +21,7 @@ struct pnp_dev;
 /*
  * Resource Management
  */
-struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
+struct resource *pnp_get_resource(struct pnp_dev *, unsigned long, unsigned int);
 
 static inline int pnp_resource_valid(struct resource *res)
 {
-- 
1.5.5


--------------080503050906060609010503--
