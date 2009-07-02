Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZGBHXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZGBHXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZGBHWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:22:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZGBHWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:22:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=e1l0dqOIOzg4xT1Wz8yyjriQN9/aqwC4k09SczWv8ojI/3uRa/5w4XBIbhB2R6AVN
	H8JSLE0SlMTXd/tekecRQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830907011956i33769d5ek5401e93553d75c59@mail.gmail.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021133.14469.35140.stgit@menage.mtv.corp.google.com>
	 <20090702114829.df04c885.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907011956i33769d5ek5401e93553d75c59@mail.gmail.com>
Date: Thu, 2 Jul 2009 00:22:43 -0700
Message-ID: <6599ad830907020022y106a2d8epf78d8ce67ebe7c9a@mail.gmail.com>
Subject: Re: [PATCH 8/9] [RFC] Example multi-bindable subsystem: a per-cgroup 
	notes field
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 7:56 PM, Paul Menage<menage@google.com> wrote:
>> Hmm, do we need to this "info" file as subsys ? How about making this as
>> default file set ? (if there are users.)
>>
>
> That would certainly be possible, and would be an alternative to
> having multi-bindable subsystem support.
>
> The advantage of adding multi-bindable subsystems is that you can
> avoid bloating the core cgroups code, by putting individual small
> cgroups features in their own code modules, and you get to decide at
> mount time which features are actually mounted; if they were part of
> the core cgroups files, then there would either need to be special
> mount options for each separate feature, or else no way to pick which
> features were mounted on each hierarchy.

BTW, just to give a balanced argument: I agree that these example
multi-bindable subsystems are somewhat weak justifications for the new
feature - they each supply a single control file, they're not
connected to anything in the kernel outside of the core cgroups
framework, and they're almost zero overhead if they're not actively
used, so making them part of the cgroups framework directly wouldn't
be totally unreasonable.

An example of a less-trivial multi-bindable subsystem could be cpuacct
- logically there's no reason that you couldn't track CPU usage in
multiple different hierarchies, keeping totals aggregated in different
ways for the groupings in different hierarchies, and the overhead
associated with tracking would mean that you wouldn't want to
automatically link cpuacct into every hierarchy. The practical problem
with this would be that finding the cgroup for a process would be
slower since there wouldn't be a 1:1 mapping from a task to a cpuacct
cgroup state object.

Instead each task would have multiple such states and to update the
usage accounting on each of them you'd have to do a list traversal
rather than a direct lookup (and worse, right now that list traversal
can only be done while holding cgroup_mutex, which is impossible when
doing cpuacct charging from the guts of the scheduler). I can see how
to extend the multi-bindable support to make it cheaper and to require
less synchronization (i.e. walking an RCU-safe array to find the
various state objects rather than doing a list traversal).

Although before doing that I guess it would be worth asking whether
anyone would actually *want* to aggregate CPU usage different ways for
different hierarchies, even if it makes logical sense to be able to do
so.

Paul
