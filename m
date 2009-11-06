Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbZKFR4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbZKFR4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZKFR4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:56:09 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:60393 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758222AbZKFR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:56:08 -0500
Date: Fri, 6 Nov 2009 12:54:50 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Andi Kleen <andi@firstfloor.org>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter
 instead
In-Reply-To: <20091106174439.GB819@basil.fritz.box>
Message-ID: <alpine.DEB.1.10.0911061249170.5187@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <87r5sc7kst.fsf@basil.nowhere.org> <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1> <20091106073946.GV31511@one.firstfloor.org>
 <alpine.DEB.1.10.0911061208370.5187@V090114053VZO-1> <20091106174439.GB819@basil.fritz.box>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Andi Kleen wrote:

> On Fri, Nov 06, 2009 at 12:08:54PM -0500, Christoph Lameter wrote:
> > On Fri, 6 Nov 2009, Andi Kleen wrote:
> >
> > > Yes but all the major calls still take mmap_sem, which is not ranged.
> >
> > But exactly that issue is addressed by this patch!
>
> Major calls = mmap, brk, etc.

Those are rare. More frequently are for faults, get_user_pages and
the like operations that are frequent.

brk depends on process wide settings and has to be
serialized using a processor wide locks.

mmap and other address space local modification may be able to avoid
taking mmap write lock by taking the read lock and then locking the
ptls in the page struct relevant to the address space being modified.

This is also enabled by this patchset.

> Only for page faults, not for anything that takes it for write.
>
> Anyways the better reader lock is a step in the right direction, but
> I have my doubts it's a good idea to make write really slow here.

The bigger the system the larger the problems with mmap. This is one key
scaling issue important for the VM. We can work on that. I have a patch
here that restricts the per cpu checks to only those cpus on which the
process has at some times run before.

