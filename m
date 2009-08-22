Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZHVN2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZHVN2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 09:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZHVN2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 09:28:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZHVN2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 09:28:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bvMJiN1mYvCYUMkTKsmppNjv37MfdJNRodWzrEzDPGhxKbEkdSbvoD3JgnEhxO1I3
	1uiuDFI4omg5lryInK0nw==
MIME-Version: 1.0
In-Reply-To: <20090822130952.GA4240@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org>
	 <20090821102611.GA2611@redhat.com> <20090821104528.GA3487@redhat.com>
	 <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com>
	 <20090822130952.GA4240@redhat.com>
Date: Sat, 22 Aug 2009 06:28:04 -0700
Message-ID: <6599ad830908220628o7dc99cf1i5908d3e95deb31e5@mail.gmail.com>
Subject: Re: + cgroups-add-functionality-to-read-write-lock-clone_thread-forking-pe 
	r-threadgroup.patch added to -mm tree
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, bblum@google.com,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 22, 2009 at 6:09 AM, Oleg Nesterov<oleg@redhat.com> wrote:
>
>
> And why do we need sighand->threadgroup_fork_lock ? I gueess, to protect
> against clone(CLONE_THREAD).

Right - we want to be able to atomically move all the threads in the
thread group into a new cgroup, without leaving any behind if we
happen to race with a clone(CLONE_THREAD).

Putting the lock in the sighand structure seemed like an appropriate
place since it's involved in existing clone() synchronization.

>
> threadgroup_fork_lock() bumps P->sighand->count. If P exec, it will
> notice sighand->count != 1 and switch to another ->sighand.

So maybe we should also down_read(threadgroup_fork_lock) in the exec
path? That would prevent a child thread from execing and taking over
the group leadership, so it would remain safe to iterate over the
group leader's thread list.

Paul
