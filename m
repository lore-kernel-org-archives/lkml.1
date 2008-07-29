Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYG2L6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYG2L6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYG2L6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:58:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42674 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYG2L6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c7swhWRflO3QJrbmowNAjdU0VObQm/1CT1Tld1F39o3rU/Z1NZwc4ZBWnDy5ktekNv
         lXSflGrzYwxFQGKP+Bcbb/6JZ98WZG3xjRNOYJETlHnN+Ri9zRHyNsGqsvg3GVnTKcVh
         uzV5bUeFNndTZQHsOmp5rjfDJ/n0lE/Fl7Lqo=
Message-ID: <b647ffbd0807290458n23dbe79et45cb27273e4fc2ae@mail.gmail.com>
Date: Tue, 29 Jul 2008 13:58:02 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [patch, minor] workqueue: consistently use 'err' in __create_workqueue_key()
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080729110250.GA177@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217277694.20627.9.camel@earth> <20080729110250.GA177@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/29 Oleg Nesterov <oleg@tv-sign.ru>:
> On 07/28, Dmitry Adamushko wrote:
>>
>> I guess error handling is a bit illogical in __create_workqueue_key()
>
> Please see below,
>
>>               for_each_possible_cpu(cpu) {
>>                       cwq = init_cpu_workqueue(wq, cpu);
>> -                     if (err || !cpu_online(cpu))
>> +                     if (!cpu_online(cpu))
>>                               continue;
>>                       err = create_workqueue_thread(cwq, cpu);
>> +                     if (err)
>> +                             break;
>
> This was done on purpose. The code above does init_cpu_workqueue(cpu)
> for each possible cpu, even if we fail to create cwq->thread for some
> cpu. This way destroy_workqueue() (called below) shouldn't worry about
> the partially initialized workqueues.
>
> The patch above should work, but it assumes that destroy_workqueue()
> must do nothing with cwq if cwq->thread == NULL, this is not very
> robust.

Yes, I saw this test and that's why I decided that destroy_workqueue()
is able (designed) to deal with partially-initialized objects.

Note, for the race scenario with cpu-hotplug (which I've overlooked
indeed) which you describe below, we also seem to depend on the same
"cwq->thread == NULL" test in cleanup_workqueue_thread() as follows:

assume, cpu_down(cpu) -> CPU_POST_DEAD -> cleanup_workqueue_thread()
gets called for a partially initialized workqueue for 'cpu' for which
create_workqueue_thread() has previously failed in
create_worqueue_key().

>
> And, more importantly. Let's suppose __create_workqueue_key() does
> "break" and drops cpu_add_remove_lock. Then we race with cpu-hotplug
> which can hit the uninitialized cwq. This is fixable, but needs other
> complication.

And I'd say this behavior (of having a partially-created object
visible to the outside world) is not that robust. e.g. the
aforementioned race would be eliminated if we place a wq on the global
list only when it's been successfully initialized.

For this goal, the cleanup path in __create_workqueue_key() would need
to be altered but overall, I think it'd make the code a bit more
straightforward.

[ just my 0.02, maybe I'm missing something again ;-) ]



>
> Oleg.
>


-- 
Best regards,
Dmitry Adamushko
