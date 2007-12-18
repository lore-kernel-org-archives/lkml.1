Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbXLRRuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbXLRRuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXLRRuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:50:01 -0500
Received: from waste.org ([66.93.16.53]:45713 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbXLRRuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:50:00 -0500
Date: Tue, 18 Dec 2007 11:48:45 -0600
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, protasnb@gmail.com,
       tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071218174845.GV17536@waste.org>
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217133631.5bbc5842@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 01:36:31PM -0800, Arjan van de Ven wrote:
> On Mon, 17 Dec 2007 18:23:31 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Arjan van de Ven <arjan@linux.intel.com> wrote:
> > 
> > > The http://www.kerneloops.org website collects kernel oops and
> > > warning reports from various mailing lists and bugzillas; below is
> > > a top 10 list of the oopses collected in the last 7 days. (Reports
> > > prior to 2.6.23 have been omitted in collecting the top 10)
> > 
> > cool stuff! I cannot over-emphasise how useful this will be.
> > 
> > Let us know if you need any additional WARN_ON()s or other dmesg 
> > annotations to make parsing easier / more intelligent. At least as
> > far as arch/x86 and the scheduler is related it's going to be applied
> > to the fast-track queue ;-)
> >
> 
> the following patch would help a lot; it ads a very nice parsable end-marker
> to oopses, as well as printing the boot UUID as part of the oops, which 
> makes it easier to de-dupe oopses. The UUID is just a random number and not
> privacy-tracable to any system.
> 
> --
> 
> Subject: [patch] terminate the oops printing with a defined string/uuid
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> Right now, it's hard for automated tools to determine when an oops has
> ended; there's no clear marker for this. In addition, there's no good
> way to find out if an oops is unique. Sometimes it's the same oops
> just reported multiple times, while other times it's a different
> instance of the crash with the same signature. Printing the boot UUID
> as part of the end string resolves this ambiguity.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ted Ts'o <tytso@thunk.org>
> 
> ---
>  drivers/char/random.c  |   35 ++++++++++++++++++++++++++++++++++-
>  include/linux/random.h |    1 +
>  kernel/panic.c         |    2 ++
>  3 files changed, 37 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc5/drivers/char/random.c
> ===================================================================
> --- linux-2.6.24-rc5.orig/drivers/char/random.c
> +++ linux-2.6.24-rc5/drivers/char/random.c
> @@ -1176,8 +1176,41 @@ static int max_read_thresh = INPUT_POOL_
>  static int max_write_thresh = INPUT_POOL_WORDS * 32;
>  static char sysctl_bootid[16];
>  
> +/**
> + *	get_boot_uuid	- return a string pointer to a system wide boot UUID
> + *
> + *	Returns a pointer to the boot UUID. This UUID is unique per system
> + *	boot but persistent for one boot session.
> + *
> + *	The memory returned via the return pointer is static allocated and
> + *	owned by the random.c driver; this should not be kfree()'d.
> + *
> + *	Locking: none
> + */
> + */
> +char *get_boot_uuid(void)
> +{
> +	static char target[80];
> +	unsigned char *uuid;
> +
> +	if (sysctl_bootid[8] == 0)
> +		generate_random_uuid(sysctl_bootid);
> +	/* sysctl_bootid is signed, to print we need unsigned .. */
> +	uuid = sysctl_bootid;
> +
> +	if (target[0] == 0) {
> +		sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
> +			"%02x%02x%02x%02x%02x%02x",
> +		uuid[0],  uuid[1],  uuid[2],  uuid[3],  uuid[4],
> +		uuid[5],  uuid[6],  uuid[7],  uuid[8],  uuid[9],
> +		uuid[10], uuid[11], uuid[12], uuid[13], uuid[14],
> +		uuid[15]);

Blech. Invoking the random pool machinery at oops time is moderately
safe, but not very shiny. Going through all the sprintf ugliness to
format it to an irrelevant UUID standard is not very shiny either. At
least refactor it so it's not duplicating code.

And I'd much rather the static variable lived with its user, as
random.c is already too miscellaneous:

> --- linux-2.6.24-rc5.orig/kernel/panic.c
> +++ linux-2.6.24-rc5/kernel/panic.c
...
> +	printk("---[ end of trace %s ]---\n", get_boot_uuid());

Also, please cc: me on any future patches to random.c.

-- 
Mathematics is the supreme nostalgia of our time.
