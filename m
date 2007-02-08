Return-Path: <linux-kernel-owner+w=401wt.eu-S1422954AbXBHKNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954AbXBHKNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 05:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423061AbXBHKNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 05:13:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36343 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422954AbXBHKNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 05:13:06 -0500
Date: Thu, 8 Feb 2007 02:12:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Lukasz Trabinski <lukasz@wsisiz.edu.pl>, linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
Message-Id: <20070208021212.a26ead6e.akpm@linux-foundation.org>
In-Reply-To: <20070208095612.GA9977@elte.hu>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl>
	<20070207204745.a2640c43.akpm@linux-foundation.org>
	<20070208080644.GA14579@elte.hu>
	<200702081016.21124.dada1@cosmosbay.com>
	<20070208095612.GA9977@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 10:56:12 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > This reminds me the current problem in close_files()
> >  code, where we trigger soft lockup quite regularly.
> > 
> > Is there any chance/interest we can solve the issue Andrew had with 
> > this patch ?
> > 
> > http://lkml.org/lkml/2006/5/2/273
> 
> yes - the -rt patch included the patch below for more than 2 years. 
> (note that this one is even more finegrained)
> 
> 	Ingo
> 
> Index: linux/kernel/exit.c
> ===================================================================
> --- linux.orig/kernel/exit.c
> +++ linux/kernel/exit.c
> @@ -431,8 +433,10 @@ static void close_files(struct files_str
>  		while (set) {
>  			if (set & 1) {
>  				struct file * file = xchg(&fdt->fd[i], NULL);
> -				if (file)
> +				if (file) {
>  					filp_close(file, files);
> +					cond_resched();
> +				}
>  			}
>  			i++;
>  			set >>= 1;

That doesn't hang like the other patch did on 2.6.17-rc3.

Very mysterious.
