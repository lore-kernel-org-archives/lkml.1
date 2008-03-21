Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbYCUUks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbYCUUks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYCUUkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:40:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYCUUki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:40:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=XGuBgDgN3DDUhE7Duj6SolQYIxikUljhFpdNpgyWMNUZjyOwa+G+0sgFnhP5CG0tu
	izUiaP0udQ3LVIbnu8yuQ==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080321071846.1B22B26F9A7@magilla.localdomain>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 21 Mar 2008 13:40:00 -0700
Message-Id: <1206132000.14638.42.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 00:18 -0700, Roland McGrath wrote:
> I think I misled you about the use of the it_*_expires fields, sorry.
> The task_struct.it_*_expires fields are used solely as a cache of the
> head of cpu_timers[].  Despite the poor choice of the same name, the
> signal_struct.it_*_expires fields serve a different purpose.  For an
> analogous cache of the soonest timer to expire, you need to add new
> fields.  The signal_struct.it_{prof,virt}_{expires,incr} fields hold
> the setitimer settings for ITIMER_{PROF,VTALRM}.  You can't change
> those in arm_timer.  For a quick cache you need a new field that is
> the sooner of it_foo_expires or the head cpu_timers[foo] expiry time.

Actually, after looking at the code again and thinking about it a bit,
it appears that the signal_struct.it_*_incr field holds the actual
interval as set by setitimer.  Initially the it_*_expires field holds
the expiration time as set by setitimer, but after the timer fires the
first time that value becomes <firing time>+it_*_incr.  In other words,
the first time it fires at the value set by setitimer() but from then on
it fires at a time indicated by whatever the time was the last time the
timer fired plus the value in it_*_incr.  This time is stored in
signal_struct.it_*_expires.

I guess I could be wrong about this, but it appears to be what the code
is doing.  If my analysis is correct, I really don't need a new field,
since the old fields work just fine.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

