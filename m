Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab0CANAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:00:09 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:35428 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0CANAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:00:07 -0500
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Jaroslav Kysela <perex@perex.cz>
Subject: BUG mutex_unlock without mutex_lock in drivers/pnp/isapnp/core.c
Date: Mon, 1 Mar 2010 15:59:40 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003011559.40139.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.33
	SUBJECT: mutex_unlock without mutex_lock
	DESCRIBE:
	In drivers/pnp/isapnp/core.c in function isapnp_get_resources:

 1. In line 906 we call isapnp_cfg_begin(dev->card->number, dev->number);

 900 static int isapnp_get_resources(struct pnp_dev *dev)
 901 {
 902         int i, ret;
 903
 904         pnp_dbg(&dev->dev, "get resources\n");
 905         pnp_init_resources(dev);
 906         isapnp_cfg_begin(dev->card->number, dev->number);
...

2. If csn<1 or csn > isapnp_csn_count or logdev > 10 then function returns -
EINVAL and does not call mutex_lock.

 856 int isapnp_cfg_begin(int csn, int logdev)
 857 {
 858         if (csn < 1 || csn > isapnp_csn_count || logdev > 10)
 859                 return -EINVAL;
 860         mutex_lock(&isapnp_cfg_mutex);
...

3. Suppose function isapnp_read_bytes returned a null value. In this case we 
goto line 932 and call isapnp_cfg_end.

 907         dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 908         if (!dev->active)
 909                 goto __end;
...
 932 __end:
 933         isapnp_cfg_end();
 934         return 0;
 935 }

4. isapnp_cfg_end in line  886 calls mutex_unlock on &isapnp_cfg_mutex without 
mutex_lock (it was not locked in function isapnp_cfg_begin because of -
EINVAL).

 883 int isapnp_cfg_end(void)
 884 {
 885         isapnp_wait();
 886         mutex_unlock(&isapnp_cfg_mutex);
 887         return 0;
 888 }

Found by Linux Device Drivers Verification Project
