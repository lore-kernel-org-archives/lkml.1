Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYC2ArS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYC2ArS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYC2ArI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:47:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53890 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYC2ArH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:47:07 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47ED8685.9040409@goop.org>
References: <47ED8685.9040409@goop.org>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 17:47:02 -0700
Message-Id: <1206751622.27091.20.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 17:00 -0700, Jeremy Fitzhardinge wrote:
> The Xen balloon driver needs to separate the process of hot-installing
> memory into two phases: one to allocate the page structures and
> configure the zones, and another to actually online the pages of newly
> installed memory.
> 
> This patch splits up the innards of online_pages() into two pieces which
> correspond to these two phases.  The behaviour of online_pages() itself
> is unchanged.
...
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -180,31 +180,35 @@
>         return 0;
>  }
> 
> -
> -int online_pages(unsigned long pfn, unsigned long nr_pages)
> +/* Tell anyone who's interested that we're onlining some memory */
> +static int notify_going_online(unsigned long pfn, unsigned long nr_pages)
>  {
> -       unsigned long flags;
> -       unsigned long onlined_pages = 0;
> -       struct zone *zone;
> -       int need_zonelists_rebuild = 0;
> +       struct memory_notify arg;
>         int nid;
>         int ret;
> -       struct memory_notify arg;
> 
>         arg.start_pfn = pfn;
>         arg.nr_pages = nr_pages;
>         arg.status_change_nid = -1;
> -
> +
>         nid = page_to_nid(pfn_to_page(pfn));
>         if (node_present_pages(nid) == 0)
>                 arg.status_change_nid = nid;

That's kind a weird line in the patch.  How'd that get there?  Why are
you moving 'arg'?

This look OK, but it does add ~45 lines of code, and I'm not immediately
sure how you're going to use it.  Could you address that a bit?

I do kinda wish you'd take a real hard look at what the new functions
are doing now.  I'm not sure their current names are very good.

> +/* Grow the zone to fit the expected amount of memory being added */
> +static struct zone *online_pages_zone(unsigned long pfn, unsigned long nr_pages)

The comment is good, but the function name is not. :)  How about
grow_zone_span() or something?

> +/* Mark a set of pages as online */
> +unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages)

Isn't the comment on this one a bit redundant? :)

This looks to me to have become the real online_pages() now.  This
function is what goes and individually onlines pages.  If someone was
trying to figure out whether to call online_pages() or
mark_pages_onlined(), which one would they know to call?

> -       if (onlined_pages)
> +       if (onlined_pages) {
> +               struct memory_notify arg;
> +
> +               arg.start_pfn = pfn;  /* ? */
> +               arg.nr_pages = onlined_pages;
> +               arg.status_change_nid = -1;  /* ? */
> +
>                 memory_notify(MEM_ONLINE, &arg);
> +       }

We should really wrap up memory notify:

static void memory_notify(int state, unsigned long start_pfn,
			  unsigned long nr_pages, int status_change_nid)
{
	struct memory_notify arg;
	arg.start_pfn = start_pfn;
	arg.nr_pages = nr_pages;
	arg.status_change_nid = status_change_nid;
	return the_current_memory_notify(state, &arg);
}

We can use that in a couple of spots, right?

-- Dave

