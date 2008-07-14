Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYGNPIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYGNPIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGNPIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:08:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50932 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYGNPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:08:43 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <1357735.1216048029837.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 15 Jul 2008 00:07:09 +0900 (JST)
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Re: [RFC] How to handle the rules engine for cgroups
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20080714135719.GE16673@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20080714135719.GE16673@redhat.com>
 <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com> <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>On Fri, Jul 11, 2008 at 09:55:01AM +0900, KAMEZAWA Hiroyuki wrote:
>> On Thu, 10 Jul 2008 11:40:35 -0400
>> Vivek Goyal <vgoyal@redhat.com> wrote:
>> 
>> > On Thu, Jul 10, 2008 at 10:48:52AM -0400, Rik van Riel wrote:
>> > > On Thu, 10 Jul 2008 02:23:52 -0700
>> > > "Paul Menage" <menage@google.com> wrote:
>> > > 
>> > > > I don't see the rule-based approach being all that useful for our nee
ds.
>> > > 
>> > > Agreed, there really is no need for a rule-based approach in kernel spa
ce.
>> > > 
>> > > There are basically three different cases:
>> > > 
>> > > 1) daemons get started up in their own process groups, this can
>> > >    be handled by the initscripts
>> > > 
>> > > 2) user sessions (ssh, etc) start in their own process groups,
>> > >    this can be handled by PAM
>> > > 
>> > > 3) users fork processes that should go into special process
>> > >    groups - this could be handled by having a small ruleset
>> > >    in userspace handle things, right before calling exec(),
>> > 
>> > That means application launcher (ex, shell) is aware of the right cgroup
>> > targeted application should go in and then move forked pid to right
>> > cgroup and call exec? Or you had something else in mind?
>> >  
>> > >    it can even be hidden from the application by hooking into
>> > >    the exec() call
>> > > 
>> > 
>> > This means hooking into libc. So libc will parse rules file, determine
>> > the right cgroup, place application there and then call exec?
>> > 
>> 
>> Hmm, as I wrote, the rule that the child inherits its own parent't is very
>> strong rule. (Most of case can be handle by this.) So, what I think of is
>> 
>> 1. support a new command (in libcg.)
>>   - /bin/change_group_exec ..... read to /etc/cgroup/config and move cgroup
>>                                  and call exec.
>> 2. and libc function
>>   - if necessary.
>> 
>> 1. is enough because admin/user can write a wrapper script for their
>> applications if "child inherits parent's" isn't suitable.
>> 
>> no ?
>> 
>
>If admin has decided to group applications and has written the rules for
>it then applications should not know anything about grouping. So I think
>application writing an script for being placed into the right group should
>be out of question. Now how does an admin write a wrapper around existing
>application without breaking anything else.
>
Sure.

>One thing could be creating soft links where admin created alias points
>to wrapper and wrapper inturn invokes the executable. But this will not
>solve the problem if some user decides to invoke the application
>executable directly and not use admin created alias. 
>
yes. It's a hole.

>Did you have something else in mind when it came to creating wrappers
>around applications?
>

I have no strong idea around this but now it seems

 - handling complicated rules under the kernel will got amount of Nacks.
   (and it seems to add some latency.)
 - We cannot avoid the problem discussed here if we handle the rule in 
   userland daemon/process-event-connector.

So, I wonder adding some limitation may make things simple.

  - application under wrapper will be executed under a group defined by admin.
  - application without wrapper will be executed under a group where exec()
    called.

A point is that application-without-wrapper is also under Admin's control beca
use it's executed under a group which calls exec.

But this is not strict control..this is very loose ;)

Thanks,
-Kame

