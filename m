Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZDNRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZDNRAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZDNQ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:59:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63440 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDNQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=luoM90kmtDgjcne6og/tCvZhc2bEBfjQr4x4mWS2vuSKfBuuIAJqz2CHsQeNKpSRsn
         dtTsSYwjZ7BtvB+YlyA+Zo+6QRED6CfZjvGJcxjxF/KfvggJYwe0LJVQx6aADtQRM3HU
         jzroJdBzshVkMezEcHuBh+/eIfNGbke1uKeiw=
Date: Tue, 14 Apr 2009 21:00:04 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414170004.GC27923@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <20090414152752.GC27461@x200.localdomain> <20090414154139.GA8085@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414154139.GA8085@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:41:39AM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > On Mon, Apr 13, 2009 at 04:47:01PM -0500, Serge E. Hallyn wrote:
> > > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > 
> > > Hi Alexey,
> > > 
> > > as far as I can see, the main differences between this patch and the
> > > equivalent in Oren's tree are:
> > > 
> > > 1. kernel auto-selects container init to freeze
> > 
> > Note, auto-select part was dropped, userspace is required to pass pid of
> > container init exactly. This was done to keep semantic of checkpoint(2)
> > small and extendable.
> 
> sys_checkpoint() in this patch still finds the child_reaper of the
> passed-in pid, doesn't it?  Or are you saying that a later patch in
> this set removes that?

I posted with auto-selecting?

Code now looks like this:

	rcu_read_lock();
        tsk = find_task_by_vpid(pid);
        if (tsk) {
                struct nsproxy *nsproxy;

                nsproxy = task_nsproxy(tsk);
                if (nsproxy) {
                        init_tsk = nsproxy->pid_ns->child_reaper;
                        if (init_tsk != tsk)
                                init_tsk = NULL;
                } else
                        init_tsk = NULL;
                if (init_tsk)
                        get_task_struct(init_tsk);
        }
        rcu_read_unlock();

This is to buy as little semantics on checkpoint(2) as possible.

If users later will complain that it's for some reason hard to see who is
root of container, it could be added.
