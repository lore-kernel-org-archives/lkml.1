Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYKUTkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYKUTkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbYKUTkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:40:01 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39176 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbYKUTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CzenCShrAZcb594SUpSMaJHWd/dfdcQLpBnCJx0DEzHn/Cj5lLYKawa1+oK6kwhyi3
         vnaDnC9vpYzsH4wY5IQQzl1YTzI8UgSIZqWTDyLJ4s6PsE5xCnQSD5jtvnZYT+NVmzd1
         7xCWY1x+G+yNaNvXb5cVs2Kt+ioTQ2nUqE3sE=
Message-ID: <c62985530811211139l78529b8y1a7881e8693c2728@mail.gmail.com>
Date: Fri, 21 Nov 2008 20:39:58 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081118210344.GC11490@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081118084755.GK17838@elte.hu> <20081118145154.GC30358@elte.hu>
	 <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
	 <20081118151326.GH30358@elte.hu>
	 <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>
	 <20081118155045.GJ30358@elte.hu>
	 <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
	 <20081118164019.GA18620@elte.hu>
	 <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
	 <20081118210344.GC11490@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/18 Ingo Molnar <mingo@elte.hu>:

> hey, look at the bright side of it: whichever variant you pick, if it
> goes wrong, you'll always have someone else to blame for that
> unbelievably stupid suggestion ;-)


Actually, since the current implementation of function-return-tracer
works well with static arrays of return stack,
I guess the moving of this array to struct task would not be a real
problem. I think I should directly start with
the dynamic arrays.
But I'm facing a problem with the allocation of these arrays.

When the tracer will be launched, I will hold the tasklist_lock to
allocate/insert the dynamic arrays.
So in this atomic context, I will not be able to call kmalloc with
GFP_KERNEL. And I fear that using GFP_ATOMIC
for possible hundreds of tasks would be clearly unacceptable.

What do you think of this way:

_tracer activates
_a function enters the tracer entry-hooker. If the array is allocated
for the current task, that's well. If not I launch a kernel thread
that will later allocate an array for the current task (I will pass
the pid as a parameter). So the current task will be soon be traced.
_ when a process forks, I can allocate a dynamic array for the new
task without problem (I hope).

So some tasks will not be traced at the early beggining of tracing but
they will soon all be traced....
There is perhaps a problem with tasks that are sleeping for long
times... There will be some losses once they will be awaken...

What do you think?
