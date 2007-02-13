Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXBMNUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXBMNUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXBMNUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:20:00 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35273 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXBMNT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:19:59 -0500
Date: Tue, 13 Feb 2007 18:49:45 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Message-ID: <20070213131945.GB4252@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.485337000@menage.corp.google.com> <20070212152738.GD7526@in.ibm.com> <6599ad830702121040m7d39ad1u1210002dea702902@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830702121040m7d39ad1u1210002dea702902@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 10:40:52AM -0800, Paul Menage wrote:
> I did consider that approach at one point. The reason I rejected it
> was that then container->count would no longer even vaguely represent
> the number of processes in a container. Now that we have the
> container_group object, we have to use that for counting the number of
> processes in a container anyway, so that objection goes away.

Yep.

> However, I think it's important to be able to provide some kind of a
> reference count that subsystems can grab (e.g. to store a reference in
> a non-task object such as a file struct) without taking manage_mutex
> or callback_mutex (since that would be excessively heavyweight) but
> which can still be "frozen" at zero at the point when you're trying to
> destroy a container. 

Well, we already bump up reference count in fork() w/o grabbing those
mutexes don't we? Also if rmdir() sees container->count to be zero, then
it means no task is attached to the container. How will then a function
like bc_file_charge() bump up the reference count to such a container
(presuming it wanted to do so w/o manage/callback mutexes -and- that the
container pointer in bc_file_charge is derived from some task in 
that container). I think it is safe to bump up container->count in
bc_file_charge w/o grabbing manage/callback mutexes.

> Additionally, having it per subsystem will be
> important for when we implement arbitrary binding/unbinding of
> subsystems from hierarchies - at that point we need to be able know
> which subsystems have external reference counts, and hence aren't
> removeable.

Are you talking about (un)bind of subsystem to/from hierararchies that
have non-zero containers in them? That sounds very icky. Anyway that
doesnt seem to be supported in current patches.

Basically I felt we should defer introducing css_get/put until we find a good 
user for it, (and bc_file_(un)charge dont seem to be good users of it-
see above).



-- 
Regards,
vatsa
