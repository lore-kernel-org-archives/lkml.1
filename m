Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbXGQJWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbXGQJWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXGQJW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:22:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbXGQJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:22:28 -0400
Date: Tue, 17 Jul 2007 02:15:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kirill Korotaev <dev@sw.ru>
Cc: Pavel Emelianov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [Devel] Re: [PATCH] Fix user struct leakage with locked IPC
 shem segment
Message-Id: <20070717021505.3c6a384c.akpm@linux-foundation.org>
In-Reply-To: <469C86EB.8090501@sw.ru>
References: <469B636C.3060007@openvz.org>
	<20070716151738.2f4b5cf4.akpm@linux-foundation.org>
	<469C86EB.8090501@sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 13:07:55 +0400 Kirill Korotaev <dev@sw.ru> wrote:

> Andrew Morton wrote:
> > On Mon, 16 Jul 2007 16:24:12 +0400
> > Pavel Emelianov <xemul@openvz.org> wrote:
> > 
> > 
> >>When user locks an ipc shmem segmant with SHM_LOCK ctl and the
> >>segment is already locked the shmem_lock() function returns 0. 
> >>After this the subsequent code leaks the existing user struct:
> > 
> > 
> > I'm curious.  For the past few months, people@openvz.org have discovered
> > (and fixed) an ongoing stream of obscure but serious and quite
> > long-standing bugs.
> 
> thanks a lot :@)
> 
> > How are you discovering these bugs?
> 
> Not sure what to answer :) Just trying to do our best.

hm, OK, I was visualising some mysterious Russian bugfinding machine or
something.

Don't stop ;)

> This bug was thought over by Pavel for about 3 month after a single
> uid leak in container was detected by beancounters' kernel memory accounting...
> 
> >>== ipc/shm.c: sys_shmctl() ==
> >>     ...
> >>     err = shmem_lock(shp->shm_file, 1, user);
> >>     if (!err) {
> >>          shp->shm_perm.mode |= SHM_LOCKED;
> >>          shp->mlock_user = user;
> >>     }
> >>     ...
> >>==
> >>
> >>Other results of this are:
> >>1. the new shp->mlock_user is not get-ed and will point to freed
> >>   memory when the task dies.
> > 
> > 
> > That sounds fairly serious - can this lead to memory corruption and crashes?
> 
> Yes it can. According to Pavel when the shmem segment is destroyed it
> puts the mlock_user pointer, which can already be stalled.

OK, thanks, I'll feed a copy in stable@kernel.org's direction.
