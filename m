Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZA1K3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZA1K3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZA1K24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:28:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:54610 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZA1K2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WdrN7mgKpV7/P0XZ2wJKJypTYNm/rEWdBO8RR3kCUnpCCA4XSqu7NT9YnJw50DRJLf
         0FcPi3xVqCnBYPD/k8/b7KHBSUHoU045OQxC50eOnHxPMZ9Q6/hc3k1RaU+qoi9RFY+Y
         qUJYxtHtcSOfefCEN/rJyQT5M4/hLkmxdAL0k=
Date: Wed, 28 Jan 2009 19:28:41 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: linux mm <linux-mm@kvack.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [BUG] mlocked page counter mismatch
Message-ID: <20090128102841.GA24924@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After executing following program, 'cat /proc/meminfo' shows
following result. 

--
# cat /proc/meminfo 
..
Unevictable:           8 kB
Mlocked:               8 kB
..

-- test program --

#include <stdio.h>
#include <sys/mman.h>
int main()
{
        char buf[64] = {0,};
        char *ptr;
        int k;
        int i,j;
        int x,y;
        mlockall(MCL_CURRENT);
        sprintf(buf, "cat /proc/%d/maps", getpid());
        system(buf);
        return 0;
}

--

It seems mlocked page counter have a problem.
After I diged in source, I found that try_to_unmap_file called 
try_to_mlock_page about shared mapping pages 
since other vma had VM_LOCKED flag.
After all, try_to_mlock_page called mlock_vma_page. 
so, mlocked counter increased

But, After I called munlockall intentionally, the counter work well. 
In case of munlockall, we already had a mmap_sem about write. 
Such a case, try_to_mlock_page can't call mlock_vma_page.
so, mlocked counter didn't increased. 
As a result, the counter seems to be work well but I think 
it also have a problem.



