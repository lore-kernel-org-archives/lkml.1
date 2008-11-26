Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYKZSWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYKZSWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 13:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYKZSV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 13:21:59 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:5406 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYKZSV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 13:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=vC2PzzADxysVLJm7lEJ3bQO58DzXpS0OGZrSbYPa8WkJbz6FAQ8c6XmnJaSi8kiNkd
         k8WQmqE8ZF3I7J1i4G2NHMnzXUyWZZTzQpHigN1zuJA5sAZA8hNcL839+cPKF3BNT3Yy
         sf7nHsspw5ehxVp026P+iFPIlkzaysOFb27L4=
Message-ID: <7c86c4470811261021t5a7da650w95c30a71838172c4@mail.gmail.com>
Date: Wed, 26 Nov 2008 19:21:56 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 23/24] perfmon: kernel documentation
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
In-Reply-To: <20081126122107.GV6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com>
	 <20081126122107.GV6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Nov 26, 2008 at 1:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Nov 26, 2008 at 12:43:00AM -0800, eranian@googlemail.com wrote:
>
> I assume you'll be also submitting manpages with the same information?
>
This is on my TODO list. Provide a man page for each new syscall.

>> +
>> +   A monitoring session is uniquely identified by a file descriptor obtained
>> +   when the session is created. File sharing semantics apply to access the
>> +   session inside a process. A session is never inherited across fork. The file
>> +   descriptor can be used to receive counter overflow notifications or when the
>> +   sampling buffer is full. It is possible to use poll/select on the descriptor
>> +   to wait for notifications from multiple sessions. Similarly, the descriptor
>> +   supports asynchronous notifications via SIGIO.
>
> What happens when the fd is passed between processes using unix sockets fd
> passing?
>

I have never played with that myself, even with regular file
descriptors. But I can only
assume passing a file descriptor increments its refcount. Thus you
simply get another
controlling process. There is enough context locking in place in the
kernel to make this
work.


>> +
>> +    We have released a simple monitoring tool to demonstrate the features of
>> +    the interface. The tool is called pfmon and it comes with a simple helper
>> +    library called libpfm. The library comes with a set of examples to show
>
> I don't think "simple" is the right word to describe pfmon/libpfm @)
>
The idea is simple, implementation is more complicated. Complexity of libpfm
comes mostly from complexity of the hardware, take Cray, Power, Pentium4 and
Itanium2 for instance ;->

>> +    There maybe other tools available for perfmon.
>
> s/maybe/are/ ?
>
>> +
>> +   To destroy a session, the regular close() system call is used.
>
There are tools.

> ...
>
> Some simple syscall examples would be nice. e.g. how to set up a counter
> that it can be accessed using RDPMC on x86.

I can add this. But why go straight to RDPMC. Most people would want to use
the syscall instead?

>
>> +     /sys/kernel/perfmon/arg_mem_max(read-write):
>> +
>> +             Maximum size of vector arguments expressed in bytes.
>> +             It can be modified but must be at least a page.
>> +             Default: PAGE_SIZE
>
> Is there any good reason ever to enlarge this beyond a page?
>
> If it just depends on future hardware it would make more sense
> to let a driver patch for that adjust it.
>
It depends on the number of registers available. It is expected that most tools
will want to use one call to program the config registers and one to program
the data registers. Pfmon is able to split vectors according to arg_mem_max.

It is anticipated that newer processors will increase the number of available
PMU registers. That was the case with Barcelona with the addition of IBS.
On Intel X86, I am planning on exposing the LBR as part of the PMU registers.

 On Itanium, you already have 35 data and 27 config registers.

But I think your suggestion is interesting. When we "register" the new PMU
mapping table, we can provide a minimal size to fit all PMC or all PMD registers
in one call. That would remove a control point for the sysadmin, though.
