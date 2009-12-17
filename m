Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbZLQLlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbZLQLlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZLQLlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:41:35 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:37159 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbZLQLle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bu/diJ9c6LCmm68D4mZ8OerzpFy2eqeBY9ucN85O3ez/UuZxYtrBTgntzSs0E9FkiL
         lw7/AH6tcGhHnPGBm2/RmPZORiOEariMM3tG2eSKKBzqgrycup0MQ+1RqJvj/7e/FOWs
         bxQoDLu/vL1bucnU+yO23Ly6/PvFKGOXk9u4k=
MIME-Version: 1.0
In-Reply-To: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
Date: Thu, 17 Dec 2009 12:41:32 +0100
Message-ID: <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com>
Subject: Re: [RFC] CFQ group scheduling structure organization
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wed, Dec 16, 2009 at 11:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi All,
>
> With some basic group scheduling support in CFQ, there are few questions
> regarding how group structure should look like in CFQ.
>
> Currently, grouping looks as follows. A, and B are two cgroups created by
> user.
>
> [snip]
>
> Proposal 4:
> ==========
> Treat task and group at same level. Currently groups are at top level and
> at second level are tasks. View the whole hierarchy as follows.
>
>
>                        service-tree
>                        /   |  \  \
>                       T1   T2  G1 G2
>
> Here T1 and T2 are two tasks in root group and G1 and G2 are two cgroups
> created under root.
>
> In this kind of scheme, any RT task in root group will still be system
> wide RT even if we create groups G1 and G2.
>
> So what are the issues?
>
> - I talked to few folks and everybody found this scheme not so intutive.
>  Their argument was that once I create a cgroup, say A,  under root, then
>  bandwidth should be divided between "root" and "A" proportionate to
>  the weight.
>
>  It is not very intutive that group is competing with all the tasks
>  running in root group. And disk share of newly created group will change
>  if more tasks fork in root group. So it is highly dynamic and not
>  static hence un-intutive.
>
>  To emulate the behavior of previous proposals, root shall have to create
>  a new group and move all root tasks there. But admin shall have to still
>  keep RT tasks in root group so that they still remain system-wide.
>
>                        service-tree
>                        /   |    \  \
>                       T1  root  G1 G2
>                            |
>                            T2
>
>  Now admin has specifically created a group "root" along side G1 and G2
>  and moved T2 under root. T1 is still left in top level group as it might
>  be an RT task and we want it to remain RT task systemwide.
>
>  So to some people this scheme is un-intutive and requires more work in
>  user space to achive desired behavior. I am kind of 50:50 between two
>  kind of arrangements.
>
This is the one I prefer: it is the most natural one if you see that
groups are scheduling entities like any other task.
I think it becomes intuitive with an analogy with a qemu (e.g. kvm)
virtual machine model. If you think a group like a virtual machine, it
is clear that for the normal system, the whole virtual machine is a
single scheduling entity, and that it has to compete with other
virtual machines (as other single entities) and every process in the
real system (those are inherently more important, since without the
real system, the VMs cannot simply exist).
Having a designated root group, instead, resembles the xen VM model,
where you have a separated domain for each VM and for the real system.

I think the implementation of this approach can make the code simpler
and modular (CFQ could be abstracted to deal with scheduling entities,
and each scheduling entity could be defined in a separate file).
Within each group, you will now have the choice of how to schedule its
queues. This means that you could possibly have different I/O
schedulers within each group, and even have sub-groups within groups.
>
> I am looking for some feedback on what makes most sense.
I think that regardless of our preference, we should coordinate with
how the CPU scheduler works, since I think the users will be more
surprised to see cgroups behaving different w.r.t. CPU and disk, than
if the RT task behaviour changes when cgroups are introduced.

Thanks,
Corrado

>
> For the time being, I am little inclined towards proposal 2 and I have
> implemented a proof of concept version on top of for-2.6.33 branch in block
> tree.  These patches are compile and boot tested only and I have yet to do
> testing.
>
> Thanks
> Vivek
>
