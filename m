Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbYKYO2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbYKYO2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYKYO2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:28:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58456 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYKYO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:28:43 -0500
Date: Tue, 25 Nov 2008 09:27:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, wim@iguana.be,
       stable@kernel.org, Thomas.Mingarelli@hp.com
Subject: Re: [PATCH] [WATCHDOG] Fix kdump when using hpwdt
Message-ID: <20081125142751.GD341@redhat.com>
References: <1227446124-10856-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227446124-10856-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 02:15:24PM +0100, Bernhard Walle wrote:
> When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
> opened), then kdump does not work. The panic kernel either does not start at
> all or crash in various places.
> 
> The problem is that hpwdt_pretimeout is registered with register_die_notifier()
> with the highest possible priority. Because it returns NOTIFY_STOP, the
> crash_nmi_callback which is also registered with register_die_notifier() is
> never executed. This causes the shutdown of other CPUs to fail.
> 
> Reverting the order is no option: The crash_nmi_callback executes HLT and so
> never returns normally. Because of that, it must be executed as last notifier,
> which currently is done.
> 
> So, that patch returns NOTIFY_OK to keep the crash_nmi_callback executed.

Hi Bernhard,

Why does this handler need to run after a crash? IOW, even if kdump NMI
handler halts the cpu, and this handler never gets a chance to run, is 
that an issue.

I am getting back to previous discussion of dropping the priority of this
hpwdt. You mentioned that dropping priority will not work as kdump handler
hlts the cpus.  But my point is that kdump handler is registered
dynamically only after a system crash. Does hpwdt need to run then?

Above patch as such should fix the kdump issue (assuming the handler of
this driver will always return back), but I don't understand why does 
it need to run after a crash?

Thanks
Vivek

> 
 > 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/watchdog/hpwdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
> index a3765e0..21fe202 100644
> --- a/drivers/watchdog/hpwdt.c
> +++ b/drivers/watchdog/hpwdt.c
> @@ -482,7 +482,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
>  			"Management Log for details.\n");
>  	}
>  
> -	return NOTIFY_STOP;
> +	return NOTIFY_OK;
>  }
>  
>  /*
> -- 
> 1.6.0.2
