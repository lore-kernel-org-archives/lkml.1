Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZGMGE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZGMGE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZGMGEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:04:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41707 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZGMGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:04:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jul 2009 15:03:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where
 array size is too large
Message-Id: <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A5AA3E7.9070800@cn.fujitsu.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	<20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	<4A5AA3E7.9070800@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 11:03:03 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ben Blum wrote:
> > Quick vmalloc vs kmalloc fix to the case where array size is too large
> > 
> > Separates all pidlist allocation requests to a separate function that judges
> > based on the requested size whether or not the array needs to be vmalloced or
> > can be gotten via kmalloc, and similar for kfree/vfree. Should be replaced
> > entirely with a kernel-wide solution to this general problem.
> > 
> > Depends on cgroup-pidlist-namespace.patch, cgroup-procs.patch
> > 
> 
> Since this is a patchset, you don't need to tell the dependencies of
> this patch, at least not in changelog, but can put it ...
> 
> > Signed-off-by: Ben Blum <bblum@google.com>
> > 
> > ---
> > 
> 
> ... here
> 
> ---  <- followed by this mark
> 
> >  kernel/cgroup.c |   34 ++++++++++++++++++++++++++++------
> >  1 files changed, 28 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 33d89be..0ed85fa 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -48,6 +48,7 @@
> >  #include <linux/namei.h>
> >  #include <linux/smp_lock.h>
> >  #include <linux/pid_namespace.h>
> > +#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
> >  
> 
> Is this TODO different with the below one?
> 
> >  #include <asm/atomic.h>
> >  
> > @@ -2121,6 +2122,27 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
> >   */
> >  
> >  /*
> > + * The following two functions "fix" the issue where there are more pids
> > + * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
> > + * TODO: replace with a kernel-wide solution to this problem
> > + */
> > +#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
> 
> I think order-0 is most robust and should be used as much as possible.
> 
> > +static inline void *pidlist_allocate(int count)
> 
> It's better to let gcc decide to inline it or not.
> 
> > +{
> > +	if (PIDLIST_TOO_LARGE(count))
> > +		return vmalloc(count * sizeof(pid_t));
> > +	else
> > +		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
> > +}
> > +static inline void pidlist_free(void *p)
> 
> ditto
> 
???? why not using vmalloc() always ? 

Thanks,
-Kame



> > +{
> > +	if (is_vmalloc_addr(p))
> > +		vfree(p);
> > +	else
> > +		kfree(p);
> > +}
> > +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

