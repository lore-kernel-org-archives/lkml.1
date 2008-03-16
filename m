Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYCPUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYCPUWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYCPUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:22:34 -0400
Received: from saeurebad.de ([85.214.36.134]:56681 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCPUWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:22:34 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, "Tejun Heo" <htejun@gmail.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>
Subject: Re: per cpun+ spin locks coexistence?
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
	<47DABBCE.5010803@goop.org>
	<804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>
Date: Sun, 16 Mar 2008 21:20:29 +0100
In-Reply-To: <804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>
	(Peter Teoh's message of "Mon, 17 Mar 2008 00:30:23 +0800")
Message-ID: <87bq5e1kvm.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

"Peter Teoh" <htmldeveloper@gmail.com> writes:

>>  > Notice above that get_cpu_var() is followed by spin_lock().   Does this
>>  > make sense?   get_cpu_var() will return a variable that is only
>>  > accessible by the current CPU - guaranteed it will not be touch (read or
>>  > write) by another CPU, right?
>>
>>  No, not true.  percpu is for stuff which is generally only touched by
>>  one CPU, but there's nothing stopping other processors from accessing it
>>  with per_cpu(var, cpu).
>
> get_cpu_var() above, will return a ptr specific for a particular CPU
> only, is correct?
>
> #define get_cpu_var(var) (*({                           \
>         extern int simple_identifier_##var(void);       \
>         preempt_disable();                              \
>         &__get_cpu_var(var); }))
>
> SMP:
>
> #define __get_cpu_var(var) \
>         (*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
>
> #define SHIFT_PERCPU_PTR(__p, __offset) RELOC_HIDE((__p), (__offset))
>
> and RELOC_HIDE() i don't understand.

RELOC_HIDE is a GCC hack.  It does basically p+offset.

> So from what u said, per_cpu_var() returns uniquely for each CPU, but
> __get_cpu_var() may not be unique among the different CPU - is that
> correct?
>
> When cpuA and cpuB call get_cpu_var(), the returned ptr is specific
> only for cpuA and cpuB, right?   So yes, as u said, different cpu can
> call get_cpu_var(), but the returned ptr will be unique to each cpu,
> therefore it is guaranteed that another CPU will not get hold of the
> returned results of get_cpu_var(), right?   So why spin_lock() comes
> after get_cpu_var()?

A per-cpu variable is basically an array the size of the number of
possible CPUs in the system.  get_cpu_var() checks what current CPU we
are running on and gets the array-element corresponding to this CPU.

So, really oversimplified, get_cpu_var(foo) translates to something like
foo[smp_processor_id()].

But per_cpu(), as Jemery said, allows you to retrieve an element from
the array that is not meant for your current CPU.  So even if you run on
CPU1, you might fetch the element that is meant for use on CPU0.

But even if you don't access the cpu-local variable from other CPUs, the
element might still be a reference to a shared structure that you have
to lock properly.  Another CPU might have a reference to this same
structure as well in its per-cpu variable.

	Hannes
