Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZCSPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZCSPRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZCSPRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:17:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:56706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZCSPRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:17:23 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <8036.1237474444@jrobl>
References: <8036.1237474444@jrobl>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 15:17:17 +0000
Message-Id: <1237475837.16359.106.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 14:54 +0000, hooanon05@yahoo.co.jp wrote:
> 
> Hello David and Al,
> I have a question about NFSD readdir.
> 
> By the commit 14f7dd632011bb89c035722edd6ea0d90ca6b078
> "[PATCH] Copy XFS readdir hack into nfsd code", nfsd_buffered_filldir()
> was introduced and nfs3svc_encode_entry_plus() (the 'func' parameter) is
> not called from vfs_readdir().
> 
> In 2.6.27, when nfs3svc_encode_entry_plus() calls lookup_one_len(), the
> i_mutex lock was acquired by vfs_readdir() and it was not a problem.
> 
> After the commit (above), nfsd_readdir/nfsd_buffered_readdir/vfs_readdir
> calls nfsd_buffered_filldir(), and nfs3svc_encode_entry_plus() is called
> later.
> In this sequence, lookup_one_len() is called without i_mutex held.
> 
> Isn't it a problem?

Yes, well spotted. It didn't matter when the buffered readdir() was
purely internal to XFS, because it didn't matter there that we called
->lookup() without i_mutex set. But now we're exposing arbitrary file
systems to it, we need to make sure we follow the locking rules. 

I _think_ it's sufficient to make the affected callers of
lookup_one_len() lock the parent's i_mutex for themselves before calling
it. I'll take a closer look...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

