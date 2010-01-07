Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729Ab0AGWh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0AGWh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670Ab0AGWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:37:23 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:51481 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab0AGWhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:37:20 -0500
Date: Thu, 7 Jan 2010 14:36:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, rakib.mullick@gmail.com
Subject: Re: + hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch added
 to -mm tree
Message-Id: <20100107143651.2fa73662.randy.dunlap@oracle.com>
In-Reply-To: <201001072218.o07MIPNm020870@imap1.linux-foundation.org>
References: <201001072218.o07MIPNm020870@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B466210.0113:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010 14:18:25 -0800 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      hugetlb: fix section mismatch warning in hugetlb.c
> has been added to the -mm tree.  Its filename is
>      hugetlb-fix-section-mismatch-warning-in-hugetlbc.patch
> 
> 
> ------------------------------------------------------
> Subject: hugetlb: fix section mismatch warning in hugetlb.c
> From: Rakib Mullick <rakib.mullick@gmail.com>
> 
> Since hugetlb_sysfs_add_hstate()'s caller is __init and it isn't
> referencing from any other function, we can do this.

Hi,

I looked at this section mismatch warning too.
Maybe I'm reading too much into it (so I have cc-ed linux-mm),
but it looks like hugetlbfs supports callbacks for node
hotplug & unplug:

in hugetlb_register_all_nodes():

	/*
	 * Let the node sysdev driver know we're here so it can
	 * [un]register hstate attributes on node hotplug.
	 */
	register_hugetlbfs_with_node(hugetlb_register_node,
				     hugetlb_unregister_node);

If so, then hugetlb_register_node() could be called at any time
(like after system init), and it would then call
hugetlb_sysfs_add_hstate(), which would be bad.

Am I misunderstanding the hotplug callbacks?
or can you explain just a bit better, please?
Thanks.


> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/hugetlb.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN mm/hugetlb.c~hugetlb-fix-section-mismatch-warning-in-hugetlbc mm/hugetlb.c
> --- a/mm/hugetlb.c~hugetlb-fix-section-mismatch-warning-in-hugetlbc
> +++ a/mm/hugetlb.c
> @@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
>   * Register hstate attributes for a single node sysdev.
>   * No-op if attributes already registered.
>   */
> -void hugetlb_register_node(struct node *node)
> +void __init hugetlb_register_node(struct node *node)
>  {
>  	struct hstate *h;
>  	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
> @@ -1683,7 +1683,7 @@ void hugetlb_register_node(struct node *
>   * sysdevs of nodes that have memory.  All on-line nodes should have
>   * registered their associated sysdev by this time.
>   */
> -static void hugetlb_register_all_nodes(void)
> +static void __init hugetlb_register_all_nodes(void)
>  {
>  	int nid;
>  
> @@ -1712,7 +1712,7 @@ static struct hstate *kobj_to_node_hstat
>  
>  static void hugetlb_unregister_all_nodes(void) { }
>  
> -static void hugetlb_register_all_nodes(void) { }
> +static void __init hugetlb_register_all_nodes(void) { }
>  
>  #endif
>  
> _


---
~Randy
