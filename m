Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbXCHAuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbXCHAuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXCHAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:50:12 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:60848 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXCHAuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:50:09 -0500
Message-ID: <45EF5DB9.50606@vilain.net>
Date: Thu, 08 Mar 2007 13:50:01 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: vatsa@in.ibm.com
Cc: Paul Menage <menage@google.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com>
In-Reply-To: <20070307173031.GC2336@in.ibm.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> container structure in your patches provides for these things:
>
> a.  A way to group tasks
> b.  A way to maintain several hierarchies of such groups
>
> If you consider just a. then I agree that container abstraction is
> redundant, esp for vserver resource control (nsproxy can already be used
> to group tasks).
>
> What nsproxy doesn't provide is b - a way to represent hierarchies of
> groups. 
>   

Well, that's like saying you can't put hierarchical data in a relational
database.

The hierarchy question is an interesting one, though. However I believe
it first needs to be broken down into subsystems and considered on a
subsystem-by-subsystem basis again, and if general patterns are
observed, then a common solution should stand out.

Let's go back to the namespaces we know about and discuss how
hierarchies apply to them. Please those able to brainstorm, do so - I
call green hat time.

1. UTS namespaces

Can a UTS namespace set any value it likes?

Can you inspect or set the UTS namespace values of a subservient UTS
namespace?

2. IPC namespaces

Can a process in an IPC namespace send a signal to those in a
subservient namespace?

3. PID namespaces

Can a process in a PID namespace see the processes in a subservient
namespace?

Do the processes in a subservient namespace appear in a higher level
namespace mapped to a different set of PIDs?

4. Filesystem namespaces

Can we see all of the mounts in a subservient namespace?

Does our namespace receive updates when their namespace mounts change?
(perhaps under a sub-directory)

5. L2 network namespaces

Can we see or alter the subservient network namespace's
interfaces/iptables/routing?

Are any of the subservient network namespace's interfaces visible in our
namespace, and by which mapping?

6. L3 network namespaces

Can we bind to a subservient network namespace's addresses?

Can we give or remove addresses to and from the subservient network
namespace's namespace?

Can we allow the namespace access to modify particular IP tables?

7. resource namespaces

Is the subservient namespace's resource usage counting against ours too?

Can we dynamically alter the subservient namespace's resource allocations?

8. anyone else?

So, we can see some general trends here - but it's never quite the same
question, and I think the best answers will come from a tailored
approach for each subsystem.

Each one *does* have some common questions - for instance, "is the
namespace allowed to create more namespaces of this type". That's
probably a capability bit for each, though.

So let's bring this back to your patches. If they are providing
visibility of ns_proxy, then it should be called namesfs or some such.
It doesn't really matter if processes disappear from namespace
aggregates, because that's what's really happening anyway. The only
problem is that if you try to freeze a namespace that has visibility of
things at this level, you might not be able to reconstruct the
filesystem in the same way. This may or may not be considered a problem,
but open filehandles and directory handles etc surviving a freeze/thaw
is part of what we're trying to achieve. Then again, perhaps some
visibility is better than none for the time being.

If they are restricted entirely to resource control, then don't use the
nsproxy directly - use the structure or structures which hang off the
nsproxy (or even task_struct) related to resource control.

Sam.
