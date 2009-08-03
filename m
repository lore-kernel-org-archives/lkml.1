Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbZHCPXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbZHCPXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZHCPXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:23:45 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55524 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbZHCPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=W+L9BC5JR/Mx9IrYABR5WSKXwYgXG2ScZc0xnBJ8S2swDWWs4SP2ysHy/jdPmOIOI1
         cZi2XfzSuva9XssmChDGOzcHBSyDgEBar9hQFRWtAakpKb0CPQ6X4y5UfHy1zlZWtYFC
         6nQVRgmFXvOI0yMqIYZAa7JAOyF7sRZwOXhzc=
MIME-Version: 1.0
Date: Mon, 3 Aug 2009 17:23:44 +0200
Message-ID: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
Subject: get_user_pages() on an mmap()ed file allowed? What to do if 0 < 
	get_user_pages(..., nr_pages, ...) < nr_pages?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I have a PCI device driver performing DMA to a scattered user-space buffer.
Given a malloc()ed buffer, get_user_pages(..., buffer, nr_pages, ...)
always returns to requested number of pages and everything works as
expected.
So far so good.

Since that I changed userspace to mmap() a file, instead of
malloc()ing a buffer.
The mmap() in userspace works.

However, in the driver get_user_pages() starts to return less pages
than I requested, in an undeterministic fashion (most of the times I
get the expected number,
sometimes I get only a part of the requested pages).

Reading the get_user_pages() implementation dazzles me too much,
still.  I wonder if I am violating the kernel API?

- is it allowed to have a PCI device DMA-read from memory pages, that
belong to a file mmap()'d by userspace?
- what are valid reasons for get_user_pages() to fail?
- what should a driver do when get_user_pages() returns less pages
than requested?


A snippet of the code:


my user space does:

    int fd = open(filename, O_RDONLY);
    assert(fd >= 0);

    /* map the file in memory */
    char *buffer = mmap(0, buffersize, PROT_READ, MAP_SHARED, fd, 0);
    assert(buffer != MAP_FAILED);

    /* advice sequential access */
    int rc = madvise(buffer, buffersize, MADV_SEQUENTIAL);
    assert(rc == 0);

my driver does:

    const unsigned long first = (boe & PAGE_MASK) >> PAGE_SHIFT;
    const unsigned long last  = ((boe + count - 1) & PAGE_MASK) >> PAGE_SHIFT;
    const int nr_pages = last - first + 1;
    ...
    down_read(&current->mm->mmap_sem);
    rc = get_user_pages(current, current->mm, start & PAGE_MASK,
nr_pages, 0 /* do not write*/, 1 /* do force */, pages, NULL);
    up_read(&current->mm->mmap_sem);

    BUG_ON(rc < nr_pages);

Thanks,
-- 
Leon
