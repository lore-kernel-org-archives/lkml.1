Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZINCim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZINCim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZINCik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:38:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:58281 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZINCij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:38:39 -0400
Date: Mon, 14 Sep 2009 12:36:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com, Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] TPM: Fixup pcrs sysfs file
In-Reply-To: <20090904012818.GU4973@obsidianresearch.com>
Message-ID: <alpine.LRH.2.00.0909141236020.28766@tundra.namei.org>
References: <20090902031613.GA11464@obsidianresearch.com> <20090903165219.2f79cdc1.akpm@linux-foundation.org> <20090904012818.GU4973@obsidianresearch.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Jason Gunthorpe wrote:

> > 
> > That sounds like a fairly serious bug, and this looks like a 2.6.31
> > patch.

Any comments from the maintainers on this patch?


> To be fair, I'm not sure the pcrs sysfile provides anything terribly
> usefull.. None of the sysfs files in this driver seem to follow the
> standard one-value-one-file convention either. But, if it is going to
> be included it may as well work properly...
> 
> > Jan's build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch (in
> > -mm) simply removes the bogus BUILD_BUG_ON(). I think we might as well
> > do that within the context of your patch.
> 
> > So I end up with the below, which I propose for 2.6.31:
> 
> OK. That is fair. The tpm_cmd_params union contains a tpm_pcrread_out
> which should 'by design' ensure there is enough space.
> 
> Jan's removal of the 2nd BUILD_BUG_ON is also good.
> 
> But I notice tpm_pcr_extend also has a mis-use of the transmit_cmd
> idiom. This one functions ok because the in/out RPC message size
> happen to be the same. But lets fix it too?
> 
> Thanks,
> Jason
> 
> >From 25da64a0927088c766745763728c6bcd973d0f4e Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Date: Tue, 1 Sep 2009 21:08:55 -0600
> Subject: [PATCH] TPM: Fixup pcrs sysfs file
> 
> I'm testing the tpm_tis low level driver with a winbond WPCT200:
> $ cat caps
> Manufacturer: 0x57454300
> TCG version: 1.2
> Firmware version: 2.16
> 
> and noted that tpm_pcr_read for the pcrs sysfile file does not function.
> tpm_tis_recv returned with an error because the expected reply size was
> set to 14 (the request size) and the chip returned 30 bytes.
> 
> The TCG spec says the reply size for READ_PCR is supposed to be 30 bytes.
> 
> The length input to transmit_cmd is the size of the reply, not of the
> request.
> 
> With this change my chip reports all 23 pcrs.
> 
> Also fix tpm_pcr_extend to match the idiom of the rest of the code to
> prevent future confusion.
> 
> Finally, the BUILD_BUG_ON() is just wrong - it's testing a value which
> isn't a compile-time constant. Simply remove that assertion, the
> buffer is large enough by design.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/tpm.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index a6b52d6..5d5b324 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  
>  	cmd.header.in = pcrread_header;
>  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
> -	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
> +	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
>  			  "attempting to read a pcr value");
>  
>  	if (rc == 0)
> @@ -742,7 +741,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>   * the module usage count.
>   */
>  #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
> -#define EXTEND_PCR_SIZE 34
> +#define EXTEND_PCR_RESULT_SIZE 34
>  static struct tpm_input_header pcrextend_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(34),
> @@ -760,10 +759,9 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  		return -ENODEV;
>  
>  	cmd.header.in = pcrextend_header;
> -	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
>  	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
>  	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
> -	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
> +	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
>  			  "attempting extend a PCR value");
>  
>  	module_put(chip->dev->driver->owner);
> -- 
> 1.5.4.2
> 

-- 
James Morris
<jmorris@namei.org>
