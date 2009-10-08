Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZJHLP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZJHLP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbZJHLP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:15:57 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:48885 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbZJHLP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:15:57 -0400
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Pierre Ossman <pierre@ossman.eu>, sdhci-devel@lists.ossman.eu,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] wbsd.c: after spin_lock_bh uses spin_unlock instead spin_unlock_bh
Date: Thu, 8 Oct 2009 15:18:00 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081518.00707.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
Driver ./drivers/mmc/host/wbsd.c calls spin_lock_bh and then spin_unlock 
instead of spin_unlock_bh:

 753 static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
...
 761         spin_lock_bh(&host->lock);
...
 844 done:
 845         wbsd_request_end(host, mrq);
 846
 847         spin_unlock_bh(&host->lock);
 848 }

But in wsdb_request calls spin_unlock/spin_lock instead of 
spin_unlock_bh/spin_lock_bh;

 206 static void wbsd_request_end(struct wbsd_host *host, struct mmc_request 
...
 230         spin_unlock(&host->lock);
 231         mmc_request_done(host->mmc, mrq);
 232         spin_lock(&host->lock);
 233 }

Found by : Linux Driver Verification
