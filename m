Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZDOVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZDOVgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZDOVgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:36:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbZDOVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:36:00 -0400
Date: Wed, 15 Apr 2009 14:32:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix a warning on
 drivers/infiniband/hw/nes/nes_cm.c:862:
Message-Id: <20090415143228.d57a0201.akpm@linux-foundation.org>
In-Reply-To: <20090412122317.GA4787@helight>
References: <20090412122317.GA4787@helight>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 20:23:17 +0800
Zhenwen Xu <helight.xu@gmail.com> wrote:

> Fix this warning:
> drivers/infiniband/hw/nes/nes_cm.c:862: warning: unused variable ___tmp_addr___
> 
> the 'tmp_addr' is defined for debug, so it should be defined in
> CONFIG_INFINIBAND_NES_DEBUG
> 
> 
> >From 5f67884bcda5450807dcd080378d829628e4db1c Mon Sep 17 00:00:00 2001
> From: Zhenwen Xu <Helight.Xu@gmail.com>
> Date: Sun, 12 Apr 2009 20:12:18 +0800
> Subject: [PATCH] fix a warning on drivers/infiniband/hw/nes/nes_cm.c:862:
> 
> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  drivers/infiniband/hw/nes/nes_cm.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
> index dbd9a75..1bad93b 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -854,8 +854,9 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
>  {
>  	unsigned long flags;
>  	struct nes_cm_listener *listen_node;
> +#ifdef CONFIG_INFINIBAND_NES_DEBUG
>  	__be32 tmp_addr = cpu_to_be32(dst_addr);
> -
> +#endif
>  	/* walk list and find cm_node associated with this session ID */
>  	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
>  	list_for_each_entry(listen_node, &cm_core->listen_list.list, list) {

eek, an ugly ifdef.  And we can't just remove tmp_addr because
printk(%p) wants to be passed an address rather than a value.

It'd be nice if we had a handy macro to squish the warning, like
uninitialized_var.

As it happens, uninitialized_var() _does_ suppress the unused-var warning:

--- a/drivers/infiniband/hw/nes/nes_cm.c~drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning-cleanup
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -854,9 +854,8 @@ static struct nes_cm_listener *find_list
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
-#ifdef CONFIG_INFINIBAND_NES_DEBUG
-	__be32 tmp_addr = cpu_to_be32(dst_addr);
-#endif
+	__be32 uninitialized_var(tmp_addr) = cpu_to_be32(dst_addr);
+
 	/* walk list and find cm_node associated with this session ID */
 	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
 	list_for_each_entry(listen_node, &cm_core->listen_list.list, list) {


but that seems a bit abusive ;)
