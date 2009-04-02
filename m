Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbZDBTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbZDBTmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZDBTmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:42:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZDBTmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:42:05 -0400
Date: Thu, 2 Apr 2009 12:39:20 -0700
From: Chris Wright <chrisw@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
Message-ID: <20090402193920.GF10392@x200.localdomain>
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <alpine.LNX.2.00.0904022114040.4265@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0904022114040.4265@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jj@chaosbits.net) wrote:
> Do you rely only on the checksum or do you actually compare pages to check 
> they are 100% identical before sharing?

Checksum has absolutely nothing to do w/ finding if two pages match.
It's only used as a heuristic to suggest whether a single page has
changed.  If that page is changing we won't bother trying to find a
match for it.  Here's an example of the life of a page w.r.t checksum.

1. checksum = uninitialized
2. first time page is found, checksum it (checksum = A).
   if checksum has changed (uninitialize != A) don't go any further w/ that page
3. next time page is found, checksum it (checksum = B).
   if checksum has change (A != B) don't go any further w/ that page
4. next time page is found, checksum it (checksum = B).
   if checksum has changed (B == B)...it hasn't, continue processing the
   page

later if a match is found in the tree (which is sorted by _contents_,
i.e. memcmp) we'll attempt to merge the pages which at it's very core
does:

	if (pages_identical(oldpage, newpage))
		ret = replace_page(vma, oldpage, newpage, orig_pte, newprot);

pages_identical?  you guessed it...just does:

	r = memcmp(addr1, addr2, PAGE_SIZE)

thanks,
-chris
