Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYHMDs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYHMDs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYHMDsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:48:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8406 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbYHMDst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ua8TiL9j4A9RusH0w6D9LymA/WVWToKdX/30Xr3A0axRCMnc3+ulQY/ushTNVXsr4M
         Ectj+hZ/tfadkoDHxOFjYONOsj0XNduuibuLvNKEljdO1xCdrttwTR9nenx8x+oKlpNq
         7hITxdmq5jqqYhGCPz4igu/2JuIXnwaUK1Ff8=
Message-ID: <eada2a070808122048s151d2ea5hb92fc654f4751c44@mail.gmail.com>
Date: Tue, 12 Aug 2008 20:48:49 -0700
From: "Tim Pepper" <tpepper@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/7] lockdep: Fix combinatorial explosion in lock subgraph traversal.
Cc: "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org,
       jeremy@goop.org, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <1217925973.3589.108.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080804130317.994042639@chello.nl>
	 <20080804131011.749503624@chello.nl>
	 <20080805.013445.30774221.davem@davemloft.net>
	 <1217925973.3589.108.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 1:46 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2008-08-05 at 01:34 -0700, David Miller wrote:
>> See:
>>
>> http://marc.info/?l=linux-kernel&m=121758260130275&w=2
>
> Probably missed that, thanks for reminding me.
>
> Andrew, please pick up:
>
> ---
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 1 Aug 2008 11:23:50 +0200
> Subject: [PATCH] lockdep: build fix
>
> fix:
>
>  kernel/built-in.o: In function `lockdep_stats_show':
>  lockdep_proc.c:(.text+0x3cb2f): undefined reference to `lockdep_count_forward_deps'
>  kernel/built-in.o: In function `l_show':
>  lockdep_proc.c:(.text+0x3d02b): undefined reference to `lockdep_count_forward_deps'
>  lockdep_proc.c:(.text+0x3d047): undefined reference to `lockdep_count_backward_deps'
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/lockdep_internals.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> index 68d44ec..f5c6a14 100644
> --- a/kernel/lockdep_internals.h
> +++ b/kernel/lockdep_internals.h
> @@ -53,8 +53,21 @@ extern unsigned int nr_process_chains;
>  extern unsigned int max_lockdep_depth;
>  extern unsigned int max_recursion_depth;
>
> +#ifdef CONFIG_PROVE_LOCKING
>  extern unsigned long lockdep_count_forward_deps(struct lock_class *);
>  extern unsigned long lockdep_count_backward_deps(struct lock_class *);
> +#else
> +static inline unsigned long
> +lockdep_count_forward_deps(struct lock_class *class)
> +{
> +       return 0;
> +}
> +static inline unsigned long
> +lockdep_count_backward_deps(struct lock_class *class)
> +{
> +       return 0;
> +}
> +#endif
>
>  #ifdef CONFIG_DEBUG_LOCKDEP
>  /*
>
>


Looks like this is needed for 2.6.27-rc3 to build here.  Also noted,
regardless of the patch:

kernel/lockdep.c:580: warning: 'print_lock_dependencies' defined but not used



Tim
