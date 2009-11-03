Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZKCSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZKCSf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKCSf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:35:27 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:41600 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZKCSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Vuca9paTUOAKciUG9PkilgqYidi2dxW3lSFCxgxmsUVW5Aks7Lbt+PZlxoCejt8VXr
         pWzG58iXfp6mLMcMsoyhbnj/4O873CvpeBZxH/3jrrnyky3mJn2oshV8iVHnrZU94xAK
         Z+UJHLRw3D3FPyUrQZdcxwHVpXb4SkTC41lks=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0911030719m425c208cg311f44a91fad8342@mail.gmail.com>
References: <200910262243.41327.czoccolo@gmail.com>
	 <x49zl7c268s.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0910271124r2cf9f9c0l83fdc59b50619202@mail.gmail.com>
	 <x493a4wsn5c.fsf@segfault.boston.devel.redhat.com>
	 <x49fx8wbqd0.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0911030042q5963718aj5875c542e6f6cc40@mail.gmail.com>
	 <x49ocnju35d.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0911030719m425c208cg311f44a91fad8342@mail.gmail.com>
Date: Tue, 3 Nov 2009 19:35:29 +0100
Message-ID: <4e5e476b0911031035l7caffcb7n36b6eddd399864e7@mail.gmail.com>
Subject: Fwd: [PATCH 0/5] cfq-iosched: improve latency for no-idle queues (v3)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
Jeff did some testing of this patchset on his NCQ-enabled SSD (the
30GB OCZ Vertex).
The test suite contained various multiple competing workloads
scenarios, and was run on for-2.6.33 and cfq-2.6.33 branches.

Max latencies were reduced in most cases, and we had also improvements
on bandwidth side in some scenarios, especially
for multiple random readers, either alone or competing with writes.
2 random readers aggregate bw increased from 48356 to 74205
and 4 random readers vs 1 seq writer:
* aggregate reader bw increased from 35242 to 56400
* writer bandwidth increased from 33269 to 55127
* maximum latency on read decreased from 535 to 324
* maximum latency on writes decreased from 22243 to 1153
It's a win on all measures.
The effect increasing the number of readers to 32 (latency_test_2.fio)
is even more visible (max read latency reduced from 3305 to 268,
aggregated read BW increased from 32894 to 164571).

The only case where I see an increased max latency is for 2 random
readers vs 1 seq reader:

for-2.6.33:
randomread.0: read_bw = 15,418K
randomread.1: read_bw = 15,399K
seqread: read_bw = 409K
0: read_bw = 31226
0: read_lat_max = 11.589
0: read_lat_avg = 3.22366666666667

cfq-2.6.33:
randomread.0: read_bw = 10,065K
randomread.1: read_bw = 10,067K
seqread: read_bw = 101M
0: read_bw = 121132
0: read_lat_max = 303
0: read_lat_avg = 0.282333333333333

but here the increased latency is paid back by a large increase in
sequential read BW (the max latency is, btw, experienced by the seq
reader, so I think it is a fair behaviour).

Jeff observed that the for-2.6.33 numbers were worse than his baseline
runs, probably due to changed hw_tag detection.
My patchset is much less sensible to hw_tag on SSDs (since there are
much less situations in which it would idle), so my numbers are
unaffected.

Corrado
