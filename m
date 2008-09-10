Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYIJXFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYIJXFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYIJXE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:04:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3342 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYIJXE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:04:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fk4qhf+vKPXlBXZMfBtclM2ufoRbfzxx04iViwAAQNkR5AGdkMjKM4zQz+YzjxCjE
	vbiqzvcH2qGqcNsnZVhkQ==
Message-ID: <6599ad830809101604o71b2fb82k2aca1eb0fd8ab6d8@mail.gmail.com>
Date: Wed, 10 Sep 2008 16:04:43 -0700
From: "Paul Menage" <menage@google.com>
To: "Ranjit Manomohan" <ranjitm@google.com>
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
Cc: "Thomas Graf" <tgraf@suug.ch>, davem@davemloft.net,
       akpm@linux-foundation.org, kaber@trash.net, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809101040280.7050@ranjit.corp.google.com>
	 <20080910220115.GH20815@postel.suug.ch>
	 <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 3:56 PM, Ranjit Manomohan <ranjitm@google.com> wrote:
>>
>> The big disadvantage of this method is that it does not allow to change
>> the classid for sockets which already exist. It inherits the classid
>> at socket creation time and then sticks to it. So if you want to follow
>> this approach I'd suggest to at least store a reference to the cgroup
>> state and reference count it properly.
>>
>
> I had considered adding support for moving tasks between cgroups by
> going through all the open fds of the task and updating the sockets
> (in the cgroup attach method). It is a very heavy weight operation and
> not considered a common use case (and even undesirable at times) so I
> dropped the idea. I can add it back in if it is considered essential.
>

That's a bit different from what Thomas is suggesting (I think).

There are three options:

a) socket acquires class id at creation time from its creator task or
its parent socket. So the class id is fixed for the lifetime of the
socket

b) socket acquires a reference to a cgroup at creation time, from its
creator task or its parent socket. So the class id can be updated by
changing the cgroup's class id, but the cgroup of the socket can't be
changed. This can prevent the cgroup from being properly destroyed.

c) socket acquires a reference to a cgroup at creation time, and can
be moved to a different cgroup when tasks that reference it move
between cgroups.

Our patches use option a. Option c is too heavyweight IMO, and has
vague semantics for exactly when movement should occur. Option b
*could* be useful, if you wanted to be able to share class ids between
cgroups, *and* shuffle the sharing relationships around on the fly. I
think that Thomas is suggestion option b. I'm not sure that I see a
concrete use case for it though - Thomas, what use cases did you see?

Paul
