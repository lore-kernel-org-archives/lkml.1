Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbXESNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbXESNCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXESNCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:02:09 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33407 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753831AbXESNCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:02:07 -0400
Message-ID: <379579717.08762@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 19 May 2007 21:02:02 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
Message-ID: <20070519130202.GB6095@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <379355696.61291@ustc.edu.cn> <20070518232335.8a4c8247.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518232335.8a4c8247.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:23:35PM -0700, Andrew Morton wrote:
> 
> That would have to be the best changelog I've ever seen ;) Thanks for
> persisting with this.

Thank you :)

> > sysbench oltp (trans/sec): up to 8% gain
> 
> Have you given any thought to identifying workloads which may be worsened
> by your changes?  Attempt to deliberately expose any weak spots?

Yeah. All possible downsides I can imagine are:

- CPU overheads
  Only random reads will be hurt.
  That's 1% slow down for _sparse files_, and should be much smaller
  when real I/O is involved.

- Behavior changes
  It do not enforce strict check sequentialness.
  - it is in general a good behavior for interleaved reads and
    clustered-and-intermixed-random/sequential workloads.
  - it might lead to more readahead misses
    E.g. a random read sequence of 0,1,4,12,28,60,92,124,156,188,220
    that is weird enough to start the readahead and hit all the
    lookahead pages.
    I highly doubt the possibility of such patterns happen in real
    world. But if ever it happens repeatedly for some user, he can
    work it around easily by tuning readahead_kb to some other value.

So, it is only a possibility that some random workload may be
worsened. But it's really hard to find one real world example.

