Return-Path: <linux-kernel-owner+w=401wt.eu-S1767000AbXCIMUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767000AbXCIMUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767200AbXCIMUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:20:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:36946 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767000AbXCIMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:19:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QKu/HXgNkVtOVi2t1RMqp8MwhNdKJxWmxQVY3ZcGiK5vatpo0zZwRMd1OWeg/t/mlqchMbwBtRB/fJ99zh+0EL2cBTbswCocFLfNU6aON4oBzhJSKnO/C+UJn3TpmTLGYkEoJeyVOz1SAIwze9cytCzkXgeWmvY/DcyACyHd3so=
Message-ID: <f2b55d220703090419w755d42d0mea4f220e3caaa59a@mail.gmail.com>
Date: Fri, 9 Mar 2007 04:19:55 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070309013405.GI6209@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
	 <45F09F9C.4030801@cosmosbay.com>
	 <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
	 <45F0A71C.2000800@cosmosbay.com>
	 <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
	 <20070309013405.GI6209@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Benjamin LaHaise <bcrl@kvack.org> wrote:
> Any number of things can cause a short write to occur, and rewinding the
> file position after the fact is just as bad.  A sane app has to either
> serialise the writes itself or use a thread safe API like pwrite().

Not on a pipe/FIFO.  Short writes there are flat out verboten by
1003.1 unless O_NONBLOCK is set.  (Not that f_pos is interesting on a
pipe except as a "bytes sent" indicator  -- and in the multi-threaded
scenario, if you do the speculative update that I'm suggesting, you
can't 100% trust it unless you ensure that you are not in
mid-read/write in some other thread at the moment you sample f_pos.
But that doesn't make it useless.)

As to what a "sane app" has to do: it's just not that unusual to write
application code that treats a short read/write as a catastrophic
error, especially when the fd is of a type that is known never to
produce a short read/write unless something is drastically wrong.  For
instance, I bomb on short write in audio applications where the driver
is known to block until enough bytes have been read/written, period.
When switching from reading a stream of audio frames from thread A to
reading them from thread B, I may be willing to omit app
serialization, because I can tolerate an imperfect hand-off in which
thread A steals one last frame after thread B has started reading --
as long as the fd doesn't get screwed up.  There is no reason for the
generic sys_read code to leave a race open in which the same frame is
read by both threads and a hardware buffer overrun results later.

In short, I'm not proposing that the kernel perfectly serialize
concurrent reads and writes to arbitrary fd types.  I'm proposing that
it not do something blatantly stupid and easily avoided in generic
code that makes it impossible for any fd type to guarantee that, after
10 successful pipelined 100-byte reads or writes, f_pos will have
advanced by 1000.

Cheers,
- Michael
