Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZFSXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZFSXYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZFSXYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:24:30 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45191 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZFSXY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VpgPgjddzQE2SwxJtEKBVBzrOm8Da87pra4Upz1k6qV7/3PDzjesMMN2Ws41SHxVP5
         MiXCpv1p/hOmRe89E8hezdoZosQC39LUljAgBlh2+uCII9oTfNhYHBTd/sK8ZQBUM529
         PTuCq/5Ufvx0BibBhu2b0MBY8UXJTiMRoP22c=
Date: Sat, 20 Jun 2009 01:24:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 3/3] ksym_tracer: Documentation containing usage guide
	for ksym tracer
Message-ID: <20090619232427.GC4700@nowhere>
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com> <20090619172531.GD26071@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619172531.GD26071@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 10:55:31PM +0530, K.Prasad wrote:
> This patch adds documentation for the ksym tracer plugin in ftrace. It
> contains a minimal usage guide for the same.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  Documentation/trace/ksym_tracer.txt |   90 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)
> 
> Index: linux-2.6-tip.hbkpt/Documentation/trace/ksym_tracer.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6-tip.hbkpt/Documentation/trace/ksym_tracer.txt
> @@ -0,0 +1,90 @@
> +			ksym_tracer - Kernel Symbol Tracer
> +			----------------------------------
> +			K.Prasad <prasad@linux.vnet.ibm.com>
> +I. Introduction
> +===============
> +
> +ksym_tracer uses the Hardware Breakpoint interface in the kernel to monitor
> +kernel variables for memory access operations such as read and write.
> +
> +The number of kernel variables that can be monitored simultaneously is directly
> +dependant upon the available free debug registers on the processor at the time
> +of request.
> +
> +If the memory access operation on the variable added to the ksym tracer occurs,
> +a trace containing details such as symbol name, function that accessed the
> +variable, PID and cpu are logged onto the ring buffer.
> +
> +ksym tracer's use-cases can include the following:
> +- Debug memory corruption issues: Trace write operations on a variable that is
> +known to get corrupted on a system under debug
> +- Profile variables: Understand how often a variable is being used by the
> +system (such as read-mostly or write-mostly).
> +
> +II. Usage Guide
> +===============
> +
> +The following is a list of steps to monitor a kernel variable using ksym
> +tracer. It is illustrated by taking 'pid_max' as the kernel variable to be
> +monitored.
> +
> +1) Mount debugfs to a directory on your system, say /sys/kernel/debug
> +2) The memory access operations for which you want to monitor the variable can
> +be specified as follows:
> + <ksym_name>:rwx
> +The type of operation can be specified in three characters, and the valid
> +combinations are dependant on the host processor. On x86 processors, the valid
> +requests are '-w-' (write operations only) and 'rw-' (read or write
> +operations). So to monitor 'pid_max' for write the corresponding string would be
> +"pid_max:-w-".
> +3) Do 'cat available_tracers' in <debugfs_mount>/tracing/ to check if
> +'ksym_tracer' is listed as one of the available tracer. A 'ksym_trace_filter'
> +file should be available to accept the kernel symbol inputs.
> +4) echo  the kernel symbol along with the type operation string to
> +ksym_trace_filter.
> +e.g. echo pid_max:-w- > ksym_trace_filter
> +Lookout for any error messages in the shell after the echo and in dmesg that
> +indicates a failure of the request.
> +5) Make sure that tracing is enabled by checking for 1 in 'tracing_enabled'
> +file, if not 'echo 1 > tracing_enabled' to start tracing.
> +
> +Now a breakpoint over the kernel symbol (pid_max in this example) is active and
> +is monitoring for any operations of the requested type. Upon such an operation,
> +a trace containing the following information is logged and is available in the
> +'trace' file.
> +
> +For instance, in case of the above example, the 'trace' file looks as shown
> +below:
> +# echo 32621 > /proc/sys/kernel/pid_max
> +# cat trace
> +# tracer: ksym_tracer
> +#
> +#       TASK-PID      CPU#      Symbol         Type    Function
> +#          |           |          |              |         |
> +bash            3027  2   pid_max               W  do_proc_dointvec_minmax_conv
> +#
> +
> +In order to remove the trace, the kernel symbol should be echoed with all
> +operators set to '-' like this '<ksym_name>:---'. For example,
> +echo pid_max:--- > ksym_trace_filter.
> +
> +Alternatively if you choose to unregister all requests simultaneously you may
> +do either of the following;
> +echo > ksym_trace_filter
> +echo *:--- > ksym_trace_filter
> +
> +The ksym tracer also provides a consolidated hit-counter that indicates the
> +number of times a variable was subjected to the specified memory access
> +operation. This is available in the file
> +<debugfs_mount>/tracing/trace_stat/ksym_tracer.
> +
> +Limitations
> +------------
> +The known limitations of the ksym tracer are listed below. Efforts are
> +through to support many of feature limitations.
> +
> +- ksym tracer can monitor only primary data types (such as int, char) and not
> +arrays or instances or members of any structure.
> +- Symbols that are defined in modules are not resolved by ksym tracer's symbol
> +resolution mechanism.
> +- Monitoring either read or write only is not supported on all processors.
> 


Nice documentation, thanks!

