Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXLEPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXLEPnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXLEPnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:43:32 -0500
Received: from mout2.freenet.de ([195.4.92.92]:46886 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXLEPna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:43:30 -0500
Message-ID: <4756C714.2040809@de.ibm.com>
Date: Wed, 05 Dec 2007 16:43:16 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de>
In-Reply-To: <20071204112327.GB20420@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Am I missing something here? I wonder how s390 works without this change?
> 
> --
> ext2 should not worry about checking sb->s_blocksize for XIP before the
> sb's blocksize actually gets set.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> Index: linux-2.6/fs/ext2/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext2/super.c
> +++ linux-2.6/fs/ext2/super.c
> @@ -844,8 +844,7 @@ static int ext2_fill_super(struct super_
> 
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
> 
> -	if ((ext2_use_xip(sb)) && ((blocksize != PAGE_SIZE) ||
> -				  (sb->s_blocksize != blocksize))) {
> +	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
>  		if (!silent)
>  			printk("XIP: Unsupported blocksize\n");
>  		goto failed_mount;
"blocksize" contains the blocksize of the device here, and 
sb->s_blocksize does contain the filesystem block size as saved in the 
super block. Xip does only work, if both do match PAGE_SIZE because it 
does'nt support multiple calls to direct_access in the get_xip_page 
address space operation. Thus we check both here, actually this was 
changed from how it looks after your patch as a bugfix where our 
tester tried a 4k filesystem on a 2k blockdev.
Did I miss something?
