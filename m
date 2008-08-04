Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYHDMkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYHDMkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYHDMkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:40:40 -0400
Received: from mail0.lsil.com ([147.145.40.20]:44581 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbYHDMkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:40:39 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: Julia Lawall <julia@diku.dk>, DL-MegaRAID Linux <megaraidlinux@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
CC: "Austria, Winston" <Winston.Austria@lsi.com>,
       "Yuen, Eric" <Eric.Yuen@lsi.com>
Date: Mon, 4 Aug 2008 06:40:27 -0600
Subject: RE: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP
Thread-Topic: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP
Thread-Index: Acj0stKAtOPrg2vZQK+lIcf2si7oEABexN9g
Message-ID: <4B6A08C587958942AA3002690DD4F8C31B0FCFA2@cosmail02.lsi.com>
In-Reply-To: <Pine.LNX.4.64.0808021715270.20095@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia,

Frame_count is the major parameter used by our megaraid sas FW.  It may cause some issues after this change.  Please keep the original implementation.

Thanks.

Bo Yang

-----Original Message-----
From: Julia Lawall [mailto:julia@diku.dk]
Sent: Saturday, August 02, 2008 11:16 AM
To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1615,7 +1615,7 @@ static int megasas_create_frame_pool(str
         * Calculated the number of 64byte frames required for SGL
         */
        sgl_sz = sge_sz * instance->max_num_sge;
-       frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+       frame_count = DIV_ROUND_UP(sgl_sz, MEGAMFI_FRAME_SIZE);

        /*
         * We need one extra frame for the MFI command
