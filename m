Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbXBZBRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbXBZBRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 20:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933719AbXBZBRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 20:17:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbXBZBRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 20:17:12 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 20:17:40 -0500
Message-Id: <1172452660.3971.33.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 16:24 -0800, Linus Torvalds wrote:
> Hmm. No, I don't think that should be a problem. free_initmem() only 
> happens at the very, after do_basic_setup() has been run, which
> includes all the initcall stuff.

I'm inclined to agree that it _shouldn't_ be a problem. Nevertheless,
even this hack seems sufficient to 'fix' it:

--- arch/powerpc/mm/init_32.c   2007-02-25 20:06:54.000000000 -0500
+++ arch/powerpc/mm/init_32.c.not       2007-02-25 20:06:41.000000000 -0500
@@ -243,13 +243,14 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
        if (start < end)
-               printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+               printk ("NOT Freeing initrd memory: %ldKiB would be freed\n", (end - start) >> 10);
+       return;
        for (; start < end; start += PAGE_SIZE) {
                ClearPageReserved(virt_to_page(start));
                init_page_count(virt_to_page(start));
                free_page(start);
                totalram_pages++;
        }
 }
 #endif


-- 
dwmw2

