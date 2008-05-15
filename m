Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYEOI0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYEOI0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYEOI00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:26:26 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:45507 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYEOI0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:26:23 -0400
Date: Thu, 15 May 2008 13:55:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and
	control (v4)
Message-ID: <20080515082553.GK31115@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Paul Menage <menage@google.com>, linux-mm@kvack.org,
	Sudhir Kumar <skumar@linux.vnet.ibm.com>,
	YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
	linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130951.24440.73671.sendpatchset@localhost.localdomain> <20080514132529.GA25653@balbir.in.ibm.com> <6599ad830805141925mf8a13daq7309148153a3c2df@mail.gmail.com> <20080515061727.GC31115@balbir.in.ibm.com> <6599ad830805142355ifeeb0e2w86ccfd96aa27aea6@mail.gmail.com> <20080515070342.GJ31115@balbir.in.ibm.com> <6599ad830805150039u76c9002cg6c873fd71e687a69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <6599ad830805150039u76c9002cg6c873fd71e687a69@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Menage <menage@google.com> [2008-05-15 00:39:45]:

> On Thu, May 15, 2008 at 12:03 AM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> >
> >  I want to focus on this conclusion/assertion, since it takes care of
> >  most of the locking related discussion above, unless I missed
> >  something.
> >
> >  My concern with using mmap_sem, is that
> >
> >  1. It's highly contended (every page fault, vma change, etc)
> 
> But the only *new* cases of taking the mmap_sem that this would
> introduce would be:
> 
> - on a failed vm limit charge

Why a failed charge? Aren't we talking of moving all charge/uncharge
under mmap_sem?

> - when a task exit/exec causes an mm ownership change

Yes, in the mm_owner_changed callbacks

> - when a task moves between two cgroups in the memrlimit hierarchy.
> 

Yes, this would nest cgroup_mutex and mmap_sem. Not sure if that would
be a bad side-effect.

> All of these should be rare events, so I don't think the additional
> contention is a worry.

We do make several of all charge calls under the mmap_sem, but not
all of them. So the additional contention might not be all that bad.

> 
> >  2. It's going to make the locking hierarchy deeper and complex
> 
> Yes, potentially. But if the upside of that is that we eliminate a
> lock/unlock on a shared lock on every mmap/munmap call, it might well
> be worth it.
> 
> >  3. It's not appropriate to call all the accounting callbacks with
> >    the mmap_sem() held, since the undo operations _can get_ complicated
> >    at the caller.
> >
> 
> Can you give an example?

Some paths of the uncharge are not under mmap_sem. Undoing the
operation there seemed complex.

> 
> >  I would prefer introducing a new lock, so that other subsystems are
> >  not affected.
> >
> 
> For getting the first cut of the memrlimit controller working this may
> well make sense. But it would be nice to avoid it longer-term.

OK, so here's what I am going to try and do

Refactor the code to try and use mmap_sem and see what I come up
with. Basically use mmap_sem for all charge/uncharge operations as
well use mmap_sem in read_mode in the move_task() and
mm_owner_changed() callbacks. That should take care of the race
conditions discussed, unless I missed something.
Try and instrument insert_vm_struct() for charge/uncharge

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
