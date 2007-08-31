Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbXHaOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbXHaOdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbXHaOcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:32:51 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:53529 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbXHaOcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OAX/o3X6+7L2v3pIPRUnnR8o43v7cXni2rEKznymUUjs4u5AeE5UUuvNKfulXnx0eHl07uKk1qE7RqS45V8JixAKCkfLWJkhrFUsPO99Rrq3+0m+T9/RdqV6UO4PT3zqrTLGVSTkf0vORjePbvEvJ3bCnAhEGYQxadkS//IwEHs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "anon... anon.al" <anon.asdf@gmail.com>
Subject: Re: Nonblocking call may block in a mutex? Nonblocking call after poll may fail?
Date: Fri, 31 Aug 2007 15:32:26 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <379fb4870708310513o46a721c6l3080179ccbb8f519@mail.gmail.com>
In-Reply-To: <379fb4870708310513o46a721c6l3080179ccbb8f519@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311532.26376.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007 13:13, anon... anon.al wrote:
> Hi!
>
> This is a driver-related question on non-blocking writes and poll.
>
> Setup:
> there is a single output-buffer (in kernel-space) of 24 bytes for
> writes from all processes A, B, and C: each process is restricted to
> use at most 8 bytes: 8*3 = 24
> (until that data is handled (interrupt-handler...))
>
> Question:
> If this output-buffer has "4-bytes space remaining for process A",
> then a non-blocking write of process A could still encounter a locked
> mutex, if process B is busy writing to the output-buffer.
>
> Should process A now block/sleep until that mutex is free and it can
> access the output-buffer (and it's 4 bytes space)?
>
> What about a non-blocking (write-) poll of process A: if the poll call
> succeeds (the output buffer has space remaining for process A), and
> process A now performs a non-blocking write: what happens if A
> encounters a blocked mutex, since process B is busy writing to the
> output-buffer.
> a) Should A block until the mutex is available?

If mutex cannot be locked by B indefinitely, yes.
If it can be locked indefinitely, then obviosly no.

> b) Should A return -EAGAIN, even though the poll call succeeded?

Succeeding poll is no guarantee against getting EAGAIN.
When poll succeeds, it means "you _maybe_ can write now".

> c) Should it be impossible for this to happen! i.e. -> should process
> A already "have" the mutex in question, when the poll call succeeds
> (thus preventing B from writing to the output buffer)

No. Kernel cannot know whether A will do the write at all.

> For c) What if process A "has" the mutex, but never does the
> non-blocking write. Then no process can write, since the mutex is held
> by process A...

Exactly. (c) would be kernel bug.
--
vda
