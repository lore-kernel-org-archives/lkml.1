Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYGCV75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYGCV75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbYGCV7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:59:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35911 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbYGCV7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:59:42 -0400
Subject: Re: Attaching PID 0 to a cgroup
From: Matt Helsley <matthltc@us.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080701215448.GD5893@linux.vnet.ibm.com>
References: <20080701094545.GD3925@linux.vnet.ibm.com>
	 <20080701094734.GE3925@linux.vnet.ibm.com>
	 <486A06B7.7020906@cn.fujitsu.com> <486AA62F.40503@gmail.com>
	 <20080701215448.GD5893@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 03 Jul 2008 14:59:35 -0700
Message-Id: <1215122375.14808.180.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-02 at 03:24 +0530, Dhaval Giani wrote:
> On Tue, Jul 01, 2008 at 11:48:31PM +0200, Andrea Righi wrote:
> > Li Zefan wrote:
> >> CC: Paul Jackson <pj@sgi.com>
> >>
> >> Dhaval Giani wrote:
> >>> [put in the wrong alias for containers list correcting it.]
> >>>
> >>> On Tue, Jul 01, 2008 at 03:15:45PM +0530, Dhaval Giani wrote:
> >>>> Hi Paul,
> >>>>
> >>>> Attaching PID 0 to a cgroup caused the current task to be attached to
> >>>> the cgroup. Looking at the code,
> >>>>
> >>
> >> [...]
> >>
> >>>> I was wondering, why this was done. It seems to be unexpected behavior.
> >>>> Wouldn't something like the following be a better response? (I've used
> >>>> EINVAL, but I can change it to ESRCH if that is better.)
> >>>>
> >>
> >> Why is it unexpected? it follows the behavior of cpuset, so this patch will
> >> break backward compatibility of cpuset.
> >>
> >> But it's better to document this.
> >>
> >> -----------------------------------------
> >>
> >> Document the following cgroup usage:
> >>  # echo 0 > /dev/cgroup/tasks
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> >> ---
> >>  cgroups.txt |    4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/Documentation/cgroups.txt b/Documentation/cgroups.txt
> >> index 824fc02..213f533 100644
> >> --- a/Documentation/cgroups.txt
> >> +++ b/Documentation/cgroups.txt
> >> @@ -390,6 +390,10 @@ If you have several tasks to attach, you have to do it one after another:
> >>  	...
> >>  # /bin/echo PIDn > tasks
> >>  +You can attach the current task by echoing 0:
> >> +
> >> +# /bin/echo 0 > tasks
> >> +
> >>  3. Kernel API
> >>  =============
> >
> > Wouldn't be more meaningful to specify the bash's builtin echo here
> > even if it doesn't opportunely handle write() errors?
> >
> > Using /bin/echo would attach /bin/echo itself to the cgroup, that just
> > exists, so it seems like a kind of noop, isn't it?
> >
> 
> Yes, you are right. this example should use bash's builtin echo.

	IMHO you need to include this point in the docs verbosely rather than
just switching the docs to bash's builin-in echo. Otherwise it doesn't
fully resolve the fundamental confusion you correctly identified.

Or perhaps a snippet of simplified C code will make it clear:
------------
	char buffer[16];
	int fd;

	fd = open("/some/cgroup/tasks", O_WRONLY);

	/* 
	 * These two writes produce the same effect: adding this process
	 * to /some/cgroup.
	 */
	if (the_slightly_shorter_way)
		write(fd, "0", 2);
	else {
		/* The slightly-less-short way */
		snprintf(buffer, 16, "%u", getpid());
		write(fd, buffer, strlen(buffer));
	}
------------

Cheers,
	-Matt Helsley

