Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYCXIFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYCXIFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYCXIFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:05:35 -0400
Received: from ozlabs.org ([203.10.76.45]:43061 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYCXIFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:05:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18407.24752.933757.928245@cargo.ozlabs.ibm.com>
Date: Mon, 24 Mar 2008 19:05:04 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get a few more bug-fixes for powerpc that should go in 2.6.25.

Thanks,
Paul.

 arch/powerpc/mm/hash_utils_64.c         |   11 ++++++++---
 arch/powerpc/sysdev/bestcomm/bestcomm.c |    8 ++++++--
 arch/powerpc/sysdev/ipic.c              |    2 +-
 drivers/net/fec_mpc52xx_phy.c           |    3 ++-
 4 files changed, 17 insertions(+), 7 deletions(-)

commit 7ea6fd7e2df041297298b5feb5b7b78a2b1a5310
Author: Anatolij Gustschin <agust@denx.de>
Date:   Sat Mar 22 21:49:05 2008 +1100

    [POWERPC] Fix Oops with TQM5200 on TQM5200
    
    The "bestcomm-core" driver defines its of_match table as follows
    
    static struct of_device_id mpc52xx_bcom_of_match[] = {
    	{ .type = "dma-controller", .compatible = "fsl,mpc5200-bestcomm", },
    	{ .type = "dma-controller", .compatible = "mpc5200-bestcomm", },
    	{},
    };
    
    so while registering the driver, the driver's probe function won't be
    called, because the device tree node doesn't have a device_type
    property.  Thus the driver's bcom_engine structure won't be allocated.
    Referencing this structure later causes observed Oops.
    
    Checking bcom_eng pointer for NULL before referencing data pointed
    by it prevents oopsing, but fec driver still doesn't work (because
    of the lost bestcomm match and resulted task allocation failure).
    Actually the compatible property exists and should match and so
    the fec driver should work.
    
    This removes .type = "dma-controller" from the bestcomm driver's
    mpc52xx_bcom_of_match table to solve the problem.
    
    Signed-off-by: Anatolij Gustschin <agust@denx.de>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 9560aea4e9d17cb75113c6051e800222fd5c71a4
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Sat Mar 22 14:41:05 2008 +1100

    [POWERPC] mpc5200: Fix null dereference if bestcomm fails to initialize
    
    If the bestcomm initialization fails, calls to the task allocate
    function should fail gracefully instead of oopsing with a NULL deref.
    
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit b8c19eb16a7e6df57d0f6d67e42ce026e5d5930b
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Sat Mar 22 14:20:29 2008 +1100

    [POWERPC] mpc5200-fec: Fix possible NULL dereference in mdio driver
    
    If the reg property is missing from the phy node (unlikely, but possible),
    then the kernel will oops with a NULL pointer dereference.  This fixes
    it by checking the pointer first.
    
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 1428a9fa586cb80acf98289f797f58b8bd662598
Author: Olaf Hering <olaf@aepfle.de>
Date:   Tue Mar 18 06:53:05 2008 +1100

    [POWERPC] Fix crash in init_ipic_sysfs on efika
    
    The global primary_ipic in arch/powerpc/sysdev/ipic.c can remain NULL
    if ipic_init() fails, which will happen on machines that don't have an
    ipic interrupt controller.  init_ipic_sysfs() will crash in that case.
    
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit cfe666b145cecffe784d98e60ffe201a5dc57ac3
Author: Paul Mackerras <paulus@samba.org>
Date:   Mon Mar 24 17:41:22 2008 +1100

    [POWERPC] Don't use 64k pages for ioremap on pSeries
    
    On pSeries, the hypervisor doesn't let us map in the eHEA ethernet
    adapter using 64k pages, and thus the ehea driver will fail if 64k
    pages are configured.  This works around the problem by always
    using 4k pages for ioremap on pSeries (but not on other platforms).
    A better fix would be to check whether the partition could ever
    have an eHEA adapter, and only force 4k pages if it could, but this
    will do for 2.6.25.
    
    This is based on an earlier patch by Tony Breeds.
    
    Signed-off-by: Paul Mackerras <paulus@samba.org>
