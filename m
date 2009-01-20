Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZATCDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZATCDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZATCDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:03:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44620 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZATCD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:03:29 -0500
Date: Tue, 20 Jan 2009 11:02:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
Message-Id: <20090120110221.005e116c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 17:39:40 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Jan 15, 2009 at 2:27 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > cgroup creation is done in several stages.
> > After allocated and linked to cgroup's hierarchy tree, all necessary
> > control files are created.
> >
> > When using CSS_ID, scanning cgroups without cgrouo_lock(), status
> > of cgroup is important. At removal of cgroup/css, css_tryget() works fine
> > and we can write a safe code.
> 
> What problems are you currently running into during creation? Won't
> the fact that the css for the cgroup has been created, and its pointer
> been stored in the cgroup, be sufficient?
> 
> Or is the problem that a cgroup that fails creation half-way could
> result in the memory code alreadying having taken a reference on the
> memcg, which can't then be cleanly destroyed?
> 
Ah, this is related to CSS ID scanning. No real problem to current codes.

Now, in my patch, CSS ID is attached just after create().

Then, "scan by CSS ID" can find a cgroup which is not populated yet.
I just wanted to skip them for avoiding mess.

For example, css_tryget() can succeed against css which belongs to not-populated
cgroup. If creation of cgroup fails, it's destroyed and freed without RCU synchronize.
This may breaks CSS ID scanning's assumption that "we're safe under rcu_read_lock".
And allows destroy css while css->refcnt > 1.

I'm now rewriting codes a bit, what I want is something like this.
==
	for_each_subsys(root, ss) {
		/* if error , goto destroy "/
		create();
		if (ss->use_id)
			attach_id();
	}
	create dir and populate files.
	.....
destroy:
	synchronize_rcu();
	/* start destroy here */
==

css_is_populated() is to show "ok, you can call css_tryget()".
If css_tryget() itself checks CSS_POPULATED bit, it's maybe clearer.

-Kame





> Paul
> 
> > "This cgroup is not ready yet"
> >
> > This patch adds CSS_POPULATED flag.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > ---
> > Index: mmotm-2.6.29-Jan14/include/linux/cgroup.h
> > ===================================================================
> > --- mmotm-2.6.29-Jan14.orig/include/linux/cgroup.h
> > +++ mmotm-2.6.29-Jan14/include/linux/cgroup.h
> > @@ -69,6 +69,7 @@ struct cgroup_subsys_state {
> >  enum {
> >        CSS_ROOT, /* This CSS is the root of the subsystem */
> >        CSS_REMOVED, /* This CSS is dead */
> > +       CSS_POPULATED, /* This CSS finished all initialization */
> >  };
> >
> >  /*
> > @@ -90,6 +91,11 @@ static inline bool css_is_removed(struct
> >        return test_bit(CSS_REMOVED, &css->flags);
> >  }
> >
> > +static inline bool css_is_populated(struct cgroup_subsys_state *css)
> > +{
> > +       return test_bit(CSS_POPULATED, &css->flags);
> > +}
> > +
> >  /*
> >  * Call css_tryget() to take a reference on a css if your existing
> >  * (known-valid) reference isn't already ref-counted. Returns false if
> > Index: mmotm-2.6.29-Jan14/kernel/cgroup.c
> > ===================================================================
> > --- mmotm-2.6.29-Jan14.orig/kernel/cgroup.c
> > +++ mmotm-2.6.29-Jan14/kernel/cgroup.c
> > @@ -2326,8 +2326,10 @@ static int cgroup_populate_dir(struct cg
> >        }
> >
> >        for_each_subsys(cgrp->root, ss) {
> > +               struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> >                if (ss->populate && (err = ss->populate(ss, cgrp)) < 0)
> >                        return err;
> > +               set_bit(CSS_POPULATED, &css->flags);
> >        }
> >
> >        return 0;
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

