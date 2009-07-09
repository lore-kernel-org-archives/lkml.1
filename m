Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZGIKHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZGIKHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZGIKHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:07:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36347 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbZGIKHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:07:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0907090104h5d4984dfkbeb82616a01128c8@mail.gmail.com>
References: <8bd0f97a0907090104h5d4984dfkbeb82616a01128c8@mail.gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: truncate on MAP_SHARED files in ramfs filesystems on no-mmu
Date: Thu, 09 Jul 2009 11:06:58 +0100
Message-ID: <24005.1247134018@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> reviewing LTP tests shows mmap09 failing.  this test creates a file of
> a certain length, opens it and creates a shared mapping, and then
> tries various truncate tests:
> truncate to a smaller size
> truncate to a larger size
> truncate to size 0
> 
> the first and last fail on no-mmu due to
> file-nommu.c:ramfs_nommu_resize() rejecting attempts to shrink on a
> shared mapping:

Yes.  That's exactly right.

> my question is why?  if an application maps a fd with MAP_SHARED,
> truncates it, and then it or someone else who has that fd mapped tries
> to access the now-invalid tail end, that is a bug in the application.
> i dont see why we should be protecting users here from their own buggy
> code ?

This is protecting the kernel as much as the user.  There's no MMU to enforce
denial of access on the pages that truncate returns to the system.

This doesn't only protect the process with a mapping on that file against its
own truncate, but also other processes that have made mappings against that
file.

Whilst you can argue it either way, you need a better reason to change this
than it causes some LTP failures.  You cannot expect all the MM-related LTP
tests to work against a NOMMU system.

Doing it this way also makes things simpler in the kernel and makes the system
more robust.

If a process shared mmaps a file and then wants to truncate it, it can always
munmap the excess first.

David
