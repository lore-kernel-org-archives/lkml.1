Return-Path: <linux-kernel-owner+w=401wt.eu-S965546AbXHaOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546AbXHaOZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXHaOZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:25:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:28371 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbXHaOZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rR4f+47IAPRXjVNzwfwTMcVNi6iGaDgy9U74O/LtF5aw3CUYsvYCGe1Vm8ulEhUOWb8a25HtO5OeHTACeB8vSVLeiZWwVNC0aEhay/03g98jX8dWvh/lYN7prvGi7Dnerbj1Xukhjm3G8NpFzzYN44sS+0rJdJtPc4IfxAhm6lg=
Message-ID: <379fb4870708310725h46e69d50h38c19444faf8e6fa@mail.gmail.com>
Date: Fri, 31 Aug 2007 16:25:19 +0200
From: "anon... anon.al" <anon.asdf@gmail.com>
To: anon.asdf@gmail.com
Subject: Re: Nonblocking call may block in a mutex? Nonblocking call after poll may fail?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <379fb4870708310513o46a721c6l3080179ccbb8f519@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <379fb4870708310513o46a721c6l3080179ccbb8f519@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 31, 2:20 pm, "anon... anon.al" <anon.a...@gmail.com> wrote:
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

Yes, it should sleep until the mutex is free.

This can be seen from a code snippet in LDD3 (Linux Device Drivers,
3rd ed.), on page 153:

http://lwn.net/images/pdf/LDD3/ch06.pdf#page=19&zoom=80,0,450


The code snippet in LDD3 does not contain the following before the while loop:

if (filp->f_flags & O_NONBLOCK) {
  if (down_trylock(&dev->sem)) {
    return -EAGAIN;
  }
}

So a non-blocking process can also sleep (in down) if this type of
mutex is locked. It may however not block if the output-queue is full.

>
> What about a non-blocking (write-) poll of process A: if the poll call
> succeeds (the output buffer has space remaining for process A), and
> process A now performs a non-blocking write: what happens if A
> encounters a blocked mutex, since process B is busy writing to the
> output-buffer.
> a) Should A block until the mutex is available?
> b) Should A return -EAGAIN, even though the poll call succeeded?
> c) Should it be impossible for this to happen! i.e. -> should process
> A already "have" the mutex in question, when the poll call succeeds
> (thus preventing B from writing to the output buffer)
>
> For c) What if process A "has" the mutex, but never does the
> non-blocking write. Then no process can write, since the mutex is held
> by process A...
>

It cannot be b) (same reasoning as above).
But is it a) or c)...?

Regards,
Albert
