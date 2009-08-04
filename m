Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbZHDT2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbZHDT2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932992AbZHDT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:28:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbZHDT2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:28:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iolluoCMW62KZqfBNi/fBewlA3TD0kmV6xqjlIJGrt5+unVsgG0natN7EGQNckNxv
	RCgp5KKmEssO4Jm3aAWiQ==
MIME-Version: 1.0
In-Reply-To: <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
	 <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com>
	 <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
Date: Tue, 4 Aug 2009 12:28:48 -0700
Message-ID: <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Benjamin Blum <bblum@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 4, 2009 at 12:14 PM, Benjamin Blum<bblum@google.com> wrote:
>
> Hmm, the tasklist_lock section in fork() is entirely inside the
> read-lock. Presumably then iterating the threadgroup list to take all
> rwsems is safe from a race in which one thread escapes?
>

I think so - the write-side locking would be something like:

again:
  read_lock(&tasklist_lock);
  find first not-yet-locked task t
  while (t != group_leader) {
    if (!down_write_trylock(&t->threadgroup_stability_mutex)) {
      get_task_struct(t);
      read_unlock(&tasklist_lock);
      down_write(&t->threadgroup_stability_mutex);
      put_task_struct(t);
      goto again;
    }
    t = t->next_thread;
  }
  read_unlock(&tasklist_lock);

  Paul
