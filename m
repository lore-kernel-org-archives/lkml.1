Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbZHDStG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbZHDStG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbZHDStF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:49:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292AbZHDStE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:49:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=q+SJweC3FjY+ccSzilw4F7u9ZqS3g3HSh6/pIhg/erOpFMog17rxxJhBuk54OaJ9a
	DY1zCV5BmgxZMGM2agAMA==
MIME-Version: 1.0
In-Reply-To: <20090803194555.GA10158@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
	 <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com>
Date: Tue, 4 Aug 2009 11:48:57 -0700
Message-ID: <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 12:45 PM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>
> This is probably a stupid idea, but...  what about having zero
> overhead at clone(), and instead, at cgroup_task_migrate(),
> dequeue_task()ing all of the affected threads for the duration of
> the migrate?
>

Or a simpler alternative - rather than taking the thread group
leader's rwsem in cgroup_fork(), always take current's rwsem. Then
you're always locking a (probably?) local rwsem and minimizing the
overhead. So not quite zero overhead in the fork path, but I'd be
surprised if it was measurable. In cgroup_attach_proc() you then have
to take the rwsem of every thread in the process. Kind of the
equivalent of a per-threadgroup big-reader lock.

Paul
