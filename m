Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZINJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZINJXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZINJXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:23:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59270 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZINJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:23:14 -0400
Subject: Re: [origin tree SLAB corruption] BUG kmalloc-64: Poison
 overwritten,   INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1
 pid=3514
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090914092042.GV14984@kernel.dk>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>
	 <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
	 <20090914071631.GA24801@elte.hu>
	 <84144f020909140057j542a3ee8wc996ffc6f8fcbbd1@mail.gmail.com>
	 <20090914092042.GV14984@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 14 Sep 2009 12:23:16 +0300
Message-Id: <1252920196.5934.6.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 11:20 +0200, Jens Axboe wrote:
> On Mon, Sep 14 2009, Pekka Enberg wrote:
> > * Eric Paris <eparis@redhat.com> wrote:
> > >> On Sat, 2009-09-12 at 09:24 +0200, Ingo Molnar wrote:
> > >> > James - i did not see a security pull request email from you in my
> > >> > lkml folder so i created this new thread. -tip testing found the
> > >> > easy crash below. It reverts cleanly so i went that easy route.
> > >> >
> > >> > At a really quick 10-seconds glance the crash happens because we
> > >> > destroy the slab cache twice, if the sysctl is toggled twice?
> > >>
> > >> Something a lot worse than SELinux here.  I added this exact code and
> > >> got this warning.  Something is wrong in the world of
> > >> kmem_cache_destroy.....
> > 
> > Btw, the kmem_cache_destroy() bug Eric found is not in Linu's tree yet.
> > 
> > On Mon, Sep 14, 2009 at 10:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > -tip testing just triggered another type of SLAB problem (this time
> > > not apparently related to the security subsystem):
> > >
> > > BUG kmalloc-64: Poison overwritten
> > > -----------------------------------------------------------------------------
> > >
> > > INFO: 0xf498f6a0-0xf498f6a7. First byte 0x90 instead of 0x6b
> > > INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
> > > INFO: Freed in bdi_work_free+0x45/0x60 age=9 cpu=1 pid=3509
> > > INFO: Slab 0xc3257d84 objects=36 used=11 fp=0xf498f690 flags=0x400000c3
> > > INFO: Object 0xf498f690 @offset=1680 fp=0xf498fe00
> > >
> > > Bytes b4 0xf498f680:  ab 0d 00 00 9c 27 ff ff 5a 5a 5a 5a 5a 5a 5a 5a «....'ÿÿZZZZZZZZ
> > >  Object 0xf498f690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > >  Object 0xf498f6a0:  90 f3 98 f4 60 3c 11 c1 6b 6b 6b 6b 6b 6b 6b 6b .ó.ô`<.Ákkkkkkkk
> > 
> > This would be use-after-free in kmalloc-64 cache. Given the trace and
> > the fact that bdi_work_alloc() got introduce recently, it seems more
> > likely that fs/fs-writeback.c is to blame here. Jens, does the warning
> > ring a bell to you?
> 
> No bells, the code seems right to me. I'll prod at it a bit more. I
> haven't seen anything like this during testing.

OK, it's possible that someone else is holding on to the kmalloc-64
memory block too but that won't show up in the traces.

			Pekka

