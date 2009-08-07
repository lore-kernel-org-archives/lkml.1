Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZHGRKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZHGRKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZHGRKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:10:37 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:57264 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZHGRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:10:36 -0400
Date: Fri, 7 Aug 2009 10:08:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCH 2/3] exec: let do_coredump limit the number of
 concurrent dumps to pipes (v9)
Message-Id: <20090807100848.9805841b.randy.dunlap@oracle.com>
In-Reply-To: <20090720162901.GB9060@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090703104447.GA19371@hmsreliant.think-freely.org>
	<20090720154938.GA8563@hmsreliant.think-freely.org>
	<20090720162901.GB9060@hmsreliant.think-freely.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A7C5FBA.0089:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 12:29:01 -0400 Neil Horman wrote:

> core_pattern: Introduce core pipe limiting sysctl
> 
> Since we can dump cores to pipe, rather than directly to the filesystem, we
> create a condition in which a user can create a very high load on the system
> simply by running bad applications.  If the pipe reader specified in
> core_pattern is poorly written, we can have lots of ourstandig resources and
> processes in the system.  This sysctl introduces an ability to limit that
> resource consumption.  core_pipe_limit defines how many in-flight dumps may be
> run in parallel, dumps beyond this value are skipped and a note is made in the
> kernel log.  A special value of 0 in core_pipe_limit denotes unlimited core
> dumps may be handled (this is the default value).
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Earl Chew <earl_chew@agilent.com>
> 
> 
>  Documentation/sysctl/kernel.txt |   22 ++++++++++++++++++++++
>  fs/exec.c                       |   25 +++++++++++++++++++------
>  kernel/sysctl.c                 |    9 +++++++++
>  3 files changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 382cfd8..7706b6a 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -21,6 +21,7 @@ show up in /proc/sys/kernel:
>  - acct
>  - auto_msgmni
>  - core_pattern
> +- core_pipe_limit
>  - core_uses_pid
>  - ctrl-alt-del
>  - dentry-state
> @@ -119,6 +120,27 @@ core_pattern is used to specify a core dumpfile pattern name.
>  
>  ==============================================================
>  
> +core_pipe_limit:
> +
> +This sysctl is only applicable when core_pattern is configured to pipe core
> +files to user space helper a (when the first character of core_pattern is a '|',

         to a user space helper (

> +see above).  When collecting cores via a pipe to an application, it is
> +occasionally usefull for the collecting application to gather data about the

                useful

> +crashing process from its /proc/pid directory.  In order to do this safely, the
> +kernel must wait for the collecting process to exit, so as not to remove the
> +crashing processes proc files prematurely.  This in turn creates the possibility

            process's (?)

> +that a misbehaving userspace collecting process can block the reaping of a
> +crashed process simply by never exiting.  This sysctl defends against that.  It
> +defines how many concurrent crashing processes may be piped to user space
> +applications in parallel.  If this value is exceeded, then those crashing
> +processes above that value are noted via the kernel log and their cores are
> +skipped.  0 is a special value, indicating that unlimited processes may be
> +captured in parallel, but that no waiting will take place (i.e. the collecting
> +process is not guaranteed access to /proc/<crahing pid>/).  This value defaults

                                             <crashing pid>

> +to 0.
> +
> +==============================================================
> +
>  core_uses_pid:
>  
>  The default coredump filename is "core".  By setting


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
