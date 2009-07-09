Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZGIIF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZGIIF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGIIFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:05:01 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:52726 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZGIIEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=cWt5xvcWrBhy1rroCmIflsjiNYQSTyS8eBkD9yOROT6g79fy63YUM4l8zniKlcFBLr
         qtmKLkXpwu3kE8uECA/HM2ahcJIdOPEETwEECyuHH+br4SP6cUXx0ev/v7h6n0HdlUFs
         CRy7gRgml9rUaH9y3MTFxTMDz8bAy2Iezj0yI=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Jul 2009 04:04:31 -0400
Message-ID: <8bd0f97a0907090104h5d4984dfkbeb82616a01128c8@mail.gmail.com>
Subject: truncate on MAP_SHARED files in ramfs filesystems on no-mmu
To: David Howells <dhowells@redhat.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reviewing LTP tests shows mmap09 failing.  this test creates a file of
a certain length, opens it and creates a shared mapping, and then
tries various truncate tests:
truncate to a smaller size
truncate to a larger size
truncate to size 0

the first and last fail on no-mmu due to
file-nommu.c:ramfs_nommu_resize() rejecting attempts to shrink on a
shared mapping:
    /* check that a decrease in size doesn't cut off any shared mappings */
    if (newsize < size) {
        ret = ramfs_nommu_check_mappings(inode, newsize, size);
        if (ret < 0)
            return ret;
    }

my question is why ?  if an application maps a fd with MAP_SHARED,
truncates it, and then it or someone else who has that fd mapped tries
to access the now-invalid tail end, that is a bug in the application.
i dont see why we should be protecting users here from their own buggy
code ?
-mike
