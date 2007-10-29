Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXJ2Wgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXJ2Wgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXJ2Wg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:36:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54320
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbXJ2WgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:36:25 -0400
Date: Mon, 29 Oct 2007 15:36:27 -0700 (PDT)
Message-Id: <20071029.153627.04824774.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [bug, 2.6.24-rc1] sysfs: duplicate filename 'eth0' can not be
 created
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071029211746.GA19876@elte.hu>
References: <20071029211746.GA19876@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 29 Oct 2007 22:17:46 +0100

> 
> hm, this seems to have popped up in the last few days, never had it 
> before:
> 
>   sysfs: duplicate filename 'eth0' can not be created
>   WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

I checked in a change from Stephen Hemminger last week which
should keep this case from emitting warning messages.

commit c8d90dca3211966ba5189e0f3d4bccd558d9ae08
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Fri Oct 26 03:53:42 2007 -0700

    [NET] dev_change_name: ignore changes to same name
    
    Prevent error/backtrace from dev_rename() when changing
    name of network device to the same name. This is a common
    situation with udev and other scripts that bind addr to device.
    
    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/dev.c b/net/core/dev.c
index f1647d7..ddfef3b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -883,6 +883,9 @@ int dev_change_name(struct net_device *dev, char *newname)
 	if (!dev_valid_name(newname))
 		return -EINVAL;
 
+	if (strncmp(newname, dev->name, IFNAMSIZ) == 0)
+		return 0;
+
 	memcpy(oldname, dev->name, IFNAMSIZ);
 
 	if (strchr(newname, '%')) {
