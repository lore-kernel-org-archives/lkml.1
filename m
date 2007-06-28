Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbXF1V2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbXF1V2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760824AbXF1V2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:28:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52291 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759994AbXF1V2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:28:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oE7U4hkfYMswk1GG6TaiVEA1Bm1YN++y26vfSUoxYxufAumMxA2gBZw7+olzzkmHz
	Vz5ucM0cGaciFgzbUglbA==
Message-ID: <6599ad830706281427m36f5b0eft7a677cf0feada663@mail.gmail.com>
Date: Thu, 28 Jun 2007 17:27:25 -0400
From: "Paul Menage" <menage@google.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: "Andrew Morton" <akpm@linux-foundation.org>, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       pj@sgi.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
In-Reply-To: <20070530073959.GC6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529130104.461765000@menage.corp.google.com>
	 <20070530001455.45cf1dc5.akpm@linux-foundation.org>
	 <20070530073959.GC6909@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> On Wed, May 30, 2007 at 12:14:55AM -0700, Andrew Morton wrote:
> > So how do we do this?
> > Is there any sneaky way in which we can modify the kernel so that this new
> > code gets exercised more?  Obviously, tossing init into some default
> > system-wide container would be a start.  But I wonder if we can be
> > sneakier - for example, create a new container on each setuid(), toss the
> > task into that.  Or something along those lines?
>
> How about a container for each thread group, pgrp, session, and user?
>

I've been thinking about this, and figured that it could be quite
useful to be able to mount a container tree that groups tasks by
userid or thread group - for doing per-user resource controls, for
example, without having to write a controller that specifically
handles the per-user case.

One option would be to add a mount option, something like

mount -t container -ogroupkey=<X>

where X could be one of: uid, gid, pgrp, sid, tgid

And put hooks in the various places where these ids could change, in
order to move tasks between contaners as appropriate.  But after some
thought it seems to me that this is putting complexity in the kernel
that probably doesn't belong there, and additionally is probably not
sufficently flexible for some real-life situations. (E.g. the user
wants all users in the "student" group to be lumped into the same
container, but each user in the "professor" group gets their own
container).

So maybe this would be better handled in userspace? Have a daemon
listing on a process connector socket, and move processes between
containers based on notifications from the connector and user-defined
rules.

We'd probably also want to add some new connector events, such as
PROC_EVENT_PGRP, and PROC_EVENT_SID

A simple daemon that handles the case where we're classifying based on
a single key with no complex rules shouldn't be too hard to write.

It also sounds rather like the classification engine that
ResourceGroups had originally in the kernel and moved to userspace, so
I'll take a look at that and see if it's adaptable for this.

Paul
