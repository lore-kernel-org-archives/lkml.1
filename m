Return-Path: <linux-kernel-owner+w=401wt.eu-S1161041AbXBTWru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041AbXBTWru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161043AbXBTWru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:47:50 -0500
Received: from smtp-out.google.com ([216.239.33.17]:61067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161041AbXBTWrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:47:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JVzUdpMPqQl4BOK93OGvbzCJAsKdmAi7FAdu5G2Q9drc7XQMNuM5qa3/oM+YPZReo
	qapYrgTwHJ6w4qpoPO8YA==
Message-ID: <6599ad830702201447t711cdf00u3704a0dac8780f91@mail.gmail.com>
Date: Tue, 20 Feb 2007 14:47:36 -0800
From: "Paul Menage" <menage@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: "Sam Vilain" <sam@vilain.net>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1bqjo4ogj.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	 <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
	 <m1bqjo4ogj.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Sam said "the NSProxy *is* the container". You appear to be planning
> > to have some namespaces, possibly not aggregated within the nsproxy
> > (pid namespace?) but are you planning to have some higher-level
> > "container" object that aggregates the nsproxy and the other
> > namespaces?
>
> No. A reverse mapping is not needed and is not interesting.

... to you.

> As long as I can walk all processes and ask what namespace are
> you in I don't care.

How do you currently do that?

>
> To me at least the interesting part of your work is not the aggregation
> portion.  But the infrastructure for building the different process
> groups.

In that case you can easily use it to just assign one namespace type
to each tree of process groups. The aggregation is something that
other groups find useful, but isn't required for the user to actually
make use of.

>
> You seem to be calling your groups of processes lumped together for
> one purpose or another a container.

Correct.

>
> We need a term for the non-aggregated case for the individual process
> groups we build this out of in your infrastructure.  Because you
> clearly have more than one kind of process group a set of processes
> can belong to.

Yes. That's why my system supports multiple unrelated hierarchies of groups.

> > I agree that namespaces fit slightly less well into this model than
> > some other subsystems like resource management. But by integrating
> > with it you'd get  automatic access to all the various different
> > resource controller work that's being done.
>
> I don't need to integrate with it to get access to the resource
> controller work.

Right, you could certainly do the extra work of tying your virtual
servers together with resource controllers in userspace. But you'd
still need an API to allow those resource controllers to be associated
with groups of processes and configured with limits/guarantees, which
is one of the main aims of my containers patch.

> Now I have some half backed ideas that might be useful for providing
> a better abstraction.  But it requires setting down and looking
> at the problem in detail, and understanding what people are trying
> to accomplish with these things they are building.  What subset of
> process groups do you find interesting.

I'm primarily interested in getting something in the kernel that can
be used as a base for interesting subsystems that apply behavioural or
QoS changes to defined groups of processes. Resource controllers and
namespaces seem to be good examples of this, but I can think of useful
subsystems for monitoring, permission control, etc.

>
> All that is necessary to have a group of processes do something
> in an unnamed fashion is to hang a pointer off of the task_struct.
> That's easy.

Right, adding a pointer to task_struct is easy. Configuring how/when
to not directly inherit it from the parent, or to change it for a
running task, or configuring state associated with the thing that the
pointer is pointing to, naming that group, and determining which group
a given process is assocaited with, is something that's effectively
repeated boiler plate for each different subsystem, and which can be
accomplished more generically via an abstraction like my containers
patch.

> You are adding a lot more to that, and there is

The main thing that I'm adding on top of the operations mentioned in
the previous paragraph, which pretty much essentially have to be in
the kernel, is the ability to group multiple different subsystems
together so that they share the same process->container mappings. Yes,
that is something that could potentially be done from userspace
instead, and just provide an independent tree for each subsystem or
namespace. But there seems to be interest from other parties
(including me) in having kernel support for it.

Paul
