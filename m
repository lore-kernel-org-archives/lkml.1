Return-Path: <linux-kernel-owner+w=401wt.eu-S933126AbZLNWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbZLNWXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbZLNWXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:23:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50401 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbZLNWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=lZZniyOapZnLZqBUyGH/MaKxPls6zhMoxHGOcaTPg3JKaf44TRqyzjVqfde1l0O0U6
         zpP33b1madAC045A42SldJIxls5+zvvXzgHA0X81m3vAcCxmUhM3QnMxxnvfxWhIl50H
         UhIcUPq6m2vz5PAKDqr6qk72cRLlTjkt5Mo6Q=
Date: Mon, 14 Dec 2009 23:23:31 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: K8 ECC error with linux-2.6.32
Message-ID: <20091214222331.GB32614@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912112239.05446.johannes.hirte@fem.tu-ilmenau.de>
 <20091211220756.GA12795@liondog.tnic>
 <200912141426.46361.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200912141426.46361.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 02:26:45PM +0100, Johannes Hirte wrote:
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
>  Northbridge Error, node 0, core: -1
> K8 ECC error.

Ok, let's see what kind of errors does your machine report. It looks
like benign GART TLB walk errors but let's verify that first. Can you
apply the following patchlet and re-trigger the problem:

--
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 713ed7d..fc4a68e 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -311,9 +311,12 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
 			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
 	} else {
-		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
+		pr_cont(", core: %d\n", fls(regs->nbsh & 0xf) - 1);
 	}
 
+	pr_err("%s: NBSL: 0x%08x, NBSL: 0x%08x\n",
+		__func__, regs->nbsl, regs->nbsh);
+
 
 	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
 

Thanks.

-- 
Regards/Gruss,
    Boris.
