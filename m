Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243Ab0BZEuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 23:50:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65409 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935221Ab0BZEuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 23:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bxGbceQCmmHgQkSr9YeGYuSOaNV1jTSqxBtkcMdIfL0WNeB4fm7OaVOmdNUa9i+PVh
         ruD9HyUzkGGwTlRWvUH5pGHzHu+SB3GcRvqs+Y9htRn/pqNrMQcWL07qne4F9hRLWqlp
         teSY9CQ4/cMJMrLhbH6qAMoEkwlvj9nfQ5hmk=
MIME-Version: 1.0
In-Reply-To: <20100226092339.1f639cbf.kamezawa.hiroyu@jp.fujitsu.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
	 <1266765525-30890-2-git-send-email-arighi@develer.com>
	 <alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
	 <20100221221700.GA5233@linux> <20100222180732.GC3096@redhat.com>
	 <20100223115846.GI1882@linux>
	 <28c262361002250736k57543379j8291e0dfb8df194e@mail.gmail.com>
	 <20100226092339.1f639cbf.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 26 Feb 2010 13:50:04 +0900
Message-ID: <28c262361002252050r29f54ea2u6c6e87f1f702d195@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting 
	infrastructure
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>, Vivek Goyal <vgoyal@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Fri, Feb 26, 2010 at 9:23 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 26 Feb 2010 00:36:15 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Hi
>>
>> On Tue, Feb 23, 2010 at 8:58 PM, Andrea Righi <arighi@develer.com> wrote:
>> > On Mon, Feb 22, 2010 at 01:07:32PM -0500, Vivek Goyal wrote:
>> >> > > > +unsigned long mem_cgroup_dirty_bytes(void)
>> >> > > > +{
>> >> > > > +       struct mem_cgroup *memcg;
>> >> > > > +       unsigned long dirty_bytes;
>> >> > > > +
>> >> > > > +       if (mem_cgroup_disabled())
>> >> > > > +               return vm_dirty_bytes;
>> >> > > > +
>> >> > > > +       rcu_read_lock();
>> >> > > > +       memcg = mem_cgroup_from_task(current);
>> >> > > > +       if (memcg == NULL)
>> >> > > > +               dirty_bytes = vm_dirty_bytes;
>> >> > > > +       else
>> >> > > > +               dirty_bytes = get_dirty_bytes(memcg);
>> >> > > > +       rcu_read_unlock();
>> >> > >
>> >> > > The rcu_read_lock() isn't protecting anything here.
>> >> >
>> >> > Right!
>> >>
>> >> Are we not protecting "memcg" pointer using rcu here?
>> >
>> > Vivek, you are right:
>> >
>> >  mem_cgroup_from_task() -> task_subsys_state() -> rcu_dereference()
>> >
>> > So, this *must* be RCU protected.
>>
>> So, Doesn't mem_cgroup_from_task in mem_cgroup_can_attach need RCU, too?
>>
> Hm ? I don't read the whole thread but can_attach() is called under
> cgroup_mutex(). So, it doesn't need to use RCU.

Vivek mentioned memcg is protected by RCU if I understand his intention right.
So I commented that without enough knowledge of memcg.
After your comment, I dive into the code.

Just out of curiosity.

Really, memcg is protected by RCU?
I think most of RCU around memcg is for protecting task_struct and
cgroup_subsys_state.
The memcg is protected by cgroup_mutex as you mentioned.
Am I missing something?

> Thanks,
> -Kame
>
>
>



-- 
Kind regards,
Minchan Kim
