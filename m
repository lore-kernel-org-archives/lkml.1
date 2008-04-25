Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbYDYMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbYDYMRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYDYMRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:17:04 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3701 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbYDYMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:17:03 -0400
Message-ID: <4811CBBC.4000206@hp.com>
Date: Fri, 25 Apr 2008 08:17:00 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk> <4811BDBB.8010604@hp.com>
In-Reply-To: <4811BDBB.8010604@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the results, the last kernel (2.6.25-nomerges.nofrontmerges)
had 10 runs of 2 minutes each (as opposed to 25 runs of 10 minutes each
for the other kernels). I'm doing a full run of that kernel w/
25x10minutes, but wanted to get this out for feedback first:

Increasing the merge attempts decreases the I/Os per second by less than
0.5%.

Kernel                         NM   I/Os per sec
-----------------------------  --   ------------
2.6.25                                    472.39

2.6.25-nomerges                 0         472.54
2.6.25-nomerges.onehit          0         472.10
2.6.25-nomerges.nofrontmerges   0         470.38

2.6.25-nomerges                 1         472.58
2.6.25-nomerges.onehit          1         472.02
2.6.25-nomerges.nofrontmerges   1         470.65

The savings in cycles for these random loads compared to the total cycle
costs goes from 4.4% up to 4.8% as we add in more merge attempts (as
compared to almost 5.8% for the stock 2.6.25 kernel).

Kernel                         NM  TAG   Total     I/O Code
-----------------------------  --  ----  --------  --------
2.6.25                             CPU:   5.7794%   7.5440%

2.6.25-nomerges                 0  CPU:   5.4957%   7.1987%
2.6.25-nomerges.onehit          0  CPU:   5.7822%   7.5034%
2.6.25-nomerges.nofrontmerges   0  CPU:   5.2041%   6.8534%

2.6.25-nomerges                 1  CPU:   4.4031%   5.7710%
2.6.25-nomerges.onehit          1  CPU:   4.7517%   6.1702%
2.6.25-nomerges.nofrontmerges   1  CPU:   4.8372%   6.3642%


Kernel                         NM  TAG   Total     I/O Code
-----------------------------  --  ----  --------  --------
2.6.25                             DCM:   7.9861%  10.2456%

2.6.25-nomerges                 0  DCM:   8.2134%  10.5145%
2.6.25-nomerges.onehit          0  DCM:   7.5559%   9.7389%
2.6.25-nomerges.nofrontmerges   0  DCM:   7.6436%   9.8934%

2.6.25-nomerges                 1  DCM:   6.6705%   8.5247%
2.6.25-nomerges.onehit          1  DCM:   6.3432%   8.1886%
2.6.25-nomerges.nofrontmerges   1  DCM:   7.2244%   9.3407%


Given that the tunable is meant to be turned on when the admin /knows/
the load is going to be random, it seems to me that adding in the other
merge checks (one-hit, back-merge) are going to be wasted the vast
majority of the time.

Thanks,
Alan
