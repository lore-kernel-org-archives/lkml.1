Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752761AbYLQTJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbYLQTJW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYLQTI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:08:56 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42982 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYLQTIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:08:55 -0500
Date: Wed, 17 Dec 2008 13:08:26 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/2] ipc namespaces: implement support for posix
	msqueues
Message-ID: <20081217190826.GA25890@us.ibm.com>
References: <20081217175513.GA23291@us.ibm.com> <20081217175549.GB23331@us.ibm.com> <1229540099.17206.426.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229540099.17206.426.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Wed, 2008-12-17 at 11:55 -0600, Serge E. Hallyn wrote:
> > -void free_ipc_ns(struct kref *kref)
> > +void put_ipc_ns(struct ipc_namespace *ns)
> >  {
> > -       struct ipc_namespace *ns;
> > +       if (ns && atomic_dec_and_lock(&ns->count, &mq_lock)) {
> > +               mq_clear_sbinfo(ns);
> > +               spin_unlock(&mq_lock);
> > +               mq_put_mnt(ns);
> > +               free_ipc_ns(ns);
> > +       }
> > +}
> 
> OK, I see now why you wanted to remove the kref and add an atomic_t.
> That's probably worth a sentence in the patch description.

Good point, will do.

> I know that atomic_dec_and_lock() can be a nice logical thing to do, but
> is it necessary here?  Basically, is there something that happens under
> mq_lock that can re-raise the ns->count?

A racing task from another ipc namespace can open a mq file through
the VFS and thereby bump the ipc's refcount.  Will comment that here and
in the patch description.

thanks,
-serge
