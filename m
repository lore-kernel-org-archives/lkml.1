Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYHYLoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYHYLoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYHYLnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:43:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:38571 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYHYLnw (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:43:52 -0400
Date: Mon, 25 Aug 2008 12:43:47 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Message-ID: <20080825114346.GB20960@shareable.org>
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org> <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com> <48AE0476.80109@snapgear.com> <6934efce0808211948kd12ba76k1ee847a0e08010e0@mail.gmail.com> <48B2529B.8030906@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2529B.8030906@snapgear.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer wrote:
> Sort of. It actually just uses a single ->read to bring in
> the entire file contents. There is a few limitations on the use
> of mmap() for non-mmu. Documentation/nommu-mmap.txt gives
> more details. With no MMU it does rely on being able to kmalloc()
> a single RAM region big enough to hold the entire file.

That's unfortunate, if you're using FDPIC-ELF or BFLT-XIP, you really want
to kmalloc() one region for code (i.e. mmap not the whole file), and
one separate for data.  Asking for a single larger region sometimes
creates much higher memory pressure while kmalloc() attempts to
defragment by evicting everything.

But that's fiddly to do right in general.

The natural thing for AXFS to do to support no-MMU FDPIC-ELF or
BFLT-XIP is store the code segment uncompressed and contiguous, and
the data segment however the filesystem prefers, and the profiling
information to work out where these are is readily available from the
mmap() calls, which are always the same when an executable is run.

-- Jamie
