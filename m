Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYJaUy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYJaUy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYJaUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:54:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYJaUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:54:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=Bdw4TXjGkOSGrzWx2qk30+U+yJQhi8hjdaLDEd26ZpyCMwjb/V1Ze6sY+NYcoUHLI
	T3ZBJ3kG/ghNBL0838BWw==
MIME-Version: 1.0
Date: Fri, 31 Oct 2008 13:54:14 -0700
Message-ID: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
Subject: Metadata in sys_sync_file_range and fadvise(DONTNEED)
From: Chad Talbott <ctalbott@google.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@google.com>, Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are looking at adding calls to posix_fadvise(DONTNEED) to various
data logging routines.  This has two benefits:

  - frequent write-out -> shorter queues give lower latency, also disk
    is more utilized as writeout begins immediately

  - less useless stuff in page cache

One problem with fadvise() (and ext2, at least) is that associated
metadata isn't scheduled with the data.  So, for a large log file with
a high append rate, hundreds of indirect blocks are left to be written
out by periodic writeback.  This metadata consists of single blocks
spaced by 4MB, leading to spikes of very inefficient disk utilization,
deep queues and high latency.

Andrew suggests a new SYNC_FILE_RANGE_METADATA flag for
sys_sync_file_range(), and leaving posix_fadvise() alone.  That will
work for my purposes, but it seems like it leaves
posix_fadvise(DONTNEED) with a performance bug on ext2 (or any other
filesystem with interleaved data/metadata).  Andrew's argument is that
people have expectations about posix_fadvise() behavior as it's been
around for years in Linux.

I'd like to get a consensus on what The Right Thing is, so I can move
toward implementing it and moving the logging code onto that
interface.

Chad
