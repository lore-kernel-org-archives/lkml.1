Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZK0W3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZK0W3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZK0W3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:29:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48122 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZK0W3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:29:38 -0500
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20091125165510.6073.48721.stgit@harusame>
	<20091125165541.6073.43956.stgit@harusame>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 27 Nov 2009 14:29:23 -0800
In-Reply-To: <20091125165541.6073.43956.stgit@harusame> (Masami Hiramatsu's message of "Wed\, 25 Nov 2009 11\:55\:41 -0500")
Message-ID: <m1my27txdo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Masami Hiramatsu <mhiramat@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH -tip v6 04/11] kprobes: Jump optimization sysctl interface
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <mhiramat@redhat.com> writes:

> Add /proc/sys/debug/kprobes-optimization sysctl which enables and disables
> kprobes jump optimization on the fly for debugging.
>
> Changes in v6:
> - Update comments and coding style.
>

This will break when it hits the linux-next.  As ctl_name has been
removed in the sysctl tree.  Not setting ctl_name is equivalent
to setting ctl_name = CTL_UNNUMBERED.  It is 0 in both cases.
So you can safely drop touches of ctl_name.

Ideally you would also call register_sysctl_paths from kernel/kprobes.c
and not add to the ifdef horror that is kernel/sysctl.c but that
is probably more trouble than it is worth right now.    One way or
another there is going to be at least a minor conflict when this code 
merges with the sysctl tree.

>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
> @@ -1621,6 +1622,18 @@ static struct ctl_table debug_table[] = {
>  		.proc_handler	= proc_dointvec
>  	},
>  #endif
> +#if defined(CONFIG_OPTPROBES)
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Please remove this line.
> +		.procname	= "kprobes-optimization",
> +		.data		= &sysctl_kprobes_optimization,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_kprobes_optimization_handler,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
> +#endif
>  	{ .ctl_name = 0 }
>  };


Eric
