Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZIPGwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZIPGwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZIPGwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:52:10 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:60365 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZIPGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:52:09 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 02:52:09 EDT
Date: Wed, 16 Sep 2009 08:47:08 +0200
From: Kurt Roeckx <kurt@roeckx.be>
To: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
Message-ID: <20090916064708.GA25472@roeckx.be>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
 <200909080112.14997.rjw@sisk.pl>
 <20090908194653.GA3517@roeckx.be>
 <200909102259.15144.rjw@sisk.pl>
 <alpine.DEB.1.00.0909151642100.24059@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0909151642100.24059@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 04:45:37PM -0700, David Rientjes wrote:
> On Thu, 10 Sep 2009, Rafael J. Wysocki wrote:
> 
> > > So I did a biset, and this is the result:
> > > $ git bisect good
> > > 0e64a0c982c06a6b8f5e2a7f29eb108fdf257b2f is first bad commit
> 
> 0e64a0c has this cleanup, which isn't equivalent to the previous code:

Please look at the patch I attached to the bug report.  There is
other code that is not equivalent.  It's in comment #17:
http://bugzilla.kernel.org/show_bug.cgi?id=13780#c17

And the patch itself:
http://bugzilla.kernel.org/attachment.cgi?id=23048

This patch fixes my problem.

> @@ -779,11 +834,12 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
>  		goto err_out;
>  	}
>  
> -	if ((data->acpi_data.control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
> -		(data->acpi_data.status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
> +	space_id = data->acpi_data.control_register.space_id;
> +	if ((space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
> +		(space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
>  		dprintk("Invalid control/status registers (%x - %x)\n",
>  			data->acpi_data.control_register.space_id,
> -			data->acpi_data.status_register.space_id);
> +			space_id);
>  		goto err_out;
>  	}
>  
> This got fixed in 2c701b1 in 2.6.31-rc8, so this is most likely the 
> problem that Kurt was encountering.
> 
> Kurt, could you try 2.6.31 and see if you still experience the issue?  If 
> not, this can be closed.

I also noticed this difference (comment #18), patched it, and
tried it.  This is not the issue.  Also note that I tested the
2.6.31-rc9 kernel which still had the problem.

The bug report might be a little confusing since after comment #18
there are older mails pasted in the bug report.


Kurt

