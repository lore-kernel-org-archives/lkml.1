Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZATC7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZATC7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZATC7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:59:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38807 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZATC7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:59:40 -0500
Date: Tue, 20 Jan 2009 11:58:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
Message-Id: <20090120115832.0881506c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901191823q556faeeub28d02d39dda7396@mail.gmail.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
	<20090120110221.005e116c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901191823q556faeeub28d02d39dda7396@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 18:23:03 -0800
Paul Menage <menage@google.com> wrote:

> On Mon, Jan 19, 2009 at 6:02 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Ah, this is related to CSS ID scanning. No real problem to current codes.
> >
> > Now, in my patch, CSS ID is attached just after create().
> >
> > Then, "scan by CSS ID" can find a cgroup which is not populated yet.
> > I just wanted to skip them for avoiding mess.
> >
> > For example, css_tryget() can succeed against css which belongs to not-populated
> > cgroup. If creation of cgroup fails, it's destroyed and freed without RCU synchronize.
> > This may breaks CSS ID scanning's assumption that "we're safe under rcu_read_lock".
> > And allows destroy css while css->refcnt > 1.
> 
> So for the CSS ID case, we could solve this by not populating
> css_id->css until creation is guaranteed to have succeeded? (We'd
> still allocated the css_id along with the subsystem, just not complete
> its initialization). cgroup.c already knows about and hides the
> details of css_id, so this wouldn't be hard.
> 

Hmm, moving this call to after populate is not good because
id > max_id cannot be handled ;)

> +               if (ss->use_id)
> +                       if (alloc_css_id(ss, parent, cgrp))
> +                               goto err_destroy;
> +               /* At error, ->destroy() callback has to free assigned ID. */
>        }

Should I delay to set css_id->css pointer to valid value until the end of
populate() ? (add populage_css_id() call after cgroup_populate_dir()).

I'd like to write add-on patch to the patch [1/4]. (or update it.)
css_id->css == NULL case is handled now, anyway.



> The question is whether other users of css_tryget() might run into
> this problem, without using CSS IDs. But currently no-one's using
> css_tryget() apart from you, so that's a problem we can solve as it
> arises.
> 
yes ;)

> I think we're safe from css_get() being used in this case, since
> css_get() can only be used on css references obtained from a locked
> task, or from other pointers that are known to be ref-counted, which
> would be impossible if css_tryget() can't succeed on a css in the
> partially-completed state.
> 
> 

Thanks, I'll try some other patch. Maybe it's ok to delay updating css_id->css
pointer.

-Kame

