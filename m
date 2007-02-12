Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXBLSlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXBLSlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965286AbXBLSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:41:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:49391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbXBLSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:41:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vvuNUwn2UIC6Oks3+LMa5Qv2XECC2x9NGPvzNJ6Bl4DfstFQbw10R3QKgg2keBndD
	7H7aSuKhf5VsS4oKrTT8A==
Message-ID: <6599ad830702121040m7d39ad1u1210002dea702902@mail.gmail.com>
Date: Mon, 12 Feb 2007 10:40:52 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070212152738.GD7526@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.485337000@menage.corp.google.com>
	 <20070212152738.GD7526@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Mon, Feb 12, 2007 at 12:15:24AM -0800, menage@google.com wrote:
> > +/*
> > + * Call css_get() to hold a reference on the container; following a
> > + * return of 0, this container subsystem state object is guaranteed
> > + * not to be destroyed until css_put() is called on it.  A non-zero
> > + * return code indicates that a reference could not be taken.
> > + *
> > + */
> > +
>
> Why can't we reuse container->count (or container_group->ref) to
> refcount the per-subsystem object attached to a container? I think
> that is how it is done for cpusets? That would make css_get/put
> unnecessary?

I did consider that approach at one point. The reason I rejected it
was that then container->count would no longer even vaguely represent
the number of processes in a container. Now that we have the
container_group object, we have to use that for counting the number of
processes in a container anyway, so that objection goes away.

However, I think it's important to be able to provide some kind of a
reference count that subsystems can grab (e.g. to store a reference in
a non-task object such as a file struct) without taking manage_mutex
or callback_mutex (since that would be excessively heavyweight) but
which can still be "frozen" at zero at the point when you're trying to
destroy a container. Additionally, having it per subsystem will be
important for when we implement arbitrary binding/unbinding of
subsystems from hierarchies - at that point we need to be able know
which subsystems have external reference counts, and hence aren't
removeable.

Paul
