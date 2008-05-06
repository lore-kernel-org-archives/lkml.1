Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbYEFT7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbYEFT7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYEFT6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:58:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54594 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbYEFT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:58:53 -0400
Subject: Re: parisc DISCONTIGMEM compile breakage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Adrian Bunk <bunk@kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506152713.GA5034@csn.ul.ie>
References: <20080506134648.GA30082@cs181133002.pp.htv.fi>
	 <20080506152713.GA5034@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 06 May 2008 14:58:47 -0500
Message-Id: <1210103927.3057.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 16:27 +0100, Mel Gorman wrote:
> On (06/05/08 16:46), Adrian Bunk didst pronounce:
> > Commit 54a6eb5c4765aa573a030ceeba2c14e3d2ea5706
> > (mm: use two zonelist that are filtered by GFP mask)
> > causes the following build error with CONFIG_DISCONTIGMEM=y
> > on parisc:
> > 
> 
> Thanks Adrian. I don't have a pa-risc cross-compiler and there isn't one
> at the usual source http://userweb.kernel.org/~akpm/cross-compilers but the
> patch below should fix it. Note that this debugging code should be deleted if
> the mm-initialisation-and-debugging framework in -mm is merged to mainline
> as it knows how to print all the zonelists where as the pa-risc equivilant
> misses the GFP_THISNODE lists.
> 
> =====
> Subject: [PATCH] Fix pa-risc DISCONTIGMEM compile breakage
>     
> PA-RISC to aid debugging prints out the zonelists setup by the system. A
> bad call to node_zonelist() breaks at compile-time. This patch fixes it.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  arch/parisc/mm/init.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> index 1f01284..b0ed709 100644
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -606,7 +606,7 @@ void show_mem(void)
>  		int i, j;
>  
>  		for (i = 0; i < npmem_ranges; i++) {
> -			zl = node_zonelist(i);
> +			zl = node_zonelist(i, 0);
>  			for (j = 0; j < MAX_NR_ZONES; j++) {

This rather doesn't look right.  The intent is for i to iterate over the
ranges (as nodes) and j to iterate over the zones to get the zonelist.
The original variable k was going over the mappings, which you replaced
with for_each_zone_zonelist.  If you use node_zonelist(i, 0) you don't
really look at the actual zones in the map.

Therefore it seems what will give the original functionality back is
actually this:

James

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 1f01284..7bc286d 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -602,15 +602,16 @@ void show_mem(void)
 
 #ifdef CONFIG_DISCONTIGMEM
 	{
-		struct zonelist *zl;
 		int i, j;
 
 		for (i = 0; i < npmem_ranges; i++) {
-			zl = node_zonelist(i);
 			for (j = 0; j < MAX_NR_ZONES; j++) {
+				struct zonelist *zl;
 				struct zoneref *z;
 				struct zone *zone;
 
+				zl = NODE_DATA(i)->node_zonelists + j;
+
 				printk("Zone list for zone %d on node %d: ", j, i);
 				for_each_zone_zonelist(zone, z, zl, j)
 					printk("[%d/%s] ", zone_to_nid(zone),


