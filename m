Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZHFABt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZHFABt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZHFABt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:01:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1291 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZHFABs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:01:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=G58XweUyQKktxyRn4ZsVGbh3EX5ntLZY4fXFGdlpukdVdxILpvn489517Nqn7sD3g
	thfAtRH/YgbNR8qQ6pNlw==
MIME-Version: 1.0
In-Reply-To: <20090805164218.GB26446@hawkmoon.kerlabs.com>
References: <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com>
	 <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
Date: Wed, 5 Aug 2009 17:01:42 -0700
Message-ID: <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 9:42 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
> On 05/08/09  9:11 -0700, Paul Menage wrote:
>> On Wed, Aug 5, 2009 at 3:20 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>> >
>> > The downside of this is teaching lockdep about this recursive locking. Not that
>> > simple actually...
>>
>> Don't we just give each thread's lock its own lock class? That's what
>> we did for the cgroup hierarchy_mutex.
>
> Given that lock classes must be static and that lockdep only supports a limited
> lock depth, this is an issue for processes having many threads.
>
>>
>> > so that such cases are currently handled using a higher-level
>> > lock that prevents races in locking the whole chain (there was one such example
>> > for locking all vmas with KVM). IIUC, the intent here is to avoid such
>> > higher-level lock.
>>
>> cgroup_mutex already fulfills the role of the higher-level lock.
>
> If so (that is, here cgroup_mutex is taken before write-locking all threads'
> rw_sem), then enhancing rwsem's interface in a similar way to the
> spin_lock_nest_lock() interface could do it. There will still be an issue with
> many threads and lockdep limited lock depth though.

If we make the locks per-thread, then we can use plain mutexes instead
of rwsems since the only reader will ever be the owning thread itself,
and we can use mutex_lock_nested.

>
> Added Peter in CC.
>
> Louis
>
> --
> Dr Louis Rilling                        Kerlabs
> Skype: louis.rilling                    Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23            80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/                 35700 Rennes
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAkp5tmoACgkQVKcRuvQ9Q1TwdACeMwdKtGc3rU3PGXPgYvdj9Vxe
> xYIAmQFMW6Ri9JGuc7+A0WmGzXkzQ81A
> =Wj3u
> -----END PGP SIGNATURE-----
>
>
