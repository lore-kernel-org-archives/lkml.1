Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYAWBL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYAWBL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYAWBLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:11:50 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:44391 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751698AbYAWBLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:11:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rk470HwCqhAjmf/qEFmYy59fM/pjG1DoLUZB69KODHm99xb/Suq/DKAGTpXZbnk6z1ytoAmjR5wzR9hK1glU4LxLNNd9pxeD8+qP/Re/WzsbuSWkfaXkWzZNg+D6Mew+FItqKZ3DQpn5VcXREN0yJkAUl6tI8G8EpwhU+jpYXZM=  ;
X-YMail-OSG: kTtH_rYVM1mh2vNLFVhqZXzQ.2s6Ub0m.WejSkULjU5jiZGOIK2tUSYBfMbnvjsPtF8mf9p8NQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] x86: test case for the RODATA config option
Date: Wed, 23 Jan 2008 12:11:41 +1100
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
In-Reply-To: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231211.41750.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008 09:44, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: x86: test case for the RODATA config option
>
> This patch adds a test module for the DEBUG_RODATA config
> option to make sure change_page_attr() did indeed make
> "const" data read only.
>
> This testcase both tests the DEBUG_RODATA code as well as
> the change_page_attr() code for correct operation.
>
> When the tests/ patch gets merged, this module should move
> to the tests/ directory.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/Kconfig.debug        |    8 +++++
>  arch/x86/kernel/Makefile_32   |    1
>  arch/x86/kernel/Makefile_64   |    2 +
>  arch/x86/kernel/test_rodata.c |   65
> ++++++++++++++++++++++++++++++++++++++++++ arch/x86/mm/init_32.c         | 
>   3 +
>  arch/x86/mm/init_64.c         |    3 +
>  6 files changed, 82 insertions(+)
>
> Index: linux-2.6.24-rc8/arch/x86/Kconfig.debug
> ===================================================================
> --- linux-2.6.24-rc8.orig/arch/x86/Kconfig.debug
> +++ linux-2.6.24-rc8/arch/x86/Kconfig.debug
> @@ -57,6 +57,14 @@ config DEBUG_RODATA
>  	  portion of the kernel code won't be covered by a 2MB TLB anymore.
>  	  If in doubt, say "N".
>
> +config DEBUG_RODATA_TEST
> +	tristate "Testcase for the DEBUG_RODATA feature"
> +	depends on DEBUG_RODATA && m
> +	help
> +	  This option enables a testcase for the DEBUG_RODATA
> +	  feature as well as for the change_page_attr() infrastructure.
> +	  If in doubt, say "N"
> +
>  config 4KSTACKS
>  	bool "Use 4Kb for kernel stacks instead of 8Kb"
>  	depends on DEBUG_KERNEL
> Index: linux-2.6.24-rc8/arch/x86/mm/init_32.c
> ===================================================================
> --- linux-2.6.24-rc8.orig/arch/x86/mm/init_32.c
> +++ linux-2.6.24-rc8/arch/x86/mm/init_32.c
> @@ -790,6 +790,9 @@ static int noinline do_test_wp_bit(void)
>
>  #ifdef CONFIG_DEBUG_RODATA
>
> +const int rodata_test_data;
> +EXPORT_SYMBOL_GPL(rodata_test_data);
> +
>  void mark_rodata_ro(void)
>  {
>  	unsigned long start = PFN_ALIGN(_text);
> Index: linux-2.6.24-rc8/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.24-rc8.orig/arch/x86/mm/init_64.c
> +++ linux-2.6.24-rc8/arch/x86/mm/init_64.c
> @@ -590,6 +590,9 @@ void free_initmem(void)
>
>  #ifdef CONFIG_DEBUG_RODATA
>
> +const int rodata_test_data = 5;

I guess this should match the 32-bit case, and be zero instead of
5?

Can you disallow building as a module, and put this in the test
code? It could be run from the end of mark_rodata_ro()...
