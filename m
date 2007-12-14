Return-Path: <linux-kernel-owner+w=401wt.eu-S1765982AbXLNEVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765982AbXLNEVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761693AbXLNEVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:21:33 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35694 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761335AbXLNEVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:21:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kBtRdnE/lFmEsX1XWlkMPttYjS5TAaiTQEDFJgslxYpCwCVMorHR5AAxGSn3Ahut8l4evCQ1cEc1wRkL8Z8iJ5dlZCg67ZTbmHS9f1fbSba5qjmJghv7jbtW3FaDdznbxmhCZSqBZfgO2ZSLgt6xrZY4MnEZoUtiyFRy4LXBM0A=  ;
X-YMail-OSG: 4VzOFRQVM1lAtW.2HJv8RmAjdgfcxexcba15y6OaMMwjAtph8OJzzVIhy0horvGx0tR68pby_Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/28] AFS: Add a function to excise a rejected write from the pagecache [try #2]
Date: Fri, 14 Dec 2007 15:21:23 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205194020.24617.28880.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205194020.24617.28880.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141521.24227.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 06:40, David Howells wrote:
> Add a function - cancel_rejected_write() - to excise a rejected write from
> the pagecache.  This function is related to the truncation family of
> routines.  It permits the pages modified by a network filesystem client
> (such as AFS) to be excised and discarded from the pagecache if the attempt
> to write them back to the server fails.
>
> The dirty and writeback states of the afflicted pages are cancelled and the
> pages themselves are detached for recycling.  All PTEs referring to those
> pages are removed.
>
> Note that the locking is tricky as it's very easy to deadlock against
> truncate() and other routines once the pages have been unlocked as part of
> the writeback process.  To this end, the PG_error flag is set, then the
> PG_writeback flag is cleared, and only *then* can lock_page() be called.

This reintroduces the fault vs truncate race window, which must be fixed.

Also, it is adding a fair bit of complexity in an area where we should
instead be reducing it. I think your filesystem should not be doing
writeback caching of dirty data in the cases where it is so problematic
(or at least, disallow mmap and read on the dirty data until it has been
written back or failed).

But otherwise I guess if you really want to discard the dirty data after
a failed writeback attempt, what's wrong with just invalidate_inode_pages2?
