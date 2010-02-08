Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0BHHHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:07:50 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:11957 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0BHHHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:07:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pWYC8Qiwp4AanBANiNgqm4hXvBc5BKbYbb0342LxG6ALnEgEKUxOhCXPSmqFKQ07GK
         4V+3Ro+jxPnU1aGHpbZ3uXkjklSSQUaPzud+1qys5Airaokxwtmgb7ePKhSncVEfJ/aU
         4pryiNea5AJGSSonmEeIHkP/NF9Y3GORH6nD0=
MIME-Version: 1.0
In-Reply-To: <20100208145240.FB58.A69D9226@jp.fujitsu.com>
References: <20100208141716.FB55.A69D9226@jp.fujitsu.com>
	 <9729.1265607469@neuling.org>
	 <20100208145240.FB58.A69D9226@jp.fujitsu.com>
Date: Mon, 8 Feb 2010 15:07:47 +0800
Message-ID: <2375c9f91002072307h4af1ba6dw1b7a598582991dc4@mail.gmail.com>
Subject: Re: [PATCH] Restrict stack space reservation to rlimit
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Neuling <mikey@neuling.org>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 2:05 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> --- linux-2.6-ozlabs.orig/fs/exec.c
>> +++ linux-2.6-ozlabs/fs/exec.c
>> @@ -627,10 +627,13 @@ int setup_arg_pages(struct linux_binprm
>>                       goto out_unlock;
>>       }
>>
>> +     stack_base = min(EXTRA_STACK_VM_PAGES * PAGE_SIZE,
>> +                      current->signal->rlim[RLIMIT_STACK].rlim_cur -
>> +                        PAGE_SIZE);
>
> This line is a bit unclear why "- PAGE_SIZE" is necessary.
> personally, I like following likes explicit comments.
>
>        stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
>        stack_lim = ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur);
>
>        /* Initial stack must not cause stack overflow. */
>        if (stack_expand + PAGE_SIZE > stack_lim)
>                stack_expand = stack_lim - PAGE_SIZE;
>
> note: accessing rlim_cur require ACCESS_ONCE.
>
>
> Thought?

It's better to use the helper function: rlimit().
