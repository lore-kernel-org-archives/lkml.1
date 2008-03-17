Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYCQRx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYCQRx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYCQRxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:53:50 -0400
Received: from saeurebad.de ([85.214.36.134]:52689 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYCQRxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:53:50 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, "Tejun Heo" <htejun@gmail.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>
Subject: Re: per cpun+ spin locks coexistence?
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
	<47DABBCE.5010803@goop.org>
	<804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>
	<87bq5e1kvm.fsf@saeurebad.de>
	<804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com>
Date: Mon, 17 Mar 2008 18:51:34 +0100
In-Reply-To: <804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com>
	(Peter Teoh's message of "Tue, 18 Mar 2008 01:06:33 +0800")
Message-ID: <87tzj5xmqh.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Peter Teoh" <htmldeveloper@gmail.com> writes:

> Thanks for the explanation, much apologies for this newbie discussion.
>   But I still find it inexplicable:
>
> On Mon, Mar 17, 2008 at 4:20 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>>
>>  A per-cpu variable is basically an array the size of the number of
>>  possible CPUs in the system.  get_cpu_var() checks what current CPU we
>>  are running on and gets the array-element corresponding to this CPU.
>>
>>  So, really oversimplified, get_cpu_var(foo) translates to something like
>>  foo[smp_processor_id()].
>>
>
> Ok, so calling get_cpu_var() always return the array-element for the
> current CPU, and since by design, only the current CPU can
> modify/write to this array element (this is my assumption - correct?),
> and the other CPU will just read it (using the per_cpu construct).
> So far correct?   So why do u still need to spin_lock() to lock other
> CPU from accessing - the other CPU will always just READ it, so just
> go ahead and let them read it.   Seemed like it defeats the purpose of
> get_cpu_var()'s design?

You ignore the fact that there are structures and pointers in C :) One
and the same object may be referenced from different structure objects.

For example you have an object foo saved in a cpu-local variable and
this object references another object bar (foo.bar), you might do
whatever you want to do with foo.  But if bar is a structure you might
still have to lock when you want to change the fields of it to prevent
races if this bar object can be referenced from another point like an
instance of some_struct:

PER-CPU [foo|foo|foo]
          |   |   |
          |   |   \
          |   \    +---> [bar]
          \    +---> [bar]
           +---> [bar] <--+
                           \
                       [some_struct]

A foo _might_ be protected by cpu-locality but as you can see, bar can
only be changed under lock if it is modified through foo _and_
some_struct.

I hope this clears it.  Please correct me if I am wrong or supply a
better scenario than this ;)

	Hannes
