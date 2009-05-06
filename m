Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZEFKYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZEFKYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZEFKXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:23:50 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:46941 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZEFKXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=atodIxi8+t6qI7IAuQcXGEfU+5V3LYTmtzw2gYkBYXneamj6huTMjUghOxcPi1/Tvh
         8C1UcsiMPVsM77itUr/ygEk0a3vOooUs0gvG2zBgIL+kOQXPll+zETmJFnCEO7iqJUxn
         5Oo1UIQWFULzWhcqB1UlrgThYpfKs+5m4X2VA=
MIME-Version: 1.0
In-Reply-To: <20090506082814.GB28675@elte.hu>
References: <20090506042101.231470089@goodmis.org>
	 <20090506042333.402933098@goodmis.org>
	 <20090506082814.GB28675@elte.hu>
Date: Wed, 6 May 2009 12:23:48 +0200
Message-ID: <c62985530905060323o3983bd3ap34640018d5a46be6@mail.gmail.com>
Subject: Re: [PATCH 03/11] tracing: export stats of ring buffers to userspace
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/6 Ingo Molnar <mingo@elte.hu>:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> This patch adds stats to the ftrace ring buffers:
>>
>>  # cat /debugfs/tracing/per_cpu/cpu0/stats
>>  entries: 42360
>>  overrun: 30509326
>>  commit overrun: 0
>>  nmi dropped: 0
>>
>> Where entries are the total number of data entries in the buffer.
>>
>> overrun is the number of entries not consumed and were overwritten by
>> the writer.
>>
>> commit overrun is the number of entries dropped due to nested writers
>> wrapping the buffer before the initial writer finished the commit.
>>
>> nmi dropped is the number of entries dropped due to the ring buffer
>> lock being held when an nmi was going to write to the ring buffer.
>> Note, this field will be meaningless and will go away when the ring
>> buffer becomes lockless.
>>
>> [ Impact: let userspace know what is happening in the ring buffers ]
>
> nice! I was always wondering about these properties - Frederic
> reported that we drop a lot of trace entries when filtering is
> enabled, due to the rather stupid:
>
>        reserve-buffer
>        put-stuff-into-buffer
>        drop-buffer-if-filter-false
>
> common sequence we do on heavily filtered input.
>
>        Ingo


But I think I was wrong actually.
I looked at it closer recently and the lock events are traced in a
raw_local_irq_save section.

So the cause is elsewhere. I haven't had anymore problem with it
recently, may be because I'm using a script
which disables the events once I finish the tracing.
