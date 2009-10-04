Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZJDRhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZJDRhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 13:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbZJDRhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 13:37:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60730 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411AbZJDRhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 13:37:13 -0400
Date: Sun, 4 Oct 2009 19:36:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq: enable idle for seeky processes on rotational NCQ
	devices
Message-ID: <20091004173636.GC26573@kernel.dk>
References: <200910041837.34546.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910041837.34546.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04 2009, Corrado Zoccolo wrote:
> Disabled idle window cause large latencies when seeky processes are competing
> with async writes, for rotational NCQ devices.
> 
> This patch, based on Vivek Goyal's original idea (http://lkml.org/lkml/2009/7/12/110),
> unconditionally enables idle window for seeky processes on rotational NCQ devices.
> As for non-NCQ devices, a smaller idle window (2ms) is used
> for seeky processes compared to normal I/O (8ms).
> 
> RAIDs should be marked as non-rotational as well (and probably a better flag
> name should be devised), since they can carry multiple operations in parallel.

I think this one is a bit problematic. What I'd like seeky processes to
do is enable 'idle unless other sync read comes in' for such cases,
otherwise it will cost us a lot of performance on the seeky vs seeky
cases because we don't get to take advantage of queuing. It would be
perfectly fine to continue waiting if just async IO comes in, but if we
have other seeky readers then they should get a turn.

I realize that this does skew potential priority issues.

-- 
Jens Axboe

