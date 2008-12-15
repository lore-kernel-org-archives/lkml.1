Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYLOLdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYLOLdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYLOLdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:33:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:12231 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYLOLdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:33:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=G05y7UPMo1SQ/Q/L3Rd+JFI+T9BfE+c0tfuhhcThPpnthRSP34ocNyGzxOHoQQ3Das
         39M3za1aKyyfWW1UZEtoLvNsL/aYs9uoxft+WWyXDKqXrzHEICWiidJwfUVkttQdeAOc
         iHmYSGiXlISu+VExELm8+YuXmwO/IPf+ytdpE=
Message-ID: <4946406D.6000506@gmail.com>
Date: Mon, 15 Dec 2008 12:33:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: broken do_each_pid_{thread,task}
References: <494581D7.6000203@gmail.com> <20081215102415.GA11106@redhat.com> <49463679.7080306@gmail.com> <20081215110238.GA15606@redhat.com>
In-Reply-To: <20081215110238.GA15606@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov napsal(a):
> On 12/15, Jiri Slaby wrote:
>> Oleg Nesterov napsal(a):
>>> On 12/14, Jiri Slaby wrote:
>>>> I'm getting
>>>> `if (type == PIDTYPE_PID)' is unreachable
>>>> warning from kernel/exit.c. The preprocessed code looks like:
>>>> do {
>>>>          struct hlist_node *pos___;
>>>>          if (pgrp != ((void *)0))
>>>>                  for (LIST ITERATION) {
>>>>                          {
>>>>                           if (!((p->state & 4) != 0))
>>>>                            continue;
>>>>                           retval = 1;
>>>>                           break;
>>>>                          }
>>>>                          if (PIDTYPE_PGID == PIDTYPE_PID)
>>>>                                  break;
>>>>                  }
>>>> } while (0);
>>>> and it's obviously wrong.
>>> Why do you think it is wrong? This break stops the "hlist_for_each"
>>> loop, not the enclosing "do while".
>> The `continue' matters here (and also in other do_each_pid_task cases).
>> Sorry for not mentioning it explicitly.
> 
> Still can't understand... OK, I think we misundersood each other.
> Do you agree that the code is technically correct? Or I missed
> something?
> 
> "continue" looks fine to me too, it is also for the inner loop.

But it doesn't jump to the `if' (this is what I would expect from the
`continue' here), but to the third statement of the `for'.

Maybe better to ask, is the test expected to be fired after *each*
invocation of the body?

>>> Actually, I don't understand why the compiler complains, and I never
>>> saw a warning myself.
>> Because the `if' is not reachable :).
> 
> Yes, I see it is not reachable, but I don't understand why this
> deserves a warning ;)
> 
> Look, "if (PIDTYPE_PGID == PIDTYPE_PID)" is not possible too, should
> the compiler (or whatever) complain?

Correct, in this particular case (and I checked that also other users which
uses `continue' inside the loop don't pass PIDTYPE_PID).

>> (And it's not compiler which complains
>> here.)
> 
> Ah, OK, thanks. Just curious, and who does?

A static analyzer. Stay tuned, we will announce it later, it's in the state
of development :).
