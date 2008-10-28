Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYJ1A2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYJ1A2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJ1A2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:28:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59266 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYJ1A2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:28:21 -0400
X-Sasl-enc: oTsTb7oaEVogulyr9rJsff7as9ZADIUMaemj+HxhMW81 1225153699
Subject: Re: [PATCH 4/6] autofs4 - make autofs type usage explicit
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       autofs@linux.kernel.org
In-Reply-To: <20081027134050.c85a28dd.akpm@linux-foundation.org>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	 <20081023023532.4508.56823.stgit@raven.themaw.net>
	 <20081027134050.c85a28dd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 09:28:14 +0900
Message-Id: <1225153694.2938.2.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 13:40 -0700, Andrew Morton wrote:
> On Thu, 23 Oct 2008 10:35:32 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
> > This patch further improves autofs mount type usage and provides
> > supplementry explanation of the changes made in the previous patch
> > "autofs4 - cleanup autofs mount type usage".
> > 
> > Changes introduced in "autofs4 - cleanup autofs mount type usage":
> > 
> > - the type assigned at mount when no type is given is changed
> >   from 0 to AUTOFS_TYPE_INDIRECT. This was done because 0 and
> >   AUTOFS_TYPE_INDIRECT were being treated implicitly as the same
> >   type.
> > 
> > - previously, an offset mount had it's type set to
> >   AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET but the mount control
> >   re-implementation needs to be able distinguish all three types.
> >   So this was changed to make the type setting explicit.
> > 
> > - a type AUTOFS_TYPE_ANY was added for use by the re-implementation
> >   when checking if a given path is a mountpoint. It's not really a
> >   type as we use this to ask if a given path is a mountpoint in the
> >   autofs_dev_ioctl_ismountpoint() function.
> > 
> > Changes introduced in this patch:
> > 
> > - macros to set and test the autofs mount types have been added to
> >   improve readability and make the type usage explicit.
> 
>     ^^^^^^^^^^^^^^^^^^^  <<-- ??
> 
> > - the mount type is used from user space for the mount control
> >   re-implementtion so, for consistency, all the definitions have
> >   been moved to the user space include file include/linux/auto_fs4.h.
> >
> > ...
> > 
> > -		if (sbi->type == AUTOFS_TYPE_INDIRECT)
> > +		if (autofs_type_indirect(sbi->type))
> 
> spose so.
> 
> > -			*type = AUTOFS_TYPE_INDIRECT;
> > +			set_autofs_type_indirect(*type);
> 
> That's pretty nasty.  One doesn't expect a "function" to modify a
> variable which was passed by value.
> 
> This interface _requires_ that set_autofs_type_indirect() be
> implemented as a macro.
> 
> This didn't improve readability.
> 
> >
> > ...
> >
> > +#define set_autofs_type_indirect(type)		(type = AUTOFS_TYPE_INDIRECT)
> 
> You'll find very few places in the kernel pull tricks like this, for
> good reasons.  The obnoxious exceptions include local_irq_save() and
> friends.
> 
> > +#define autofs_type_indirect(type)		(type == AUTOFS_TYPE_INDIRECT)
> 
> I guess that's OK.
> 
> But why was it implemented as a macro?  It didn't _need_ to be
> implemented in cpp - it could have been implemented in C.
> 
> > +
> > +#define set_autofs_type_direct(type)		(type = AUTOFS_TYPE_DIRECT)
> > +#define autofs_type_direct(type)		(type == AUTOFS_TYPE_DIRECT)
> > +
> > +#define set_autofs_type_offset(type)		(type = AUTOFS_TYPE_OFFSET)
> > +#define autofs_type_offset(type)		(type == AUTOFS_TYPE_OFFSET)
> > +
> > +#define autofs_type_trigger(type) \
> > +	(type == AUTOFS_TYPE_DIRECT || type == AUTOFS_TYPE_OFFSET)
> 
> And this one is dangerous.  If passed an expression-with-side-effects
> it will evaluate that expression either once or twice.  Bad.  Should be
> implemented in C.
> 

OK, more work needed then.
Ian


