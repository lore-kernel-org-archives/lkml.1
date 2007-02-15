Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbXBOBRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbXBOBRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXBOBRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:17:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXBOBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:17:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=AfUZVUrg3IzzaDg/R90NFiiI6V30gBOK6yoDnPB8Y/pecUriElgYdyFMryz9vR9Fv
	ZzWqkImBPg/hUrtUEdR7w==
Message-ID: <6599ad830702141717j38d4b06ci6c0f70d290af557b@mail.gmail.com>
Date: Wed, 14 Feb 2007 17:17:09 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070213131945.GB4252@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.485337000@menage.corp.google.com>
	 <20070212152738.GD7526@in.ibm.com>
	 <6599ad830702121040m7d39ad1u1210002dea702902@mail.gmail.com>
	 <20070213131945.GB4252@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> Well, we already bump up reference count in fork() w/o grabbing those
> mutexes don't we? Also if rmdir() sees container->count to be zero, then
> it means no task is attached to the container. How will then a function
> like bc_file_charge() bump up the reference count to such a container
> (presuming it wanted to do so w/o manage/callback mutexes -and- that the
> container pointer in bc_file_charge is derived from some task in
> that container). I think it is safe to bump up container->count in
> bc_file_charge w/o grabbing manage/callback mutexes.

Right, I was never suggesting that we take either of those mutexes for
this operation. The spin lock in css_get() was an attempt to avoid
that. But I think you're right that it was too heavyweight, and can be
avoided with atomic operations. See my other email to Pavel.

>
> Are you talking about (un)bind of subsystem to/from hierararchies that
> have non-zero containers in them? That sounds very icky. Anyway that
> doesnt seem to be supported in current patches.

The bind/unbind from active hierarchies is supported in the user-space
API, and it's implemented for hierarchies that have no child
containers. Hence it's important, at least conceptually, for the
reference count to be held by the subsystem state rather than the
container.

Implementing a full bind/unbind for arbitrary subsystems and
hierarchies will indeed be a lot of work, which is why I'm not trying
to do it at this point.

Paul
