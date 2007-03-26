Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXCZLzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXCZLzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbXCZLzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:55:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45932 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXCZLzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:55:31 -0400
Date: Mon, 26 Mar 2007 14:55:29 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
In-Reply-To: <6791.1174909459@redhat.com>
Message-ID: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI> 
 <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop>
 <6017.1174908318@redhat.com>  <6791.1174909459@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, David Howells wrote:
> I don't know, what does it do?  Remember, once a NOMMU process thinks it has
> the right to access a mapping, there's no way of stopping it doing so short of
> killing the process.

revoke_mapping() is mostly same as munmap(2) except that it preserves the 
vma but makes it VM_REVOKED. This means that if the process tries to 
access the region it will SIGBUS and if it tries to remap the range it 
will get EINVAL.

What we're trying to do here is, we want to make sure no other tasks can 
access the inode once it has been revoked.

On Mon, 26 Mar 2007, David Howells wrote:
> With NOMMU as it stands, private mappings are private copies of the data, and
> have no impact on the page cache and get no updates from it.  It's as if you
> took a private writable mapping, touched every page and then mprotect()'d it.
> This isn't necessarily ideal, but we're limited by the lack on an MMU.

So there's no way to raise SIGBUS if the range is being accessed. The 
alternatives are:

  - No support for revoke(2) on NOMMU.
  - If there are shared mappings, always return -ENOENT for revoke(2).
  - If there are shared mappings, immediately raise SIGBUS for those 
    processes that are accessing it.

Making the shared mappings private is not an option because there's no way 
for the process to know that it's mapping is being pulled under it which 
will result in bugs. Hmm.

				Pekka
