Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbYDBVnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbYDBVnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbYDBVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:42:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761073AbYDBVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:42:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=WdbjxoXCRGT3XMLite6StnBFeehLBY6DwkcMHaFZsgsPHIz6eAYDhSVAhwRHDR4B6
	r4gBNJZD6OVBmHMUHNcTw==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1207168464.11976.48.camel@bobble.smo.corp.google.com>
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
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
	 <1206380079.21896.20.camel@bobble.smo.corp.google.com>
	 <20080331054404.78CDB26F8E9@magilla.localdomain>
	 <1206995072.14649.41.camel@bobble.smo.corp.google.com>
	 <20080402020707.151E126F8DC@magilla.localdomain>
	 <1207158164.11976.32.camel@bobble.smo.corp.google.com>
	 <20080402194836.4933026F98A@magilla.localdomain>
	 <1207168464.11976.48.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 02 Apr 2008 14:42:07 -0700
Message-Id: <1207172527.11976.58.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 13:34 -0700, Frank Mayhar wrote:
> One little gotcha we just ran into, though:  When checking
> tsk->signal->(anything) in run_posix_cpu_timers(), we have to hold
> tasklist_lock to avoid a race with release_task().  This is going to
> make even the null case always cost more than before.

This race, by the way, is because we're dereferencing task->signal at
interrupt once per tick.  We ran into a case where a process was going
through release_task() and being torn down on one CPU while running a
timer tick on another.  Under load.  It's not a very likely race but
with sufficient time or load it's pretty much inevitable.

My thought is to move thread_group_cputime from the signal structure to
hanging directly off the task structure.  It would be shared in the same
way as the signal structure is now but would be deallocated with the
task structure rather than the signal structure.  This should mean that
I could avoid getting tasklist_lock under most conditions.

Thoughts?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

