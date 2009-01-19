Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZASRLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZASRLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZASRKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:10:54 -0500
Received: from doppler.zen.co.uk ([212.23.3.27]:43591 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZASRKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:10:53 -0500
Subject: Re: [PATCH 4/5] cpumask: convert drivers/net/sfc
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       linux-net-drivers@solarflare.com
In-Reply-To: <20090107195832.871689000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
	 <20090107195832.871689000@polaris-admin.engr.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Solarflare Communications
Date: Mon, 19 Jan 2009 17:08:30 +0000
Message-Id: <1232384910.31644.13.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 11:58 -0800, Mike Travis wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Impact: reduce stack usage, use new cpumask API.
> 
> Remove a cpumask from the stack.  Ben Hutchings indicated that printing
> a warning and returning 1 was acceptable for the corner case where allocation
> fails.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
> Cc: linux-net-drivers@solarflare.com
Acked-by: Ben Hutchings <bhutchings@solarflare.com>

This seems to work.

> ---
>  drivers/net/sfc/efx.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
> --- a/drivers/net/sfc/efx.c
> +++ b/drivers/net/sfc/efx.c
> @@ -854,20 +854,27 @@ static void efx_fini_io(struct efx_nic *
>   * interrupts across them. */
>  static int efx_wanted_rx_queues(void)
>  {
> -	cpumask_t core_mask;
> +	cpumask_var_t core_mask;
>  	int count;
>  	int cpu;
>  
> -	cpus_clear(core_mask);
> +	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
> +		printk(KERN_WARNING
> +		       "efx.c: allocation failure, irq balancing hobbled\n");
[...]

This is an exceedingly unlikely error case so the error message is not
that important, but if you don't mind re-spinning this then please make
it "sfc: RSS disabled due to allocation failure\n".

(Device-related log messages should also include the device address, but
I don't want to add a device parameter to the function just for that.
Maybe we should call this function just once at module init time since
the result is not device-specific.)

Ben.

