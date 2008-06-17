Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYFQO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYFQO4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbYFQO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:56:33 -0400
Received: from [194.117.236.238] ([194.117.236.238]:34408 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbYFQO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:56:33 -0400
Date: Tue, 17 Jun 2008 17:55:35 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080617175535.638e54c5@linux360.ro>
In-Reply-To: <20080617135031.GA10316@Krystal>
References: <20080614181103.17617db1@linux360.ro>
	<20080616122249.GB18561@Krystal>
	<20080616162212.27a8c119@linux360.ro>
	<20080616164609.GM20851@kernel.dk>
	<84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
	<20080616182843.GS20851@kernel.dk>
	<20080617153934.59a7c7ee@linux360.ro>
	<20080617154923.36195161@linux360.ro>
	<20080617131036.GB8696@Krystal>
	<20080617163551.49f96c7d@linux360.ro>
	<20080617135031.GA10316@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 09:50:31 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> Yeah, although using set affinity with CPU hotplug is broken by
> design.
> 
> Mathieu

Never thought about this, but it does make sense. I presume this
affects relay reading as well, right? Quote from sched_setaffinity(2):
> EINVAL The affinity bit mask mask contains no processors that are phys-
>        ically on the system, or cpusetsize is smaller than the size  of
>        the affinity mask used by the kernel.
We have 2 situations:
1. CPUs do _not_ get reordered --- the mask is then invalid, will it be
invalidated by the kernel even if set prior to the hotplug event?
2. CPUs get reordered after hotplug events. Assume this ([CPU logical <physical>]):
CPU 0 <0>, CPU 1 <1>, CPU 2 <2> => CPU 0 <0>, CPU 1 <2>
relay filenames likely change, but the underlying fds are preserved.
If the threads get migrated, this means we end up reading cross-CPU, AFAICS.

Do we ignore this and hope no one uses relay apps while triggering CPU
hotplug events?


	Eduard
