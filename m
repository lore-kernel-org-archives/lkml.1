Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYKXWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYKXWOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKXWO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:14:29 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57090 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYKXWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:14:28 -0500
Date: Mon, 24 Nov 2008 17:13:57 -0500 (EST)
From: Tim Abbott <tabbott@MIT.EDU>
To: Christoph Hellwig <hch@infradead.org>
cc: Jeff Arnold <jbarnold@MIT.EDU>, linux-kernel@vger.kernel.org,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [RFC v3 PATCH 6/7] Ksplice: Export symbols needed for Ksplice
In-Reply-To: <20081122063407.GA13931@infradead.org>
Message-ID: <alpine.DEB.2.00.0811241624330.17720@vinegar-pot.mit.edu>
References: <1227324961-13273-1-git-send-email-jbarnold@mit.edu> <1227324961-13273-2-git-send-email-jbarnold@mit.edu> <1227324961-13273-3-git-send-email-jbarnold@mit.edu> <1227324961-13273-4-git-send-email-jbarnold@mit.edu> <1227324961-13273-5-git-send-email-jbarnold@mit.edu>
 <1227324961-13273-6-git-send-email-jbarnold@mit.edu> <1227324961-13273-7-git-send-email-jbarnold@mit.edu> <20081122063407.GA13931@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008, Christoph Hellwig wrote:

> On Fri, Nov 21, 2008 at 10:36:00PM -0500, Jeff Arnold wrote:
>> Ksplice uses init_mm to get access to the ranges of addresses
>> containing core kernel text and data.  It seems that init_mm was
>> scheduled to be unexported entirely in 2.6.26, so move it to
>> EXPORT_SYMBOL_GPL (rather than back to EXPORT_SYMBOL).
>
> Umm, no.  This is a very clear indicator that your code shouldn't be
> modular.

Well, it's easy to eliminate the use of init_mm in Ksplice by using a 
slightly different check for whether to use virt_to_page or 
vmalloc_to_page.  Here is a patch:

Remove use of init_mm from Ksplice

Since the input to map_writable is guaranteed to be a core kernel
address or a module address, we can use __module_text_address and
__module_data_address to determine whether the address is in the core
kernel or a module, and thus whether to use virt_to_page or
vmalloc_to_page.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 kernel/ksplice.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/ksplice.c b/kernel/ksplice.c
index 8a05123..d12a6db 100644
--- a/kernel/ksplice.c
+++ b/kernel/ksplice.c
@@ -949,11 +949,10 @@ static void *map_writable(void *addr, size_t len)
 {
 	void *vaddr;
 	int nr_pages = 2;
-	unsigned long laddr = (unsigned long)addr;
 	struct page *pages[2];

-	if ((laddr >= init_mm.start_code && laddr < init_mm.end_code) ||
-	    (laddr >= init_mm.start_data && laddr < init_mm.end_data)) {
+	if (__module_text_address((unsigned long)addr) == NULL &&
+	    __module_data_address((unsigned long)addr) == NULL) {
 		pages[0] = virt_to_page(addr);
 		WARN_ON(!PageReserved(pages[0]));
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
-- 
1.5.6.5

