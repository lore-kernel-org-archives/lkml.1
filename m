Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0CCTzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:55:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41822 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0CCTy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:54:59 -0500
Date: Wed, 3 Mar 2010 19:54:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andr?? Goddard Rosa <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [Patch] mqueue: fix the bad code in sys_mq_open()
Message-ID: <20100303195449.GS30031@ZenIV.linux.org.uk>
References: <cover.1266907495.git.andre.goddard@gmail.com>
 <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com>
 <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com>
 <7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com>
 <2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com>
 <2375c9f91002242259n2fabb190ic77d6ca603bd1df7@mail.gmail.com>
 <7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com>
 <20100225134023.GB3842@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225134023.GB3842@hack>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 09:40:23PM +0800, Am??rico Wang wrote:
> 
> Fix bad code in ipc/mqueue.c.
> 
> Inspired by Andr?? Goddard Rosa's  patch.
> 
> a) do_create() and do_open() should not release the resources which
>    are not acquired within themselves, it's their caller's work;

Sorry, NAK.  Resources are either consumed by opened file (i.e. struct
file now is the holder of mnt/dentry) or released; in either case,
caller has given them up.  Your variant is broken in its current form
and will be more complicated than existing code if you fix it.

> b) Fix an fd leak;

Fixed by original patch.

> c) The goto label 'out_upsem' doesn't make any sense, rename to
>    'out_unlock';
> 
> d) mntget() should be called before looking up dentry within
>    ->mnt->mnt_root;

Not really, since ->mnt doesn't change (and remains pinned) for the
entire lifetime of ipc_ns.

> e) When dealing with failure case, we should release the resources
>    in a reversed order of acquiring, so reorder the goto labels;
> 
> f) Remove some unused labels due to reorder.

I wouldn't say it's cleaner that way.

Anyway, I've applied the patchset as posted; if you want to do something
else, do that on top of it.  I really object against your (a), the rest
is more or less a matter of taste.  (a) is just plain wrong - we want
uniform behaviour from the caller's POV and it means that mnt/dentry should
always be given up from caller's POV.  Either moved into new struct file,
or dropped.
