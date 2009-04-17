Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbZDQSMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbZDQSMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbZDQSLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:11:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbZDQSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:11:52 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904171335490.28603@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
	 <1239977776.23397.4590.camel@laptop>
	 <alpine.DEB.1.10.0904171021360.20239@qirst.com>
	 <1239979901.23397.4638.camel@laptop>
	 <alpine.DEB.1.10.0904171100510.21575@qirst.com>
	 <20090417153520.GA29968@elte.hu>
	 <alpine.DEB.1.10.0904171142050.13734@qirst.com>
	 <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>
	 <alpine.DEB.1.10.0904171335490.28603@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 20:11:32 +0200
Message-Id: <1239991892.23397.4905.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 13:45 -0400, Christoph Lameter wrote:
> Ok I made some changes to the latencytest program (gentwo.org/ll). I hope
> you can tell me what exactly you would consider meaningful numbers.
> 

> More fine grained resolution (100ns do not count measurements below 100ns):
> 
> latencytest -d -m100 -b100
> 
> CPUs: Freq=3.16Ghz Processors=8 Cores=4 cacheline_size=64 Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz
> 266619352 samples below 100 nsec
> 19 involuntary context switches
> 13254 (0.00497088%) variances in 10.00 seconds: minimum 0.10us maximum
> 143.63us average 3.63us
> usecs percent samples
> -------------------------
>  0.1    23.7     3141
>  0.2     0.7       87
>  0.3     0.1       12
>  0.5     0.0        1
>  0.6     0.0        1
>  1.9     0.1       17
>  2.0     0.4       47
>  2.1     1.0      127
>  2.2     2.3      309
>  2.3     0.3       35
>  2.4     0.2       25
>  2.5     0.2       22
>  2.6     0.2       23
>  2.7     2.0      267
>  2.8     4.2      559
>  2.9     0.4       52
>  3.0     1.1      143
>  3.1     1.5      198
>  3.2     1.1      149
>  3.3     0.7       97
>  3.4     0.6       78
>  3.5     0.6       83
>  3.6     0.9      121
>  3.7     0.8      112
>  3.8     4.1      547
>  3.9     1.5      194
>  4.0     0.3       42
>  4.1     0.1       15
>  4.2     0.2       23
>  4.3     0.8      108
>  4.4     0.5       63
>  4.5     0.2       20
>  4.6     0.2       25
>  4.7     0.2       28
>  4.8     0.3       44
>  4.9     0.2       24
>  5.0     1.0      126
>  5.1     3.1      414
>  5.2    18.0     2385
>  5.3     6.5      857
>  5.4     4.9      656
>  5.5     2.5      335
>  5.6     3.4      448
>  5.7     3.4      445
>  5.8     2.0      268
>  5.9     0.9      116
>  6.0     0.4       54
>  6.1     0.2       22
>  6.2     0.3       36
>  6.3     0.1       17
>  6.4     0.1       10
>  6.5     0.1       11
>  6.6     0.1        9
>  6.7     0.1        9
>  6.8     0.1        8
>  6.9     0.0        4
>  7.0     0.1        8
>  7.1     0.0        6
>  7.2     0.1        7
>  7.3     0.1       14
>  7.4     0.1        7
>  7.5     0.0        4
>  7.6     0.0        3
>  7.7     0.0        6
>  7.8     0.1        7
>  7.9     0.0        6
>  8.0     0.0        5
>  8.1     0.0        4
>  8.2     0.0        3
>  8.3     0.0        2
>  8.4     0.0        2
> 
> The group around 5usec is likely the timer interrupt.

Right, this is nice. 

There are a number of peaks (aside from 0), 2.2, 2.8, 3.1, 3.8, 4.3 and
5.2 -- and I suspect your guess about 5.2 is right.

Something like this is nice to compare between kernels. Chris'
suggestion of timing a simple fixed loop:

$ time (let i=1000000; while [ $i -gt 0 ]; do let i--; done)

real    0m14.389s
user    0m13.787s
sys     0m0.498s

Is also useful, since it gives an absolute measure of time available to
user-space.

Although I suspect a simple C while(i--); might be better due to less
code involved.



