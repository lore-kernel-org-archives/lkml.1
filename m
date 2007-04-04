Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXDDQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXDDQpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbXDDQpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:45:42 -0400
Received: from waste.org ([66.93.16.53]:42072 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXDDQpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:45:41 -0400
Date: Wed, 4 Apr 2007 11:32:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps: Add /proc/pid/pagemap interface
Message-ID: <20070404163232.GV4892@waste.org>
References: <1.486631555@selenic.com> <13.486631555@selenic.com> <17939.35217.938339.677599@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17939.35217.938339.677599@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 03:18:41PM +0400, Nikita Danilov wrote:
> This pushes binary data to the user space. Wasn't /proc supposed to be
> ascii-based to avoid compatibility problems (e.g., size of unsigned long
> changing, endianness, etc.)?

Most of what's in /proc is ASCII, true. But there are notable
exceptions - kcore, auxv, mem. This is just another window into memory
like kcore and mem. It's also a fairly big window. To examine a 1G
mapping, you need to read 1M of data.

ASCII would be rather ugly here. It's important that the interface be
seekable so that you can skip over wide ranges of data with no maps.
So all the elements would have to be nice fixed sizes. That'd mean 16
hex digits plus a space/newline. So to figure out what's at b7f81000,
I'd have to divide by 4096 (I already have to know the page size),
then multiply by 17, getting c37791. And then I'd have to copy more
than 2x the data in byte-wide chunks due to alignment concerns.

With the extra translation on both ends, the expanded data size, and
the alignment issues, this probably just got 10x-20x slower. Which
means taking a snapshot of a typical system and doing any sort of live
display just got a hell of a lot more impractical.

Now I could adjust these to only export u64s in some preferred
endianness. But given I already need details like the page size to
make any sense of it, it seems unnecessary. Also, the PFNs are fairly
opaque unless you're attempting to correlate them with /proc/kpagemap.

--
Mathematics is the supreme nostalgia of our time.
