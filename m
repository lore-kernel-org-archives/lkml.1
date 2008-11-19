Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYKSEcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYKSEcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 23:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSEcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 23:32:31 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:35168 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYKSEc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 23:32:29 -0500
Date: Wed, 19 Nov 2008 10:01:21 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       anil.s.keshavamurthy@intel.com, Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] bugfix: pass aggr_kprobe to arch_remove_kprobe
Message-ID: <20081119043121.GB4053@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <200811140028.mAE0SppC021444@imap1.linux-foundation.org> <4922ED4D.8070201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4922ED4D.8070201@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 11:29:01AM -0500, Masami Hiramatsu wrote:
> Hi Andrew,
> 
> akpm@linux-foundation.org wrote:
> > The patch titled
> >      kprobes: support probing module __exit function
> > has been added to the -mm tree.  Its filename is
> >      kprobes-support-probing-module-__exit-function.patch
> 
> I found that one bug was still alive. Here is the bugfix.
> 
> Thank you,
> 
> Call arch_remove_kprobe() with aggr_kprobe instead of user specific kprobe,
> because the user specific kprobe on the gone or reused aggr_kprobe may have
> invalid arch_specific_insn.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
>  kernel/kprobes.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: 2.6-rc/kernel/kprobes.c
> ===================================================================
> --- 2.6-rc.orig/kernel/kprobes.c
> +++ 2.6-rc/kernel/kprobes.c
> @@ -766,14 +766,14 @@ static void __kprobes __unregister_kprob
>  {
>  	struct kprobe *old_p;
> 
> -	if (list_empty(&p->list) || list_is_singular(&p->list)) {
> -		if (!list_empty(&p->list)) {
> -			/* "p" is the last child of an aggr_kprobe */
> -			old_p = list_entry(p->list.next, struct kprobe, list);
> -			list_del(&p->list);
> -			kfree(old_p);
> -		}
> +	if (list_empty(&p->list))
>  		arch_remove_kprobe(p);
> +	else if (list_is_singular(&p->list)) {
> +		/* "p" is the last child of an aggr_kprobe */
> +		old_p = list_entry(p->list.next, struct kprobe, list);
> +		list_del(&p->list);
> +		arch_remove_kprobe(old_p);
> +		kfree(old_p);
>  	}
>  }
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
