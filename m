Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYHZQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYHZQDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbYHZQDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:03:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506AbYHZQDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:03:20 -0400
Date: Tue, 26 Aug 2008 12:00:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: David Collier-Brown <davecb@sun.com>
Cc: balbir@linux.vnet.ibm.com, Paul Menage <menage@google.com>,
       righi.andrea@gmail.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Steve Olivieri <solivier@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes
	efficiently in the right cgroup
Message-ID: <20080826160007.GE30312@redhat.com>
References: <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com> <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com> <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com> <20080819125710.GA18972@redhat.com> <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com> <20080826134127.GA30312@redhat.com> <48B414A0.9000504@linux.vnet.ibm.com> <48B41B8A.70301@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B41B8A.70301@sun.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 11:04:42AM -0400, David Collier-Brown wrote:
> Balbir Singh wrote:
>> Applications that really care about moving should use cgroup_attach_task* and
>> move back otherwise with cgrules parsing turned off.
>>
>> I see control as a two level hierarchy, automatic and controlled, how do we make
>> sure that they don't conflict is something I have not thought about yet.
> [...]
>
>> Hmm... I wonder if we are providing too many knobs. Can't we do something simpler?
>
> Solaris doesn't try to change cgroup ("project") on a setuid call, assuming
> the program is in the proper cgroup initially.  For most cases this is
> trivially true under the very simple default rules, and for the rest one
> can create a rule or a startup script that sets it with newtask".
>

Who executes default rules? IOW, how do you make sure tasks of user.davecb
end up in project 101 only and not outside?

> The Sun default is
> 	$ cat /etc/project
> 	system:0::::
> 	user.root:1::::
> 	noproject:2::::
> 	default:3::::
> 	group.staff:10::::
>
> Which means that root users are distinguished from users in
> the staff group, and they are distinguished from daemons
> and everyone else.
>

Now Linux also will allow admin to specify simple rules in
/etc/cgrules.conf. Rules are based basically on premise that users/groups
own resources in a particular cgroup and one can specify which cgroup
the task should run in. For ex.

#john          cpu              usergroup/faculty/john/
#@student      cpu,memory       usergroup/student/
#@root          *               admingroup/
#*              *               default/

This simply means which user/group's tasks should run in what cgroup for
which controller. (There are some wild cards also). For details, you can
check out libcg-devel source tree and documentation files.

> Personally, I add
> 	user.davecb:101::davecb::
> 	bg:100:Background jobs:davecb::
> which puts me in a separate cgroup, and provides another one
> for me to put background tasks into.  The latter allows
> me to keep them from reducing the interactive performance of
> my laptop. 

So by default all the tasks of user.davecb will run into project 101 until
user davecb decides to launch some background jobs in project 100 using
newtask?

"newtask" like functionality is being provided by a new command line tool
"cgexec" which will allow launching of a new task in specific cgroup
(project).

Thanks
Vivek
