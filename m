Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbYFDRxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbYFDRxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760870AbYFDRxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:53:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38151 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbYFDRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:53:17 -0400
Date: Wed, 4 Jun 2008 10:42:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add io-throttle controller documentation
Message-Id: <20080604104205.8b44a61a.randy.dunlap@oracle.com>
In-Reply-To: <1211648217-13361-2-git-send-email-righi.andrea@gmail.com>
References: <1211648217-13361-2-git-send-email-righi.andrea@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 18:56:55 +0200 Andrea Righi wrote:

> Documentation of the block device I/O bandwidth controller: description, usage,
> advantages and design.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  Documentation/controllers/io-throttle.txt |   81 +++++++++++++++++++++++++++++
>  1 files changed, 81 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
> new file mode 100644
> index 0000000..e7ab050
> --- /dev/null
> +++ b/Documentation/controllers/io-throttle.txt
> @@ -0,0 +1,81 @@
> +
> +               Block device I/O bandwidth controller
> +
> +1. Description
> +
> +This controller allows to limit the block I/O bandwidth for specific process
> +containers (cgroups) imposing additional delays on I/O requests for those
> +processes that exceed the limits defined in the control group filesystem.
> +
> +Bandwidth limiting rules offers a better control over QoS respect to priority

                            offer better control over QoS with respect to priority

> +or weighted-based solutions, that only give information about applications'

      weight-based solutions that ...

> +relative performance requirements.
> +
> +The goal of the I/O bandwidth controller is to improve performance
> +predictability and QoS of the different control groups sharing the same block
> +devices.
> +
> +NOTE: if you're looking for a way to improve the overall throughput of the
> +system probably you should use a different solution.
> +
> +2. User Interface
> +
> +A new I/O bandwidth limitation rule is described using the file
> +blockio.bandwidth.
> +
> +Example:
> +
> +* mount the cgroup filesystem (blockio subsystem):
> +  # mkdir /mnt/cgroup
> +  # mount -t cgroup -oblockio blockio /mnt/cgroup
> +
> +* Instantiate the new cgroup "foo":
> +  # mkdir /mnt/cgroup/foo
> +  --> the cgroup foo has been created
> +
> +* add the current shell process to the "foo" cgroup:
> +  # /bin/echo $$ > /mnt/cgroup/foo/tasks
> +  --> the current shell has been added to the cgroup "foo"
> +
> +* give maximum 1MiB/s of I/O bandwidth for the cgroup "foo":
> +  # /bin/echo 1024 > /mnt/cgroup/foo/blockio.bandwidth
> +  # sh
> +  --> the subshell 'sh' is running in cgroup "foo" and it can use a maximum I/O
> +      bandwidth of 1MiB/s (blockio.bandwidth is expressed in KiB/s).
> +
> +3. Advantages of providing this feature
> +
> +* Allow QoS for block device I/O among different cgroups
> +* Improve I/O performance predictability on block devices shared between
> +  different cgroups
> +* It is independent on the particular I/O scheduler (anticipatory, deadline,

                       of

> +  CFQ, noop) and/or the underlying block devices
> +* The bandwidth limitations are guaranteed both for synchronous and
> +  asynchronous operations, even the I/O passing through the page cache or
> +  buffers and not only direct I/O (see below for details)
> +
> +4. Design
> +
> +The I/O throttling is performed imposing an explicit timeout, via
> +schedule_timeout_killable() on the processes that exceed the I/O bandwidth
> +dedicated to the cgroup they belong.

                           they belong to.

> +
> +It just works as expected for read operations: the real I/O activity is reduced
> +synchronously according to the defined limitations.
> +
> +Write operations, instead, are modeled depending on the dirty pages ratio
> +(write throttling in memory), since the writes to the real block device are
> +processed asynchronously by different kernel threads (pdflush). However, the
> +dirty pages ratio is directly proportional to the actual I/O that will be
> +performed on the real block device. So, due to the asynchronous transfers
> +through the page cache, the I/O throttling in memory can be considered a form
> +of anticipatory throttling to the underlying block devices.
> +
> +Multiple re-writes in already dirtied page cache areas are not considered for
> +accounting the I/O activity. This is valid for multiple re-reads of pages
> +already present in the page cache as well.
> +
> +This means that a process that re-writes and/or re-reads multiple times the
> +same blocks in a file (without re-creating it by truncate(), ftrunctate(),
> +creat(), etc.) is affected by the I/O limitations only for the actual I/O
> +performed to (or from) the underlying block devices.


---
~Randy
