Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbYFLN4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbYFLN4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760868AbYFLNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:55:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760554AbYFLNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:55:50 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Rik van Riel <riel@redhat.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080612093833.0fb9cdd6@bree.surriel.com> (sfid-20080612_154046_320899_AF22CEFB)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 (sfid-20080612_154046_320899_AF22CEFB)
Content-Type: text/plain
Date: Thu, 12 Jun 2008 15:54:44 +0200
Message-Id: <1213278884.3936.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 09:38 -0400, Rik van Riel wrote:
> On Thu, 12 Jun 2008 12:07:34 +0200
> "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
> 
> > It looks like while there was a huge amount of buffers and caches -
> > system was unable to allocate few pages for kmalloc in iwl3945 driver
> > after resume.
> 
> It looks like this is because it wants to allocate 2**5 contiguous
> pages, which is 128kB of contiguous kernel memory.

64-bit system I assume?
The allocation should be 256 * 20 * sizeof(struct sk_buff *).

Try the patch below. It should improve code generation too.

I discussed this with Tomas previously and he says the hw is capable of
doing 20 fragments per frame (wonder why, Broadcom can do an unlimited
number...) but he complained about the networking stack not being able
to. Well, the hardware needs to support IP checksumming for that, hence,
afaik, only two fragments can ever be used (one for hw header, one for
frame)

This cuts the allocation to 10%, or (under) a page in all cases.

johannes

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-06-12 15:50:29.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-06-12 15:50:31.000000000 +0200
@@ -120,7 +120,7 @@ struct iwl3945_queue {
 int iwl3945_queue_space(const struct iwl3945_queue *q);
 int iwl3945_x2_queue_used(const struct iwl3945_queue *q, int i);
 
-#define MAX_NUM_OF_TBS          (20)
+#define MAX_NUM_OF_TBS          (2)
 
 /* One for each TFD */
 struct iwl3945_tx_info {
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-06-12 15:50:18.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-06-12 15:50:24.000000000 +0200
@@ -115,7 +115,7 @@ struct iwl_queue {
 				* space less than this */
 } __attribute__ ((packed));
 
-#define MAX_NUM_OF_TBS          (20)
+#define MAX_NUM_OF_TBS          (2)
 
 /* One for each TFD */
 struct iwl_tx_info {


