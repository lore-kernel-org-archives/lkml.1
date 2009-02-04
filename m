Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbZBDWir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbZBDWir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZBDWii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:38:38 -0500
Received: from movementarian.org ([79.99.65.163]:45635 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbZBDWih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:38:37 -0500
Date: Wed, 4 Feb 2009 17:38:36 -0500
From: wli@movementarian.org
To: Pavel Levshin <lpk@581.spb.su>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Major page faults counter is zero with MADV_RANDOM
Message-ID: <20090204223836.GE10229@movementarian.org>
References: <49898573.8070509@581.spb.su>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49898573.8070509@581.spb.su>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 03:09:23PM +0300, Pavel Levshin wrote:
> There is something wrong with page fault counter in mm/filemap.c, when 
> using madvise() with MADV_RANDOM flag set. Every page fault in this case 
> should be considered major, as it causes disk I/O. But in reality, 
> majflt/s in "sar -B" stays zero. I'm using 2.6.24 right now, but this 
> piece of code is identical in current kernel.
> The page is read into cache but no counter updated. The same applies 
> when kernel decides to disable read ahead due to excessive miss. 
> Furthermore, the code makes it possible to read ahead even with 
> MADV_RANDOM flag in some cases, as it loops from no_cached_page to 
> retry_find. And I am not sure, but does "no read ahead" really mean "no 
> page caching"?
> Please CC me if you want me to read your answer.

        /* If we don't want any read-ahead, don't bother */
        if (VM_RandomReadHint(vma))
                goto no_cached_page;

This blows past the only place in filemap_fault() where major faults
are accounted. You have spotted a bug, possibly even several. Major
fault accounting is missing from filemap_fault() in many cases beyond
just MADV_RANDOM. The gotos there are involved enough that it might
take me a few hours to come up with a patch. Maybe someone else who
works with the readahead affairs in there will finish it first.


-- wli
