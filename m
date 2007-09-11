Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbXIKNOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbXIKNOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXIKNOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:14:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:42635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXIKNOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:14:46 -0400
Date: Tue, 11 Sep 2007 15:14:45 +0200
From: Olaf Dabrunz <od@suse.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070911131445.GA17460@suse.de>
Mail-Followup-To: Bernhard Walle <bwalle@suse.de>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070909083914.488571169@strauss.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-Sep-07, Bernhard Walle wrote:
> If there are multiple occurrences, then the last one is taken.  The advantage
> is that if you have a bootloader like lilo or elilo which allows you to append
> a command line parameter but not to remove one (like in GRUB), then you can add
> another crashkernel value for testing at the boot command line and this one
> overwrites the command line in the configuration then.

AFAIK it is the other way round: the lilo configuration-parameter
"append" appends the kernel parameters in the configuration to the
parameters given by the user on the kernel command line.

So the parameters set by the user during boot appear first on the
command line.

> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  include/linux/kexec.h |    2 
>  kernel/kexec.c        |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 141 insertions(+)
> 
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -179,6 +179,8 @@ extern note_buf_t *crash_notes;
>  extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
>  extern unsigned int vmcoreinfo_size;
>  extern unsigned int vmcoreinfo_max_size;
> +int parse_crashkernel(char *cmdline, unsigned long long system_ram,
> +		unsigned long long *crash_size, unsigned long long *crash_base);
>  
>  [...]
>  
> +int parse_crashkernel(char 		 *cmdline,
> +		      unsigned long long system_ram,
> +		      unsigned long long *crash_size,
> +		      unsigned long long *crash_base)
> +{
> +	char 	*p = cmdline, *ck_cmdline = NULL;
> +	char	*first_colon, *first_space;
> +
> +	/* find crashkernel and use the last one if there are more */
> +	p = strstr(p, "crashkernel=");
> +	while (p) {
> +		ck_cmdline = p;
> +		p = strstr(p+1, "crashkernel=");
> +	}
> +

So perhaps something like this instead:

+	/* find crashkernel and use the first one if there are more */
+	p = strstr(p, "crashkernel=");
+	ck_cmdline = p;

> +	if (!ck_cmdline)
> +		return -EINVAL;
> +
> +	ck_cmdline += 12; /* strlen("crashkernel=") */
> +
> +	/*
> +	 * if the commandline contains a ':', then that's the extended
> +	 * syntax -- if not, it must be the classic syntax
> +	 */
> +	first_colon = strchr(ck_cmdline, ':');
> +	first_space = strchr(ck_cmdline, ' ');
> +	if (first_colon && (!first_space || first_colon < first_space))
> 
> [...]

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

