Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbXFMKth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbXFMKth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXFMKta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:49:30 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:27715 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbXFMKt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:49:29 -0400
Date: Wed, 13 Jun 2007 17:50:07 +0400
From: Dmitriy Monakhov <dmonakhov@sw.ru>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de
Subject: [patch] new aop block_write_begin fix
Message-ID: <20070613135007.GC13815@localhost.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org, npiggin@suse.de
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613134005.GA13815@localhost.sw.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	After we enter to block_write_begin with *pagep == NULL and
 	some page was grabed we remember this page in *pagep
 	And if __block_prepare_write() we have to clear *pagep , as 
 	it was before. Because this may confuse caller.
 	for example caller may have folowing code:
 		ret = block_write_begin(..., pagep,...)
 		if (ret && *pagep != NULL) {
 			unlock_page(*pagep);
 			page_cache_release(*pagep);
 		}
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>

diff --git a/fs/buffer.c b/fs/buffer.c
index 07cd457..df933ba 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1982,6 +1982,7 @@ int block_write_begin(struct file *file, struct address_space *mapping,
 		if (ownpage) {
 			unlock_page(page);
 			page_cache_release(page);
+			*pagep = NULL;
 
 			/*
 			 * prepare_write() may have instantiated a few blocks 

