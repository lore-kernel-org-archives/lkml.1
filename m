Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbYAQUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbYAQUql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYAQUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:46:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:36704 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbYAQUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=dGvuLds0l+b/31Dec6kwLHkdLS+V1E69zfOh9cCF2pK5DLUQmI9XcS4Ei27o8wmsA1FelhvZCvdC26cH+WgcxrdQOfEtA1vU1dR/qXOgaqs+Sq+zvRjxtdKEVRMDN5Md22MGjaPVvvTiB/dKRrPH0Sf7E5t0DPyqO2t0r7K6osI=
Message-ID: <478FBEA0.9090203@gmail.com>
Date: Thu, 17 Jan 2008 21:46:24 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] Make RCU lists use the RCU API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After reading the nice article contributed by Paul on LWN, I took a look
to the kernel RCU-protected list implementation to get a good idea on
how RCU protection mechanism can be used.

And it appears that the implementation doesn't use the RCU API as much
as it could: every updates of "->next" field could have been done by
using rcu_assign_pointer(), the main point being readability.

So this patchset does that. However when cooking the patch, I noticed
that it's hard to import RCU API without creating some circular
dependencies. This is mainly explained by the fact that list.h defines a
couple of very primitive types used all over the kernel.

The easiest thing I could come up with is to create a new header file
rculist.h, which keeps all RCU-protected list definitions. list.h still
keeps the basic list stuffs and still has very few dependencies. OTOH
RCU-protected list is a more complex type of list and can have more
dependencies. Therefore it needs more careful in including it.

I don't know if any header dependency rules exist for the kernel, so
please any suggestions are welcome to deal with such issue.

"make allyesconfig" builds and boots fine on x86 architecture, this
patchset being applied on top of Linus' v2.6.24-rc7 tag.

Please consider,

		Franck

--

 arch/ia64/sn/kernel/irq.c                       |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    3 +-
 include/linux/dcache.h                          |    1 +
 include/linux/list.h                            |  385 ----------------------
 include/linux/rculist.h                         |  391 +++++++++++++++++++++++
 lib/textsearch.c                                |    2 +-
 6 files changed, 395 insertions(+), 388 deletions(-)
