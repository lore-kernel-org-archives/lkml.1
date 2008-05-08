Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYEHGr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYEHGr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbYEHGrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:47:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43771 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbYEHGrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:47:16 -0400
To: trond.myklebust@fys.uio.no, npiggin@suse.de
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <E1JtqLW-0005j5-KU@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 07 May 2008 22:34:38 +0200)
Subject: Re: NFS infinite loop in filemap_fault()
References: <E1JtqLW-0005j5-KU@pomaz-ex.szeredi.hu>
Message-Id: <E1JtzuH-0006nY-AM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 May 2008 08:47:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Page fault on NFS apparently goes into an infinite loop if the read on
> the server fails.
> 
> I don't understand the NFS readpage code, but the filemap_fault() code
> looks somewhat suspicious:
> 
> 	/*
> 	 * Umm, take care of errors if the page isn't up-to-date.
> 	 * Try to re-read it _once_. We do this synchronously,
> 	 * because there really aren't any performance issues here
> 	 * and we need to check for errors.
> 	 */
> 	ClearPageError(page);
> 	error = mapping->a_ops->readpage(file, page);
> 	page_cache_release(page);
> 
> 	if (!error || error == AOP_TRUNCATED_PAGE)
> 		goto retry_find;
> 
> The comment doesn't seem to match what the it actually does: if
> ->readpage() is asynchronous, then this will just repeat everything,
> without any guarantee that it will re-read once.

This patch fixes it.  It's probably wrong in some subtle way though...

Miklos


---
 mm/filemap.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux.git/mm/filemap.c
===================================================================
--- linux.git.orig/mm/filemap.c	2008-05-08 08:17:22.000000000 +0200
+++ linux.git/mm/filemap.c	2008-05-08 08:19:59.000000000 +0200
@@ -1461,6 +1461,12 @@ page_not_uptodate:
 	 */
 	ClearPageError(page);
 	error = mapping->a_ops->readpage(file, page);
+	if (!error && !PageUptodate(page)) {
+		lock_page(page);
+		if (!PageUptodate(page))
+			error = -EIO;
+		unlock_page(page);
+	}
 	page_cache_release(page);
 
 	if (!error || error == AOP_TRUNCATED_PAGE)

