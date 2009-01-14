Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZANVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZANVgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZANVgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:36:22 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:29536 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZANVgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:36:21 -0500
Date: Wed, 14 Jan 2009 13:34:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [take2] OOM documentation update [was: Linux killed Kenny,
 bastard!]
Message-Id: <20090114133444.f85b1dc7.randy.dunlap@oracle.com>
In-Reply-To: <20090114170606.GB12102@ioremap.net>
References: <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
	<20090113135246.GA29251@ioremap.net>
	<20090113140627.507f15e1@lxorguk.ukuu.org.uk>
	<20090113142423.GA30710@ioremap.net>
	<661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com>
	<20090113152106.GA1134@ioremap.net>
	<alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com>
	<20090113213316.GB27227@ioremap.net>
	<alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
	<20090114161225.GA9584@ioremap.net>
	<20090114170606.GB12102@ioremap.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.496E5A79.0271:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 20:06:06 +0300 Evgeniy Polyakov wrote:

> Updated version fixes some errors and extends description by adding
> swapping and children relation explaintaion.
> 
> Signed.

??

> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index d105eb4..4aa1918 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -2311,6 +2311,33 @@ increase the likelihood of this process being killed by the oom-killer.  Valid
>  values are in the range -16 to +15, plus the special value -17, which disables
>  oom-killing altogether for this process.
>  
> +The process to be killed in an out-of-memory situation is selected among all others
> +based on its badness score. This value equals the original memory size of the process
> +originally and is then updated according to its CPU time (utime + stime) and the

drop "originally" since earlier part of sentence says "original memory size".

> +run time (uptime - start time). The longer it runs the smaller is the score.
> +Badness score is divided by the square root of the cpu time and then by

                                                      CPU

> +the double square root of the run time.
> +
> +Swapped out tasks are killed first. Half of each child's memory size is added to
> +the parent's score if they do not share the same memory. Thus forking servers
> +are the prime candidates to be killed. Having only one 'hungry' child will make
> +parent less preferable than the child.
> +
> +/proc/<pid>/oom_score shows process' current badness score.
> +
> +The following heuristics are then applied:
> + * if the task was reniced, its score doubles
> + * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
> + 	or CAP_SYS_RAWIO) have their score divided by 4
> + * if oom condition happened in one cpuset and checked task does not belong
> + 	to it, its score is divided by 8
> + * resulted score is multiplied by the two in the power of oom_adj when it is

confusing.  Is this:    multiplied by two to the power of oom_adj when it is ... ?

> + 	positive, and divided otherwise, i.e.
> +	points <<= oom_adj when it is positive and
> +	points >>= oom_adj otherwise
> +
> +The task with the highest badness score is then killed.
> +
>  2.13 /proc/<pid>/oom_score - Display current oom-killer score
>  -------------------------------------------------------------


---
~Randy
