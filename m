Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZKFBNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZKFBNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZKFBNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:13:38 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58844 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbZKFBNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:13:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 10:11:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
Message-Id: <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	<20091104234923.GA25306@redhat.com>
	<alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>
	<alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 10:36:06 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: Make mm counters per cpu V2
> 
> Changing the mm counters to per cpu counters is possible after the introduction
> of the generic per cpu operations (currently in percpu and -next).
> 
> With that the contention on the counters in mm_struct can be avoided. The
> USE_SPLIT_PTLOCKS case distinction can go away. Larger SMP systems do not
> need to perform atomic updates to mm counters anymore. Various code paths
> can be simplified since per cpu counter updates are fast and batching
> of counter updates is no longer needed.
> 
> One price to pay for these improvements is the need to scan over all percpu
> counters when the actual count values are needed.
> 
> V1->V2
> - Remove useless and buggy per cpu counter initialization.
>   alloc_percpu already zeros the values.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
Thanks. My small concern is read-side.

This is the result of 'top -b -n 1' with 2000 processes(most of them just sleep)
on my 8cpu, SMP box.

== [Before]
 Performance counter stats for 'top -b -n 1' (5 runs):

     406.690304  task-clock-msecs         #      0.442 CPUs    ( +-   3.327% )
             32  context-switches         #      0.000 M/sec   ( +-   0.000% )
              0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
            718  page-faults              #      0.002 M/sec   ( +-   0.000% )
      987832447  cycles                   #   2428.955 M/sec   ( +-   2.655% )
      933831356  instructions             #      0.945 IPC     ( +-   2.585% )
       17383990  cache-references         #     42.745 M/sec   ( +-   1.676% )
         353620  cache-misses             #      0.870 M/sec   ( +-   0.614% )

    0.920712639  seconds time elapsed   ( +-   1.609% )

== [After]
 Performance counter stats for 'top -b -n 1' (5 runs):

     675.926348  task-clock-msecs         #      0.568 CPUs    ( +-   0.601% )
             62  context-switches         #      0.000 M/sec   ( +-   1.587% )
              0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
           1095  page-faults              #      0.002 M/sec   ( +-   0.000% )
     1896320818  cycles                   #   2805.514 M/sec   ( +-   1.494% )
     1790600289  instructions             #      0.944 IPC     ( +-   1.333% )
       35406398  cache-references         #     52.382 M/sec   ( +-   0.876% )
         722781  cache-misses             #      1.069 M/sec   ( +-   0.192% )

    1.190605561  seconds time elapsed   ( +-   0.417% )

Because I know 'ps' related workload is used in various ways, "How this will
be in large smp" is my concern.

Maybe usual use of 'ps -elf' will not read RSS value and not affected by this.
If this counter supports single-thread-mode (most of apps are single threaded),
impact will not be big.

Thanks,
-Kame

