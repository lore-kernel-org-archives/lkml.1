Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbYEGUe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbYEGUe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYEGUep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:34:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60139 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYEGUen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:34:43 -0400
To: trond.myklebust@fys.uio.no, npiggin@suse.de
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: NFS infinite loop in filemap_fault()
Message-Id: <E1JtqLW-0005j5-KU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 May 2008 22:34:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page fault on NFS apparently goes into an infinite loop if the read on
the server fails.

I don't understand the NFS readpage code, but the filemap_fault() code
looks somewhat suspicious:

	/*
	 * Umm, take care of errors if the page isn't up-to-date.
	 * Try to re-read it _once_. We do this synchronously,
	 * because there really aren't any performance issues here
	 * and we need to check for errors.
	 */
	ClearPageError(page);
	error = mapping->a_ops->readpage(file, page);
	page_cache_release(page);

	if (!error || error == AOP_TRUNCATED_PAGE)
		goto retry_find;

The comment doesn't seem to match what the it actually does: if
->readpage() is asynchronous, then this will just repeat everything,
without any guarantee that it will re-read once.

What am I missing?

Miklos
