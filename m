Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYDWNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYDWNhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYDWNhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:37:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42240 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYDWNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:37:44 -0400
Message-ID: <480F3BB0.9080507@us.ibm.com>
Date: Wed, 23 Apr 2008 08:37:52 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>, arnd@arndb.de
CC: phil.el@wanadoo.fr, oprofile-list@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>, Carl Love <cel@us.ibm.com>,
       Bob Nelson <rrnelson@linux.vnet.ibm.com>
Subject: Re: [PATCH] oprofile: vma_map: fix test on overlay_tbl_offset
References: <48074F18.7050802@tiscali.nl>
In-Reply-To: <48074F18.7050802@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Offset is unsigned and when an address isn't found in the vma map
> vma_map_lookup() returns the vma physical address + 0x10000000.
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>   
Patch looks correct.  vma_map_lookup used to return 0xffffffff on a 
failed lookup, but a change was recently made to return the vma physical 
address + 0x10000000 (as Roel notes above).  There are two callers of 
vam_map_lookup: one of them correctly deals with this new return value, 
but the other (below) did not.  Roel's patch fixes that hole.  Thanks!

Arnd, can you put this into the Cell tree for pushing upstream?  Thanks.

-Maynard
> ---
> diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
> index 9a93217..1c28e2e 100644
> --- a/arch/powerpc/oprofile/cell/vma_map.c
> +++ b/arch/powerpc/oprofile/cell/vma_map.c
> @@ -229,7 +229,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
>  	 */
>  	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
>  					    aSpu, &grd_val);
> -	if (overlay_tbl_offset < 0) {
> +	if (overlay_tbl_offset >= 0x10000000) {
>  		printk(KERN_ERR "SPU_PROF: "
>  		       "%s, line %d: Error finding SPU overlay table\n",
>  		       __FUNCTION__, __LINE__);
>
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
> Don't miss this year's exciting event. There's still time to save $100. 
> Use priority code J8TL2D2. 
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list
>   


