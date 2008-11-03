Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYKCWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYKCWlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYKCWlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:41:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:53702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYKCWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:41:03 -0500
Subject: Re: mmap: is default non-populating behavior stable?
From: Peter Zijlstra <peterz@infradead.org>
To: "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>, riel <riel@redhat.com>
In-Reply-To: <490F73CD.4010705@gmail.com>
References: <490F73CD.4010705@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Nov 2008 23:41:23 +0100
Message-Id: <1225752083.7803.1644.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 23:57 +0200, Eugene V. Lyubimkin wrote:
> Hello kernel hackers!
> 
> The current implementation of mmap() in kernel is very convenient.
> It allows to mmap(fd) very big amount of memory having small file as back-end.
> So one can mmap() 100 MiB on empty file, use first 10 KiB of memory, munmap() and have
> only 10 KiB of file at the end. And while working with memory, file will automatically be
> grown by read/write memory requests.
> 
> Question is: can user-space application rely on this behavior (I failed to find any
> documentation about this)?
> 
> TIA and please CC me in replies.

mmap() writes past the end of the file should not grow the file if I
understand things write, but produce a sigbus (after the first page size
alignment).

The exact interaction of mmap() and truncate() I'm not exactly clear on.

The safe way to do things is to first create your file of at least the
size you mmap, using truncate. This will create a sparse file, and will
on any sane filesystem not take more space than its meta data.

Thereafter you can fill it with writes to the mmap.

