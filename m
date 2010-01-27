Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713Ab0A0C65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0A0C65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0A0C64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:58:56 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:63575 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0A0C6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iSRUCcj/b+0GTHY/n9k1W8S7ztFB3xMOWuWvTRVChSEa1xNYNNbANMqDhEX2EKd9yA
         h0FnRA9bdNwb37aGK72lg+cvdINtK4gLZVxs8d8N0VEEyy3PbACnfcTB98RfLGfU0MIL
         AEW1b5mFwvB6kS6vNOGOK6AA08OhMsf4apM/4=
MIME-Version: 1.0
In-Reply-To: <20100126181641.GA10460@redhat.com>
References: <20100126121618.5AA5.A69D9226@jp.fujitsu.com>
	 <20100126181641.GA10460@redhat.com>
Date: Wed, 27 Jan 2010 10:58:54 +0800
Message-ID: <2375c9f91001261858y7fee9388o55a8e6f11fcdc0bf@mail.gmail.com>
Subject: Re: check_usage_backwards() && forwards? (Was: [2.6.33-rc5] starting 
	emacs makes lockdep warning)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 2:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> (add  lockdep gurus)
>
> Lockdep has found the real bug, but the output doesn't look right to me
>
> On 01/26, KOSAKI Motohiro wrote:
>>
>> =========================================================
>> [ INFO: possible irq lock inversion dependency detected ]
>> 2.6.33-rc5 #77
>> ---------------------------------------------------------
>> emacs/1609 just changed the state of lock:
>>  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
>> but this lock took another, HARDIRQ-unsafe lock in the past:
>>  (&(&sighand->siglock)->rlock){-.....}
>
> "HARDIRQ-unsafe" and "this lock took another" looks wrong, afaics.
>
>>   ... key      at: [<ffffffff81c054a4>] __key.46539+0x0/0x8
>>   ... acquired at:
>>    [<ffffffff81089af6>] __lock_acquire+0x1056/0x15a0
>>    [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
>>    [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
>>    [<ffffffff8127c1be>] __proc_set_tty+0x3e/0x150
>>    [<ffffffff8127e01d>] tty_open+0x51d/0x5e0
>
> The stack-trace shows that this lock (ctrl_lock) was taken under
> ->siglock (which is hopefully irq-safe).
>
> Typo in check_usage_backwards() ?
>
> Oleg.
>
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2147,7 +2147,7 @@ check_usage_backwards(struct task_struct
>                return ret;
>
>        return print_irq_inversion_bug(curr, &root, target_entry,
> -                                       this, 1, irqclass);
> +                                       this, 0, irqclass);
>  }
>
>  void print_irqtrace_events(struct task_struct *curr)
>
>

Yes!! Almost definitely... You are so careful!
ACK, please submit it as a normal patch.

Thanks.
