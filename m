Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbZJECWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbZJECWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbZJECWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:22:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:33620 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041AbZJECWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KauXt+n93XTu+XUpIF/guPsQrfHGAFZGeEuKQEo4T+7FmZZdmb5Q6YYovdI8SL9jHB
         fh0RlqQJWSZOF3cCwQfj7VGhYex7OA/cGfKAN9j3s9d11dsMUvPwiOdjwUQcOUApBJ3W
         snp0ORLclIamGA1vW5TA7KjdV0Zm6tyvipaXI=
MIME-Version: 1.0
In-Reply-To: <20091005105617.5F86.A69D9226@jp.fujitsu.com>
References: <20091005103744.5F83.A69D9226@jp.fujitsu.com> <3e8340490910041844w63720cfq7981c8f5364229de@mail.gmail.com> 
	<20091005105617.5F86.A69D9226@jp.fujitsu.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 4 Oct 2009 22:21:12 -0400
Message-ID: <3e8340490910041921p315f3726me0143f2516022f66@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 9:59 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Sun, Oct 4, 2009 at 9:38 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> The improvement idea is here.
>> >>
>> >> Changelog
>> >>   - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
>> >>  -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)
>> >
>> > Doh, task_lock() is obviously wrong. please forget this.
>>
>> As another note, in general I think we'd need to hold a lock over the
>> entire operation. After all, if userspace changes its PROCTITLE_AREA,
>> and then reuses the memory for something else, we have an information
>> leak.
>
> if reusing occur, it's obviously userland fault. I don't think we need to care this.
> because current kernel also can be information leak by strcpy(argv[0], mypassword).
>
> I think they are userland bug both.

No, the scenario is:

Process B: Enter proc_pid_cmdline(), read arg_start and arg_end into
CPU registers
Process A: prctl(PR_SET_PROCTITLE_AREA)....
Process A: free(old_arg_area);
Process A: char *foo = malloc(...);
Process A: strcpy(foo, super_secret_password);
Process B: access_process_vm - using an area overlapping foo

Process B now has process A's secrets. This cannot be avoided by
process A, as it cannot control when process B will complete
proc_pid_cmdline(), and so the kernel must protect against this
scenario.  The only way a userspace process could prevent this is by
only using PR_SET_PROCTITLE_AREA once, and never reusing that memory,
ever. This does not seem like an appropriate restriction to pass down
to userspace for me...

Anyway, I'm working on a patch that uses the generation-counter approach now :)
