Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYB1W06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYB1W06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYB1W0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:26:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYB1W0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:26:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cUUaJSXb5ExEUEzPzhW60Fs+FNcJe8BIC3nKRxp+QSYS/Lqz67fNerdbEBfZ8fvkR
	Tg3CAzjOEjqycebk6VSCw==
Message-ID: <6599ad830802281426sc048e0ehc2ac09631c3c1d0d@mail.gmail.com>
Date: Thu, 28 Feb 2008 14:26:39 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, xemul@openvz.org,
       pj@sgi.com
In-Reply-To: <20080228142100.2dce0e46.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228132142.4d4b1eef.akpm@linux-foundation.org>
	 <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
	 <20080228134027.05b2aa87.akpm@linux-foundation.org>
	 <6599ad830802281406t38e486d8g267df1873bc754c2@mail.gmail.com>
	 <20080228142100.2dce0e46.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 2:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 28 Feb 2008 14:06:30 -0800
>
> "Paul Menage" <menage@google.com> wrote:
>
>
>
> > On Thu, Feb 28, 2008 at 1:40 PM, Andrew Morton
>  > <akpm@linux-foundation.org> wrote:
>  > >
>  > >  Maybe cgroups shouldn't be putting kernel-generated files in places where
>  > >  user-specified files appear?
>  > >
>  >
>  > Well, that API (mixing control files and group directories in the same
>  > directory namespace) was inherited directly from cpusets.
>  >
>  > It wouldn't be hard to throw that away and move all the user-created
>  > group directories into their own subdirectory, i.e. change the
>  > existing directory layout from something like:
>  >
>  > /mnt/cgroup/
>  >     tasks
>  >     cpu.shares
>  >     memory.limit_in_bytes
>  >     memory.usage_in_bytes
>  >     user_created_groupname1/
>  >         tasks
>  >         cpu.shares
>  >         memory.limit_in_bytes
>  >         memory.usage_in_bytes
>  >     user_created_groupname2/
>  >         tasks
>  >         cpu.shares
>  >         memory.limit_in_bytes
>  >         memory.usage_in_bytes
>  >
>  > to something like:
>  >
>  > /mnt/cgroup/
>  >     tasks
>  >     cpu.shares
>  >     memory.limit_in_bytes
>  >     memory.usage_in_bytes
>  >     groups/
>  >         user_created_groupname1/
>  >             tasks
>  >             cpu.shares
>  >             memory.limit_in_bytes
>  >             memory.usage_in_bytes
>  >             groups/
>  >         user_created_groupname2/
>  >             tasks
>  >             cpu.shares
>  >             memory.limit_in_bytes
>  >             memory.usage_in_bytes
>  >             groups/
>
>  That looks nice.
>

I'll put a patch together for consideration.

>  Could we do something like auto-prefixing user-created directories with a
>  fixed string so that there is no way in which the user can cause a
>  collision with kernel-created files?

That's something like putting them all in their own sub-directory, but
sounds less clean to me.

>
>  I suppose that would break cpusets back-compatibility as well?  If so, we
>  could do the prefixing only for non-cpusets directories, but that's getting
>  a bit weird.

We already have something like that in place, actually.

When you mount the legacy "cpuset" filesystem, it just passes through
to the cgroup filesystem with the mount options "cpuset,noprefix",
i.e. mount a cgroups hierarcy with just cpusets bound to it, and
*don't* prefix subsystem control files with the subsystem name. It
wouldn't be hard to also have a "nosubdir" mount option that keeps the
existing single-level style, have the cpuset filessytem pass that
option.

Paul
