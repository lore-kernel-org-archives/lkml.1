Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbXGFQ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbXGFQ1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXGFQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:27:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44166 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbXGFQ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:27:01 -0400
Subject: Re: [PATCH 0/16] Pid namespaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <468DF6F7.1010906@openvz.org>
References: <468DF6F7.1010906@openvz.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 09:26:52 -0700
Message-Id: <1183739214.10287.127.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
> This is "submition for inclusion" of hierarchical, not kconfig
> configurable, zero overheaded ;) pid namespaces.

Pavel, I'm a bit disappointed that you went ahead and sent this.  I
thought that, perhaps, you might have brought up how displeased you were
with Suka's patches when we discussed them at OLS.  

Hold your horses there a bit.  This has "little" overhead for the common
case, which is a single level of pid namespaces.  That means that it is
quick to access the "global" pid which would be the one that the "host
container" sees.  It also provides quick access to the pid which a
containerized task gets when the task itself calls getpid().  This quick
access is provided by storing the values directly in the task struct.

However, when there is more than one level in the container hierarchy,
the optimization breaks down.  A process which exists in a three-level
hierarchy has slow access to the middle level pid.  Your approach stores
this information in a linked list, and surely *that* is going to have
overhead in fork().

> 2. Suka's patches have the limit of pid namespace nesting. 
>    My patches do not.

I wouldn't say it that bluntly.  Suka's patches have a configurable
limit simply because it makes the implementation simpler and faster.
There was also a version which dynamically allocated structures and had
no inherent limits, but this was _much_ simpler.  We could add dynamic
allocation to this in the future and only overflow into that case if we
overrun the static buffers.

That is, in effect, what your patches do.  They hard-code for a
two-level container, and dynamically allocate the levels after that.
Suka's patches allow for arbitrary (but, config-time fixed) depth to be
optimized for, and don't disallow a future dynamically-allocated
completely arbitrary depth. 

All of that said, I think that your approach would probably _work_ for
our needs.  I agree with Eric Biederman that your approach is a bit of a
hack (with the hard-coded optimization for two levels), but it would
certainly _work_, or we can make it work.  That said, is it possible for
Suka's to work for you?

> 3. Suka assumes that pid namespace can live without proc mount
>    and tries to make the code work with pid_ns->proc_mnt change
>    from NULL to not-NULL from times to times.
>    My code calls the kern_mount() at the namespace creation and
>    thus the pid_namespace always works with proc.

Have you run this by Al Viro and the other fs guys?  /proc is a weird
beast :)

-- Dave

