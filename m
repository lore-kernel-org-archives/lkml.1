Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYFDPfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYFDPfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbYFDPfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:35:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14630 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbYFDPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:35:29 -0400
Date: Wed, 4 Jun 2008 08:33:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       clameter@sgi.com, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
Message-Id: <20080604083318.792fc5ba.randy.dunlap@oracle.com>
In-Reply-To: <4846AE30.8000302@cosmosbay.com>
References: <48439916.2070108@cosmosbay.com>
	<20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<4844BC75.8040705@cosmosbay.com>
	<20080603144054.973284bb.akpm@linux-foundation.org>
	<4846AE30.8000302@cosmosbay.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 17:01:04 +0200 Eric Dumazet wrote:

> Here is an updated patch.
> 
> It now allocates the array in vmalloc_open().
> If this allocation fails, we just proceed and dont provide NUMA information.
> 
> I included missing documentation for /proc/vmallocinfo as well.
> 
> 
> [PATCH] vmallocinfo: Add NUMA informations
> 
> Christoph recently added /proc/vmallocinfo file to get information about vmalloc allocations.
> 
> This patch adds NUMA specific information, giving number of pages allocated on each memory node.
> 
> This should help to check that vmalloc() is able to respect NUMA policies.
> 
> Example of output on a four nodes machine (one cpu per node)
> 
> 1) network hash tables are evenly spreaded on four nodes (OK)
>  (Same point for inodes and dentries hash tables)
> 2) iptables tables (x_tables) are correctly allocated on each cpu node (OK).
> 3) sys_swapon() allocates its memory from one node only.
> 4) each loaded module is using memory on one node.
> 
> Sysadmins could tune their setup to change points 3) and 4) if necessary.
> 
> grep "pages="  /proc/vmallocinfo
> [snip]

> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  Documentation/filesystems/proc.txt |   44 +++++++++++++++++++++++++++
>  fs/proc/proc_misc.c                |   15 +++++++--
>  mm/vmalloc.c                       |   20 ++++++++++++
>  3 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index dbc3c6a..b707d9a 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -296,6 +296,7 @@ Table 1-4: Kernel info in /proc
>   uptime      System uptime                                     
>   version     Kernel version                                    
>   video	     bttv info of video resources			(2.4)
> + vmallocinfo Show vmalloced areas
>  ..............................................................................
>  
>  You can,  for  example,  check  which interrupts are currently in use and what
> @@ -550,6 +551,49 @@ VmallocTotal: total size of vmalloc memory area
>   VmallocUsed: amount of vmalloc area which is used
>  VmallocChunk: largest contigious block of vmalloc area which is free
>  
> +..............................................................................
> +
> +vmallocinfo:
> +
> +Provides information about vmalloced/vmaped areas. One line per area,
> +containing the virtual address range of the area, size in bytes,
> +caller information of the creator, and optional informations depending

s/informations/information/

> +on the kind of area :
> +
> + pages=nr    number of pages
> + phys=addr   if a physical address was specified
> + ioremap     I/O mapping (ioremap() and friends)
> + vmalloc     vmalloc() area
> + vmap        vmap()ed pages
> + user        VM_USERMAP area
> + vpages      buffer for pages pointers was vmalloced (huge area)
> + N<node>=nr  (Only on NUMA kernels)
> +             Number of pages allocated on memory node <node>


---
~Randy
