Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYLOKvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYLOKvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYLOKux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:50:53 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:59494 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbYLOKuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SoJs2GReicvA5x/ZyCfQkFJMOmQTuXmR7K+qdWSLz3ERQ8ZUYMrBy9bs2PatfZ8uM6
         0qI/iDGMNXzK/EJ8S8vZPWloE0YH1v+n8F9i4q/2eBtsTyqGxbxo+aj3/o087jeV1I5P
         /5mtCpCiX+9I54edTuTYHQKRE/GxgEIh2yc8I=
Message-ID: <49463679.7080306@gmail.com>
Date: Mon, 15 Dec 2008 11:50:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: broken do_each_pid_{thread,task}
References: <494581D7.6000203@gmail.com> <20081215102415.GA11106@redhat.com>
In-Reply-To: <20081215102415.GA11106@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov napsal(a):
> On 12/14, Jiri Slaby wrote:
>> I'm getting
>> `if (type == PIDTYPE_PID)' is unreachable
>> warning from kernel/exit.c. The preprocessed code looks like:
>> do {
>>          struct hlist_node *pos___;
>>          if (pgrp != ((void *)0))
>>                  for (LIST ITERATION) {
>>                          {
>>                           if (!((p->state & 4) != 0))
>>                            continue;
>>                           retval = 1;
>>                           break;
>>                          }
>>                          if (PIDTYPE_PGID == PIDTYPE_PID)
>>                                  break;
>>                  }
>> } while (0);
>> and it's obviously wrong.
> 
> Why do you think it is wrong? This break stops the "hlist_for_each"
> loop, not the enclosing "do while".

The `continue' matters here (and also in other do_each_pid_task cases).
Sorry for not mentioning it explicitly.

> Actually, I don't understand why the compiler complains, and I never
> saw a warning myself.

Because the `if' is not reachable :). (And it's not compiler which complains
here.)

>> After investigating this code usage all around, it's broken on many places
>> this or similar way.
>>
>> For do_each_pid_thread(), even this code snippet from fs/ioprio.c is broken
>> due to double do {} while expansion:
>> do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
>>   ret = set_task_ioprio(p, ioprio);
>>   if (ret)
>>     break;
>> } while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
> 
> Yes, this is obviously not what was intended. But afaics, this is
> the only place which should be fixed?

Actually yes. And add a big warning to the macros or whatever to not get
into it later again.
