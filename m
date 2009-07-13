Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZGMWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZGMWPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZGMWPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:15:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZGMWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:15:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UrJwEaqrfOG4yeUWKK1E4GWnkaseGpZPeSGqa/WZCaulr5Rnl0xvHAoXo6y/LJz2X
	hUHrsqRYl7pNxO8UJdtcg==
MIME-Version: 1.0
In-Reply-To: <20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
	 <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
	 <1246998310-16764-2-git-send-email-vbuzov@embeddedalley.com>
	 <20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jul 2009 15:15:45 -0700
Message-ID: <6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vladislav Buzov <vbuzov@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 5:56 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> I know people likes to wait for file descriptor to get notification in these days.
> Can't we have "event" file descriptor in cgroup layer and make it reusable for
> other purposes ?

I agree - rather than having to add a separate "wait for value to
cross X threshold" file for each numeric usage value that people might
be concerned about, it would be better to have a generic way to do it
for any file. Given that this is a userspace API, it would be better
to work out at least the generic API first, even if the initial
implementation isn't generic.

Properties that it should support include:

- notification when a value crosses above or below a given threshold
(which would include binary cases such as OOM notification where the
value cross from "not-OOM" to "OOM"

- independent thresholds for different waiters

- epoll support (by using eventfd?)

- automatic wakeup when a cgroup is removed

- maybe optional wakeup when a thread attach occurs?

- not require more than read permissions on the file containing the
value being monitored

I guess there are a few possible ways this could be exposed to userspace:

1) new ioctl on cgroups files. simple but probably not popular

2) new system call. maybe the cleanest, but involves changing every
arch and is hard to script

3) new per-cgroup file to control these e.g:
  - create an eventfd
  - open the control file to be monitored
  - write the "<event_fd>, <control_fd> <threshold> to
cgroup.event_control to link them together
flexible and scriptable but maybe a clumsy interface in general

Paul
