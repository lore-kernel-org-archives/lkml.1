Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYEMVcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYEMVcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbYEMVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:32:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYEMVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:32:39 -0400
Date: Tue, 13 May 2008 14:32:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups
 control files
Message-Id: <20080513143206.ef259829.akpm@linux-foundation.org>
In-Reply-To: <6599ad830805131417m4f8cc2e6iac42c0fb089a8cb1@mail.gmail.com>
References: <20080513063707.049448000@menage.corp.google.com>
	<20080513071522.133586000@menage.corp.google.com>
	<20080513130127.fcd46a41.akpm@linux-foundation.org>
	<6599ad830805131417m4f8cc2e6iac42c0fb089a8cb1@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 14:17:29 -0700
"Paul Menage" <menage@google.com> wrote:

> On Tue, May 13, 2008 at 1:01 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  This, umm, doesn't seem to do much to make the kernel a simpler place.
> >
> >  Do we expect to gain much from this?  Hope so...  What?
> >
> 
> The goal is to prevent cgroup_mutex becoming a BKL for cgroups, to
> make it easier for subsystems to lock just the bits that they need to
> remain stable rather than everything.

OK.

But do we ever expect that cgroup_mutex will be taken with much
frequency, or held for much time?  If it's only taken during, say,
configuration of a group or during a query of that configuration then
perhaps we'll be OK.

otoh a per-cgroup lock would seem more appropriate than a global.

> >
> >  Vague handwaving: lockdep doesn't know anything about any of this.
> >  Whereas if we were more conventional in using separate locks and
> >  suitable lock types for each application, we would retain full lockdep
> >  coverage.
> 
> That's a good point - I'd not thought about lockdep. That's a good
> argument in favour of not having the locking done in the framework.
> 
> Stepping back a bit, the idea is definitely that where appropriate
> subsystems will use their own fine-grained locking. E.g. the
> res_counter abstraction does this already with a spinlock in each
> res_counter, and cpusets has the global callback_mutex that just
> synchronizes cpuset operations. But there are some cases where they
> need a bit of help from cgroups, such as when doing operations that
> require stable hierarchies, task membership of cgroups, etc.
> 
> Right now the default behaviour is to call cgroup_lock(), which I'd
> like to get away from. Having the framework do the locking results in
> less need for cleanup code in the subsystem handlers themselves, but
> that's not an unassailable argument for doing it that way.

Yes, caller-provided locking is the usual pattern in-kernel.  Based on
painful experience :(

> >  I'm trying to work out what protects static_buffer?
> >
> >  Why does it need to be static anyway?  64 bytes on-stack is OK.
> >
> 
> As Matt observed, this is just a poorly-named variable. How about
> "small_buffer"?

local_buffer ;)
