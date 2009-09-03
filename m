Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbZICXyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbZICXyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZICXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:54:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575AbZICXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:54:21 -0400
Date: Thu, 3 Sep 2009 16:52:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com, Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] TPM: Fixup pcrs sysfs file
Message-Id: <20090903165219.2f79cdc1.akpm@linux-foundation.org>
In-Reply-To: <20090902031613.GA11464@obsidianresearch.com>
References: <20090902031613.GA11464@obsidianresearch.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 21:16:13 -0600
Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

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
> The TCG spec says the reply size is supposed to be 30 bytes.
> 
> First, the BUILD_BUG_ON was surely never correct, testing a run time
> value in big endian with that macro is just wrong. I belive the intended
> test was to ensure that the cmd buffer has enough space to store the
> reply.
> 
> Second, the length input to transmit_cmd is the size of the reply, not
> of the request. It should be 30 for READ_PCR.
> 
> With this change my chip reports all 23 pcrs.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/tpm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index a6b52d6..8ba0187 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -696,8 +696,8 @@ int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  
>  	cmd.header.in = pcrread_header;
>  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
> -	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
> +	BUILD_BUG_ON(sizeof(cmd) < READ_PCR_RESULT_SIZE);
> +	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
>  			  "attempting to read a pcr value");
>  
>  	if (rc == 0)

That sounds like a fairly serious bug, and this looks like a 2.6.31
patch.

Jan's build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch (in
-mm) simply removes the bogus BUILD_BUG_ON(). I think we might as well
do that within the context of your patch.

So I end up with the below, which I propose for 2.6.31:



From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

I'm testing the tpm_tis low level driver with a winbond WPCT200:

$ cat caps
Manufacturer: 0x57454300
TCG version: 1.2
Firmware version: 2.16

and noted that tpm_pcr_read for the pcrs sysfile file does not function. 
tpm_tis_recv returned with an error because the expected reply size was
set to 14 (the request size) and the chip returned 30 bytes.

The TCG spec says the reply size is supposed to be 30 bytes.

The length input to transmit_cmd is the size of the reply, not of the
request.  It should be 30 for READ_PCR.

With this change my chip reports all 23 pcrs.

Also, the BUILD_BUG_ON() is just wrong - it's testing a value which isn't
a compile-time constant.  Simply remove that assertion.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fixup-pcrs-sysfs-file drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fixup-pcrs-sysfs-file
+++ a/drivers/char/tpm/tpm.c
@@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,,
 			  "attempting to read a pcr value");
 
 	if (rc == 0)
_

