Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0AZWDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0AZWDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902Ab0AZWDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:03:35 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12942 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0AZWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:03:34 -0500
Date: Tue, 26 Jan 2010 15:03:33 -0700
From: Alex Chiang <achiang@hp.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
Message-ID: <20100126220333.GB12035@ldl.fc.hp.com>
References: <20100125235013.GD2828@grease.ALLEYCAT> <adaiqapplv7.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaiqapplv7.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier <rdreier@cisco.com>:
> 
>  > If that enum is indeed the limiting factor, would someone
>  > mind explaining (or pointing me at TFM ;) why it's limited
>  > to 32 devices?
> 
> That dates back to when device #s had 8 bits for major and 8
> bits for minor.  We got one major assigned for IB, and had to
> split up the 256 minors that gave us among userspace verbs,
> management access, etc.  And 32 seemed like a pretty reasonable
> limit for most uses.

Hm...

        IB_UMAD_MAX_PORTS  = 64,
        IB_UMAD_MAJOR      = 231,
        IB_UMAD_MINOR_BASE = 0
	register_chrdev_region(base_dev, IB_UMAD_MAX_PORTS * 2, "infiniband_mad");

        IB_UVERBS_MAJOR       = 231,
        IB_UVERBS_BASE_MINOR  = 192,
        IB_UVERBS_MAX_DEVICES = 32
	register_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES, "infiniband_verbs");

        IB_UCM_MAJOR = 231,
        IB_UCM_BASE_MINOR = 224,
        IB_UCM_MAX_DEVICES = 32
	register_chrdev_region(IB_UCM_BASE_DEV, IB_UCM_MAX_DEVICES, "infiniband_cm");

It looks like we have a hole from [128, 192).

Would it be something as simple as this?

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uve
index 5f284ff..b9aa2b8 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -57,8 +57,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 enum {
        IB_UVERBS_MAJOR       = 231,
-       IB_UVERBS_BASE_MINOR  = 192,
-       IB_UVERBS_MAX_DEVICES = 32
+       IB_UVERBS_BASE_MINOR  = 128,
+       IB_UVERBS_MAX_DEVICES = 64
 };
 
 #define IB_UVERBS_BASE_DEV     MKDEV(IB_UVERBS_MAJOR, IB_UVERBS_BASE_MINOR)

