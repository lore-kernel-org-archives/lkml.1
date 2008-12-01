Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYLASAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYLASAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYLASAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:00:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41312 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYLASAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:00:41 -0500
Subject: Re: [RFC v10][PATCH 05/13] Dump memory address space
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081128105351.GQ28946@ZenIV.linux.org.uk>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-6-git-send-email-orenl@cs.columbia.edu>
	 <20081128105351.GQ28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 10:00:12 -0800
Message-Id: <1228154412.2971.44.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 10:53 +0000, Al Viro wrote:
> 
> > +static int cr_ctx_checkpoint(struct cr_ctx *ctx, pid_t pid)
> > +{
> > +     ctx->root_pid = pid;
> > +
> > +     /*
> > +      * assume checkpointer is in container's root vfs
> > +      * FIXME: this works for now, but will change with real containers
> > +      */
> > +     ctx->vfsroot = &current->fs->root;
> > +     path_get(ctx->vfsroot);
> 
> This is going to break as soon as you get another thread doing e.g. chroot(2)
> while you are in there.

Yeah, we do need at least a read_lock(&current->fs->lock) to keep people
from chroot()'ing underneath us.

> And it's a really, _really_ bad idea to take a
> pointer to shared object, increment refcount on the current *contents* of
> said object and assume that dropping refcount on the later contents of the
> same will balance out.

Absolutely.  I assume you mean get_fs_struct(current) instead of
path_get().

-- Dave

