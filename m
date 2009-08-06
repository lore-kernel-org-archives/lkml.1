Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZHGAAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZHGAAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZHGAAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:00:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:38443 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbZHGAAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:00:00 -0400
Date: Thu, 6 Aug 2009 16:58:52 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andreas Mohr <andi@lisas.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release()
 function, it is broken and must be fixed."
Message-ID: <20090806235852.GA29688@suse.de>
References: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
 <20090716225525.GC1548@suse.de>
 <adabpmsg01a.fsf@cisco.com>
 <20090806205019.GA12988@rhlx01.hs-esslingen.de>
 <20090806223205.GD14792@suse.de>
 <adaiqh0ec8c.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaiqh0ec8c.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 04:47:31PM -0700, Roland Dreier wrote:
> 
>  > Kay, we were cleaning up the kobject name stuff then, and we thought
>  > that this release function wasn't used anymore.  But in looking at the
>  > code, I can't see where the kobject is actually freed.  What am I
>  > missing?
> 
> the kobject in question is freed at
> 
>   free_module() ->
>     mod_kobject_remove() ->
>       mod_sysfs_fini() ->
>         kobject_put(&mod->mkobj.kobj);
> 
> (in kernel/module.c)

Ah, that makes sense.

This is because we can't "free" the kobject here, because the kobject is
part of the larger struct module structure.  And the kobject is not
being used as a reference count for the whole structure, it's being used
just to create the sysfs directories.

So we can't have a release function, because if we did, it would have to
do nothing.

And yes, this isn't "correct" and is what I make fun of lots of people
for doing all the time now.  But Rusty did this a long time ago before I
realized it :)

Patches to fix this up "properly" are gladly accepted, just watch out,
that code path is nasty.

So yes, the warning when kobject debugging is enabled is correct, that
kobject usage is "wrong" and should be fixed one of these days.

I'll add it to the end of my long TODO list :(

thanks,

greg k-h
