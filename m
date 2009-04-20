Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZDTOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZDTOrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZDTOrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:47:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:3174 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZDTOrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:47:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=grj19WR7u3fBmrnDqrmZ3Z/ZzqbUDC6aOTEyF+r5YbelftDKL1JSkhehCyVqgUqfSv
         +YEc0Xa9BO/qafTbvSXXQcqTyW1ZRP4DaQr+Ucj9JsPxHsXF1mGd3g9nSWbOHzoCSsZR
         6aIMIdZuUrfulTrw8OLGKrzsNLdlGbhB+wbqE=
MIME-Version: 1.0
In-Reply-To: <20090420105304.GC6670@elte.hu>
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	 <adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
	 <adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>
	 <20090420105304.GC6670@elte.hu>
Date: Mon, 20 Apr 2009 23:47:10 +0900
Message-ID: <a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 19:53, Ingo Molnar <mingo@elte.hu> wrote:
>
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>> Roland Dreier wrote:
>> >
>> > Notice that it reads from addr+4 *before* it reads from addr, rather
>> > than after as in your example (and in fact your example depends on
>> > undefined compiler semantics, since there is no sequence point between
>> > the two operands of the | operator).  Now, I don't know that hardware,
>> > so I don't know if it makes a difference, but the niu example I gave in
>> > my original email shows that given hardware with clear-on-read
>> > registers, the order does very much matter.
>> >
>>
>> At least for x86, the order should be low-high, because that is the
>> order that those two transactions would be seen on a 32-bit bus
>> downstream from the CPU if the CPU issued a 64-bit transaction.
>>
>> The only sane way to handle this as something other than per-driver
>> hacks would be something like:
>>
>> #include <linux/io64.h>               /* Any 64-bit I/O OK */
>>
>> #include <linux/io64lh.h>     /* Low-high splitting OK */
>>
>> #include <linux/io64hl.h>     /* High-low splitting OK */
>>
>> #include <linux/io64atomic.h> /* 64-bit I/O must be atomic */
>>
>> ... i.e. letting the driver choose what fallback method it will accept.
>
> Yeah - with the default being the natural low-high order.
>
> The other argument is that if a driver really wants some rare, oddly
> different order it should better define its own method that is not
> named in the same (or in a similar) way as an existing generic API.
> Otherwise, confusion will ensue.
I think this is a good way.
readq/writeq are already in Linus's tree, removing these is not a good idea.

And I've sent the patch to fix a little problem of Kconfig about
readq/writeq to you.
http://marc.info/?l=linux-kernel&m=123521109218008&w=2
Did you notice?

Adding cautions about accessing order or non-atomic to Kconfig's help
part may be benefit.
