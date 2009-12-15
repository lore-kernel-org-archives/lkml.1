Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbZLOPDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbZLOPDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbZLOPDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:03:43 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42661 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533AbZLOPDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:03:41 -0500
MIME-Version: 1.0
In-Reply-To: <20091215183533.1a1e87d9.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	 <cc557aab0912150111k41517b41t8999568db3bd8daa@mail.gmail.com>
	 <20091215183533.1a1e87d9.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 17:03:37 +0200
Message-ID: <cc557aab0912150703qcfe6458paa7da71cb032cb93@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/4] cgroup: implement eventfd-based generic API 
	for notifications
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:35 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 15 Dec 2009 11:11:16 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>
>> Could anybody review the patch?
>>
>> Thank you.
>
> some nitpicks.
>
>>
>> On Sat, Dec 12, 2009 at 12:59 AM, Kirill A. Shutemov
>> <kirill@shutemov.name> wrote:
>
>> > +       /*
>> > +        * Unregister events and notify userspace.
>> > +        * FIXME: How to avoid race with cgroup_event_remove_work()
>> > +        *        which runs from workqueue?
>> > +        */
>> > +       mutex_lock(&cgrp->event_list_mutex);
>> > +       list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
>> > +               cgroup_event_remove(event);
>> > +               eventfd_signal(event->eventfd, 1);
>> > +       }
>> > +       mutex_unlock(&cgrp->event_list_mutex);
>> > +
>> > +out:
>> >        return ret;
>> >  }
>
> How ciritical is this FIXME ?
> But Hmm..can't we use RCU ?

It's not reasonable to have RCU here, since event_list isn't mostly-read.
