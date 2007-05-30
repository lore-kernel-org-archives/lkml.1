Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXE3QC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXE3QC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXE3QCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:02:20 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbXE3QCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:02:19 -0400
Date: Wed, 30 May 2007 09:00:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 01/10] Containers(V10): Basic container framework
Message-Id: <20070530090031.352b7790.akpm@linux-foundation.org>
In-Reply-To: <6599ad830705300702k3ce8d7a4obaba5dc869fc77e2@mail.gmail.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070529132142.052411000@menage.corp.google.com>
	<20070530001552.ea5ff6f8.akpm@linux-foundation.org>
	<6599ad830705300702k3ce8d7a4obaba5dc869fc77e2@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 07:02:00 -0700 "Paul Menage" <menage@google.com> wrote:

> 
> >
> > People have hit unpleasant problems before now running iput() against
> > partially-constructed inodes.
> 
> What kinds of problems? Are there bits of state that I should fully
> construct even if I'm going to iput() it, or is there a better
> function to call? fs/ext3/super.c seems to do the same thing.

I don't recall, actually.  But it crashed.

I guess the fault-injection code could be used to trigger errors here.

> > >
> > > +static inline void get_first_subsys(const struct container *cont,
> > > +                                 struct container_subsys_state **css,
> > > +                                 int *subsys_id) {
> > > +     const struct containerfs_root *root = cont->root;
> > > +     const struct container_subsys *test_ss;
> > > +     BUG_ON(list_empty(&root->subsys_list));
> > > +     test_ss = list_entry(root->subsys_list.next,
> > > +                          struct container_subsys, sibling);
> > > +     if (css) {
> > > +             *css = cont->subsys[test_ss->subsys_id];
> > > +             BUG_ON(!*css);
> > > +     }
> > > +     if (subsys_id)
> > > +             *subsys_id = test_ss->subsys_id;
> > > +}
> >
> > This ends up having several callers and its too large to inline.
> 
> Two large from a compiler PoV or from a style PoV? It's basically just
> six dereferences and two comparisons, plus the BUG_ON()s.

It will end up generating more .text this way.  We figure that this makes
it slower, due to increased icache footprint.


