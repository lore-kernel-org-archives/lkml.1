Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYGNWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYGNWxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYGNWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:53:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28120 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961AbYGNWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:53:40 -0400
Date: Mon, 14 Jul 2008 15:53:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mingo <mingo@redhat.com>, venkatesh.pallipadi@intel.com,
       tglx <tglx@linutronix.de>
Subject: Re: x86: add "debugpat" boot option
Message-Id: <20080714155301.2661c7b6.randy.dunlap@oracle.com>
In-Reply-To: <200807142234.m6EMYMRx031036@hera.kernel.org>
References: <200807142234.m6EMYMRx031036@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Mon, 14 Jul 2008 22:34:22 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=77b52b4c5c66175553ee59eb43f74366f1e54bde
> Commit:     77b52b4c5c66175553ee59eb43f74366f1e54bde
> Parent:     988f7b5789ccf5cfed14c72e28573a49f0cb4809
> Author:     Venki Pallipadi <venkatesh.pallipadi@intel.com>
> AuthorDate: Mon May 5 19:09:10 2008 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon May 12 21:28:07 2008 +0200
> 
>     x86: add "debugpat" boot option
>     
>     enable debug messages by a boot option "debugpat".

Is there an update to Documentation/kernel-parameters.txt for this?  (please)


>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/mm/pat.c |   27 ++++++++++++++++++++-------
>  1 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 60adbe2..1a82f4d 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -42,6 +42,19 @@ static int nopat(char *str)
>  early_param("nopat", nopat);
>  #endif
>  
> +
> +static int debug_enable;
> +static int __init pat_debug_setup(char *str)
> +{
> +	debug_enable = 1;
> +	return 0;
> +}
> +__setup("debugpat", pat_debug_setup);
> +
> +#define dprintk(fmt, arg...) \
> +	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
> +
> +
>  static u64 __read_mostly boot_pat_state;
>  
>  enum {
> @@ -279,7 +292,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
>  		struct memtype *saved_ptr;
>  
>  		if (parse->start >= end) {
> -			pr_debug("New Entry\n");
> +			dprintk("New Entry\n");
>  			list_add(&new_entry->nd, parse->nd.prev);
>  			new_entry = NULL;
>  			break;
> @@ -329,7 +342,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
>  				break;
>  			}
>  
> -			pr_debug("Overlap at 0x%Lx-0x%Lx\n",
> +			dprintk("Overlap at 0x%Lx-0x%Lx\n",
>  			       saved_ptr->start, saved_ptr->end);
>  			/* No conflict. Go ahead and add this new entry */
>  			list_add(&new_entry->nd, saved_ptr->nd.prev);
> @@ -381,7 +394,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
>  				break;
>  			}
>  
> -			pr_debug(KERN_INFO "Overlap at 0x%Lx-0x%Lx\n",
> +			dprintk("Overlap at 0x%Lx-0x%Lx\n",
>  				 saved_ptr->start, saved_ptr->end);
>  			/* No conflict. Go ahead and add this new entry */
>  			list_add(&new_entry->nd, &saved_ptr->nd);
> @@ -403,16 +416,16 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
>  	if (new_entry) {
>  		/* No conflict. Not yet added to the list. Add to the tail */
>  		list_add_tail(&new_entry->nd, &memtype_list);
> -		pr_debug("New Entry\n");
> +		dprintk("New Entry\n");
>  	}
>  
>  	if (ret_type) {
> -		pr_debug(
> +		dprintk(
>  	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
>  			start, end, cattr_name(actual_type),
>  			cattr_name(req_type), cattr_name(*ret_type));
>  	} else {
> -		pr_debug(
> +		dprintk(
>  	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s\n",
>  			start, end, cattr_name(actual_type),
>  			cattr_name(req_type));
> @@ -453,7 +466,7 @@ int free_memtype(u64 start, u64 end)
>  			current->comm, current->pid, start, end);
>  	}
>  
> -	pr_debug("free_memtype request 0x%Lx-0x%Lx\n", start, end);
> +	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
>  	return err;
>  }
>  
> --

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
