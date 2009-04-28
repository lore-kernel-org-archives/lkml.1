Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZD1S0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZD1S0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZD1S0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:26:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbZD1SZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:25:59 -0400
Date: Tue, 28 Apr 2009 11:21:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       borislav.petkov@amd.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 14/21] amd64_edac: add msr accessors operating on all
 cpus
Message-Id: <20090428112107.af44e6db.akpm@linux-foundation.org>
In-Reply-To: <1240931173-17477-15-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
	<1240931173-17477-15-git-send-email-borislav.petkov@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 17:06:06 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index ac4e265..49c0ce0 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -3121,4 +3121,46 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
>  	return dev;
>  }
>  
> +/* stolen from msr.c - the calls in msr.c could be exported */

It would be preferable to export the functions from msr.c!  We do have a number
of exported MSR manipulation functions in x86.

> +struct msr_command {
> +	int cpu;
> +	int err;
> +	u32 reg;
> +	u32 data[2];
> +};
> +
> +static void smp_wrmsr(void *cmd_block)
> +{
> +	struct msr_command *cmd = cmd_block;
> +	wrmsr(cmd->reg, cmd->data[0], cmd->data[1]);
> +}
> +
> +static void smp_rdmsr(void *cmd_block)
> +{
> +	struct msr_command *cmd = cmd_block;
> +	rdmsr(cmd->reg, cmd->data[0], cmd->data[1]);
> +}
> +
> +static void do_wrmsr(int cpu, u32 reg, u32 eax, u32 edx)
> +{
> +	struct msr_command cmd;
> +
> +	cmd.cpu = raw_smp_processor_id();
> +	cmd.reg = reg;
> +	cmd.data[0] = eax;
> +	cmd.data[1] = edx;
> +	on_each_cpu(smp_wrmsr, &cmd, 1);
> +}
> +
> +static void do_rdmsr(int cpu, u32 reg, u32 *eax, u32 *edx)
> +{
> +	struct msr_command cmd;
> +
> +	cmd.cpu = raw_smp_processor_id();
> +	cmd.reg = reg;
> +	on_each_cpu(smp_rdmsr, &cmd, 1);
> +	*eax = cmd.data[0];
> +	*edx = cmd.data[1];
> +}

I'm all confused.  We interrupt _all_ CPUs and get each one of them to
write to cmd.data[0] and cmd.data[1].  So what we end up returning is
the result which was provided by the last CPU which got there,
whichever CPU that was.

Am I mising something, or is this all totally screwy?

