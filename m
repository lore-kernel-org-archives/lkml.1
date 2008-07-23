Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYGWTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYGWTqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYGWTqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:46:30 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62220 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYGWTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:46:29 -0400
X-BigFish: VPS-11(zz1432R98dR936eT62a3L1805M78fbpzz10d3izzz32i6bh87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4H5KW-02-44F-01
Date: Wed, 23 Jul 2008 21:46:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: rrichter@elbe.amd.com, Barry Kasindorf <barry.kasindorf@amd.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Carl Love <cel@us.ibm.com>
Subject: Re: [PATCH 10/24] x86/oprofile: Add IBS support for AMD CPUs, IBS
	buffer handling routines
Message-ID: <20080723194608.GH17134@erda.amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-11-git-send-email-robert.richter@amd.com> <48878485.3090909@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48878485.3090909@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 Jul 2008 19:46:16.0311 (UTC) FILETIME=[C51EE870:01C8ECFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.08 14:20:37, Maynard Johnson wrote:
> Robert Richter wrote:

[...]

> > @@ -252,6 +253,71 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
> >  	oprofile_add_ext_sample(pc, regs, event, is_kernel);
> >  }
> >
> > +#define MAX_IBS_SAMPLE_SIZE	14
> > +static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
> > +	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
> > +{
> > +	struct task_struct *task;
> > +
> > +	cpu_buf->sample_received++;
> > +
> > +	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
> > +		cpu_buf->sample_lost_overflow++;
> > +		return 0;
> > +	}
> > +
> > +	is_kernel = !!is_kernel;
> > +
> > +	/* notice a switch from user->kernel or vice versa */
> > +	if (cpu_buf->last_is_kernel != is_kernel) {
> > +		cpu_buf->last_is_kernel = is_kernel;
> > +		add_code(cpu_buf, is_kernel);
> > +	}
> > +
> > +	/* notice a task switch */
> > +	if (!is_kernel) {
> > +		task = current;
> > +
> > +		if (cpu_buf->last_task != task) {
> > +			cpu_buf->last_task = task;
> > +			add_code(cpu_buf, (unsigned long)task);
> > +		}
> > +	}
> > +
> > +	add_code(cpu_buf, ibs_code);
> > +	add_sample(cpu_buf, ibs[0], ibs[1]);
> > +	add_sample(cpu_buf, ibs[2], ibs[3]);
> > +	add_sample(cpu_buf, ibs[4], ibs[5]);
> > +
> > +	if (ibs_code == IBS_OP_BEGIN) {
> > +	add_sample(cpu_buf, ibs[6], ibs[7]);
> > +	add_sample(cpu_buf, ibs[8], ibs[9]);
> > +	add_sample(cpu_buf, ibs[10], ibs[11]);
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> >   
> I'm concerned about the arch-specific nature of the "ibs" functions
> above being placed here in the generic portion of the oprofile driver. 
> Better to generalize the external function defined below (and rename it)
> by invoking arch-specific handlers via function pointers.  Hopefully
> find a way to move the arch-specific code back to where it belongs,
> under the appropriate arch/ directory.

Yes, this is true. The plan is to rework the code so that IBS is only
in op_model_amd.c. The only thing visible outside will then be the
code macros introduced in patch #9. The code will change into generic
with something like add_u64(). This function will then be called from
the IBS handler.

This is also the reason I did not add op_amd_handle_ibs() to the API
definition in linux/oprofile.h.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

