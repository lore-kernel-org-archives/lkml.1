Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYAOXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYAOXF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYAOXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:05:22 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:48869 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYAOXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=im0kxrPi16h2uKKRTrYwjpbVZjIY808Li46XpXng8yqmgWy8GV1aQVbVT/88p2e73tGZsPWOCiNbsdPXBUkvt22r0HPtDqX18jh7YPw0jDXIhn8Kv581W2GYN03QqNiNaw3AZ/FI00x65y0VvPDP1LESR2hW3RVsAIyJARyARIc=
Message-ID: <cf3edd8d0801151505r54bfd9d0r89f57e3835f295e1@mail.gmail.com>
Date: Tue, 15 Jan 2008 23:05:17 +0000
From: "Colin Fowler" <elethiomel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive benchmark on 8 Core Xeon
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080115220641.GC2665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
	 <20080114185520.GA26540@elte.hu>
	 <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com>
	 <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com>
	 <20080115220641.GC2665@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
      I'll get the results tomorrow as I'm now out of the office, but
I can perhaps answer some of your queries now.

On Jan 15, 2008 10:06 PM, Ingo Molnar <mingo@elte.hu> wrote:

> hm, the system has considerable idle time left:
>
>  r  b swpd   free   buff  cache   si so  bi bo   in    cs  us sy id wa
>  8  0    0 1201920 683840 1039100  0  0   3  2   27    46   1  0 99  0
>  2  0    0 1202168 683840 1039112  0  0   0  0  245 45339  80  2 17  0
>  2  0    0 1202168 683840 1039112  0  0   0  0  263 47349  84  3 14  0
>  2  0    0 1202300 683848 1039112  0  0   0 76  255 47057  84  3 13  0
>
> and context-switches 45K times a second. Do you know what is going on
> there? I thought ray-tracing is something that can be parallelized
> pretty efficiently, without having to contend and schedule too much.
>

This is a RTRT (real-time ray tracing) system and as a result differs
from traditional offline ray-tracers as it is optimised for speed. The
benchmark I ran while these data were collected renders an 80K polygon
scene to a 512x512 buffer at just over 100fps.

The context switches are most likely caused by the pthreads
synchronisation code. There are two mutexs. Each job is a 32x32 tile
and each mutex is therefore unlocked (512/32) * (512/32) * 100 (for
100fps) * 2 =~50k. There's very likely where our context switches are
coming from. Larger tile sizes would of course reduce the locking
overhead, but then the ray-tracer suffers form load imbalance as some
tiles are much quicker to render than others. Empircally we've found
that this tile-size works the best for us.

The CPU idling occurs as the system doesn't yet perform asynchronous
rendering. When all tiles in a current job queue are finished the
current frame is done. At this point all worker threads sleep while
the master thread blits the image to the screen and fills the job
queue for the next frame. The data probably shows that one CPU is kept
maxed and the others reach about 90% most of the time. This is
something on my TODO list to fix along with a myriad of other
optimisations :)

regards,
        Colin
