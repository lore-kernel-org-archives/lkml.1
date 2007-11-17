Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbXKQUiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbXKQUiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXKQUiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:38:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38753 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXKQUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:38:00 -0500
Date: Sat, 17 Nov 2007 12:37:05 -0800
From: Greg KH <greg@kroah.com>
To: David <david@unsolicited.net>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: gregkh@suse.de, Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071117203705.GA21045@kroah.com>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473F498D.9090703@unsolicited.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 08:05:33PM +0000, David wrote:
> Greg KH wrote:
> > On Sat, Nov 17, 2007 at 07:21:35PM +0100, Javier Kohen wrote:
> >   
> >> I upgraded today from 2.6.23 to 2.6.23.8 and started seeing a lot of
> >> these in the logs:
> >>     
> >
> > Can you see if the problem showed up in 2.6.23.2 or .3 to help narrow
> > this down?
> >   
> This is the culprit, reverting fixes the issue.
> 
> Cheers
> David
> 
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -80,10 +80,11 @@ void softlockup_tick(void)
>         print_timestamp = per_cpu(print_timestamp, this_cpu);
> 
>         /* report at most once a second */
> -       if (print_timestamp < (touch_timestamp + 1) ||
> -               did_panic ||
> -                       !per_cpu(watchdog_task, this_cpu))
> +       if ((print_timestamp >= touch_timestamp &&
> +                       print_timestamp < (touch_timestamp + 1)) ||
> +                       did_panic || !per_cpu(watchdog_task, this_cpu)) {
>                 return;
> +       }
> 
>         /* do not print during early bootup: */
>         if (unlikely(system_state != SYSTEM_RUNNING)) {
> 


Great, thanks for tracking this down.

Ingo, this corrisponds to changeset
a115d5caca1a2905ba7a32b408a6042b20179aaa in mainline.  Is that patch
incorrect?  Should this patch in the -stable tree be reverted?

thanks,

greg k-h
