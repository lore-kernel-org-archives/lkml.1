Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYKZRxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYKZRxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYKZRxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:53:01 -0500
Received: from colobus.isomerica.net ([216.93.242.10]:58097 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYKZRxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:53:00 -0500
Date: Wed, 26 Nov 2008 12:52:58 -0500
From: Dan =?UTF-8?B?Tm/DqQ==?= <dpn@isomerica.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
Message-ID: <20081126125258.72336d33@rockhopper.limebrokerage.com>
In-Reply-To: <1227711779.4454.184.camel@twins>
References: <20081125064357.5a4f1420@tuna>
	<20081126072625.GH6291@disturbed>
	<1227711779.4454.184.camel@twins>
Organization: isomerica.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 16:02:59 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> The thing to do is re-annotate the inode locks whenever the inode
> changes data-structure, much like we do in unlock_new_inode().
> 
> So for each stage in the inode's life-cycle you need to create a key
> for each lock, such as:
> 
> struct lock_class_key xfs_active_inode_ilock;
> struct lock_class_key xfs_deleted_inode_ilock;
> ...
> 
> and on state change do something like:
> 
>   BUG_ON(rwsem_is_locked(&xfs_ilock->mrlock));
> 
>   init_rwsem(&xfs_ilock->mrlock);
>   lockdep_set_class(&xfs_ilock->mrlock, &xfs_deleted_inode_ilock);

This seems to make sense, based on my understanding and reading of the
lockdep documentation.  It looks like the first step is to add callbacks
for state change, and then add XFS specific callbacks that set the
lockdep class.  I would love to work on a patch, with some guidance.

Thanks,
Dan

-- 
                    /--------------- - -  -  -   -   -
                   |  Dan Noé
                   |  http://isomerica.net/~dpn/
