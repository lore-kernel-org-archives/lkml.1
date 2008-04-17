Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbYDQQfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbYDQQfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763858AbYDQQfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:35:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbYDQQfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:35:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ihnZ+qQLgVEPXkWp8BE/G5dqkpyqKOkvntd2OJdzDARipWgBauLmVwlKG0FEpUz0s
	Bf1R3hCPhuugsKYSMitZw==
Message-ID: <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com>
Date: Thu, 17 Apr 2008 09:34:50 -0700
From: "Paul Menage" <menage@google.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, serue@us.ibm.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
In-Reply-To: <20080417113000.GB103@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48036677.3010807@linux.vnet.ibm.com>
	 <20080414170709.736819b6.akpm@linux-foundation.org>
	 <20080415171359.GA352@tv-sign.ru>
	 <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com>
	 <20080415195950.GA113@tv-sign.ru>
	 <4806C633.3000302@linux.vnet.ibm.com>
	 <20080417113000.GB103@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 4:30 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>  >
>  > I had this loop earlier (inspired from zap_threads()), is this loop more
>  > efficient than what we have?
>
>  All sub-threads have the same ->mm. Once we see that c->mm != mm, we don't
>  need to waste CPU iterating over the all other threads in the thread group.

Technically they don't have to have the same mm, right? You can use
CLONE_THREAD without CLONE_VM when creating a new subthread.

So the complete loop is required for correctness - but it might make
sense to include your version of the loop first, since that will be
faster whenever there are heavily-threaded apps on the system, and
will give the right answer 99.9% of the time (i.e. except when the
user is doing something really weird with clone flags).

>  chance you have the "for dummies" explanation what mm->owner is?
>  I mean, I can't understand how it is possible that 2 CLONE_VM tasks
>  are not equal wrt "ownering".

The idea is to be able to get from an mm to a task, where that task is
representative of the tasks using the mm. Uses include:

- virtual address space cgroup - when we extend an mm, we don't always
have a task pointer available currently.

- swap cgroup - when swapping from an mm, find a task whose swap
cgroup we can charge the swap page to

- revokeat() - apparently needs this for locating tasks based on file mappings

> When the old owner dies, we choose a
>  random thread with the same mm. But we do nothing when the last user
>  of ->mm dies. What is the point? (please feel free to ignore my q

When the last user of the mm dies, the mm is freed, so there's no need
for mm->owner to be valid any longer.

Paul
