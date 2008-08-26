Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYHZPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYHZPDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 11:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYHZPDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 11:03:13 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:55599 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYHZPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 11:03:11 -0400
Date: Tue, 26 Aug 2008 11:04:42 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes
 efficiently in the right cgroup
In-reply-to: <48B414A0.9000504@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Menage <menage@google.com>,
       righi.andrea@gmail.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Steve Olivieri <solivier@redhat.com>
Reply-to: davecb@sun.com
Message-id: <48B41B8A.70301@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080710104852.797fe79c@cuia.bos.redhat.com>
 <20080710154035.GA12043@redhat.com>
 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
 <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
 <20080819125710.GA18972@redhat.com>
 <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com>
 <20080826134127.GA30312@redhat.com> <48B414A0.9000504@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Applications that really care about moving should use cgroup_attach_task* and
> move back otherwise with cgrules parsing turned off.
> 
> I see control as a two level hierarchy, automatic and controlled, how do we make
> sure that they don't conflict is something I have not thought about yet.
[...]

> Hmm... I wonder if we are providing too many knobs. Can't we do something simpler?

Solaris doesn't try to change cgroup ("project") on a setuid call, assuming
the program is in the proper cgroup initially.  For most cases this is
trivially true under the very simple default rules, and for the rest one
can create a rule or a startup script that sets it with newtask".

The Sun default is
	$ cat /etc/project
	system:0::::
	user.root:1::::
	noproject:2::::
	default:3::::
	group.staff:10::::

Which means that root users are distinguished from users in
the staff group, and they are distinguished from daemons
and everyone else.

Personally, I add
	user.davecb:101::davecb::
	bg:100:Background jobs:davecb::
which puts me in a separate cgroup, and provides another one
for me to put background tasks into.  The latter allows
me to keep them from reducing the interactive performance of
my laptop. 

  In practice, this looks like:

$ prstat -J
PID USERNAME  SIZE   RSS STATE  PRI NICE      TIME  CPU PROCESS/NLWP
   695 davecb     52M   38M sleep    1    0   0:01:41 2.4% Xsun/1
  1025 davecb    150M   88M sleep   59    0   0:04:25 1.9% mozilla-bin/5
   926 davecb     73M   16M sleep   33    0   0:00:11 1.3% gnome-terminal/2
  1067 davecb   6232K 5224K cpu0    54    0   0:00:00 0.3% prstat/1
   918 davecb     66M   15M sleep   59    0   0:00:15 0.2% metacity/1
   956 davecb     67M   13M sleep   59    0   0:00:04 0.1% gnome-netstatus/1
   958 davecb     66M   12M sleep   59    0   0:00:02 0.1% mixer_applet2/1
   931 root     2112K 1240K sleep   59    0   0:00:01 0.0% rpc.rstatd/1
   954 davecb     68M   15M sleep   57    0   0:00:06 0.0% wnck-applet/1
   920 davecb     71M   17M sleep   59    0   0:00:04 0.0% gnome-panel/1
   943 davecb   1408K 1136K sleep   57    0   0:00:00 0.0% ksh/1
   871 davecb   3984K 2656K sleep   59    0   0:00:01 0.0% xscreensaver/1
   916 davecb     10M 4936K sleep   59    0   0:00:01 0.0% gnome-smproxy/1
   924 davecb     67M   13M sleep   59    0   0:00:01 0.0% gnome-perfmeter/1
   116 root     4352K 1168K sleep   59    0   0:00:00 0.0% lp/1
PROJID    NPROC  SIZE   RSS MEMORY      TIME  CPU PROJECT
   101       32 1050M  352M    71%   0:07:02 6.4% user.davecb
     0       49  192M   73M    15%   0:00:22 0.1% system
     3        5   33M   11M   2.2%   0:00:00 0.0% default

I'm using 6.4% of the CPU, the daemons are using 0.1% and even a 
terribly CPU-heavy program will not starve the others of resources.
So for me, cgroups/projects are golden, and the simplest rules
suffice.

--dave   
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
