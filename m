Return-Path: <linux-kernel-owner+w=401wt.eu-S933356AbZHDTPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbZHDTPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbZHDTPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:15:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbZHDTPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:15:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=msR1SgiVjHc6cksNzFEeTw0fOT0jXez3W9L8Pekf6HnX4AW3e07QfudbKyk5o6uo+
	EiAWFTi2WtlxOb3aVnloQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
	 <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com>
	 <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
Date: Tue, 4 Aug 2009 15:14:59 -0400
Message-ID: <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 4, 2009 at 2:48 PM, Paul Menage<menage@google.com> wrote:
> On Mon, Aug 3, 2009 at 12:45 PM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>>
>> This is probably a stupid idea, but...  what about having zero
>> overhead at clone(), and instead, at cgroup_task_migrate(),
>> dequeue_task()ing all of the affected threads for the duration of
>> the migrate?
>>
>
> Or a simpler alternative - rather than taking the thread group
> leader's rwsem in cgroup_fork(), always take current's rwsem. Then
> you're always locking a (probably?) local rwsem and minimizing the
> overhead. So not quite zero overhead in the fork path, but I'd be
> surprised if it was measurable. In cgroup_attach_proc() you then have
> to take the rwsem of every thread in the process. Kind of the
> equivalent of a per-threadgroup big-reader lock.

Hmm, the tasklist_lock section in fork() is entirely inside the
read-lock. Presumably then iterating the threadgroup list to take all
rwsems is safe from a race in which one thread escapes?
