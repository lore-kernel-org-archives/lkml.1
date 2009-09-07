Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZIGUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZIGUAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZIGUAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:00:38 -0400
Received: from r00tworld.com ([212.85.137.21]:54806 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZIGUAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:00:38 -0400
From: pageexec@freemail.hu
To: linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Mon, 07 Sep 2009 20:56:30 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 2/6] firewire: ohci: fix Self ID Count register mask (safeguard against buffer overflow)
Reply-to: pageexec@freemail.hu
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <4AA5575E.6620.3D14E038@pageexec.freemail.hu>
In-reply-to: <tkrat.e40ffd9ba52485e5@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>, <tkrat.e40ffd9ba52485e5@s5r6.in-berlin.de>
X-mailer: Pegasus Mail for Windows (4.51)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Mon, 07 Sep 2009 20:56:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Sep 2009 at 18:49, Stefan Richter wrote:

added stable as .30 is affected, possibly older kernels as well, i didn't check.

> The selfIDSize field of Self ID Count is 9 bits wide, and we are only
> interested in the high 8 bits.  Fix the mask accordingly.  The
> previously too large mask didn't do damage though because the next few
> bits in the register are reserved and therefore zero with presently
> existing hardware.

unless something prevents one from creating a malicious device,
i wouldn't be so sure about all existing hw ;).

> Also, check for the maximum possible self ID count of 252 (according to
> OHCI 1.1 clause 11.2 and IEEE 1394a-2000 clause 4.3.4.1, i.e. up to four
> self IDs of up to 63 nodes, even though IEEE 1394 up to edition 2008
> defines only up to three self IDs per node).  More than 252 self IDs
> would only happen if the self ID receive DMA unit malfunctioned, which
> would likely be caught by other self ID buffer checks.  However, check
> it early to be sure.  More than 253 quadlets would overflow the Topology
> Map CSR.
> 
> Reported-By: PaX Team
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/ohci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.31-rc9/drivers/firewire/ohci.c
> ===================================================================
> --- linux-2.6.31-rc9.orig/drivers/firewire/ohci.c
> +++ linux-2.6.31-rc9/drivers/firewire/ohci.c
> @@ -1279,8 +1279,8 @@ static void bus_reset_tasklet(unsigned l
>  	 * the inverted quadlets and a header quadlet, we shift one
>  	 * bit extra to get the actual number of self IDs.
>  	 */
> -	self_id_count = (reg >> 3) & 0x3ff;
> -	if (self_id_count == 0) {
> +	self_id_count = (reg >> 3) & 0xff;
> +	if (self_id_count == 0 || self_id_count > 252) {
>  		fw_notify("inconsistent self IDs\n");
>  		return;
>  	}
> 
> -- 
> Stefan Richter
> -=====-==--= =--= --==-
> http://arcgraph.de/sr/
> 
> 



