Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbYEMVR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbYEMVR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYEMVRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:17:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbYEMVRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:17:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Ply+0zZasz34TDPUeJv4OdYnsgebYTl029hvEnRf+sBhKWmKQR4fVL8UaQQOIgy0j
	2OLEaSQ9badm6KN/YTLvw==
Message-ID: <6599ad830805131417m4f8cc2e6iac42c0fb089a8cb1@mail.gmail.com>
Date: Tue, 13 May 2008 14:17:29 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups control files
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080513130127.fcd46a41.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.133586000@menage.corp.google.com>
	 <20080513130127.fcd46a41.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 1:01 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  This, umm, doesn't seem to do much to make the kernel a simpler place.
>
>  Do we expect to gain much from this?  Hope so...  What?
>

The goal is to prevent cgroup_mutex becoming a BKL for cgroups, to
make it easier for subsystems to lock just the bits that they need to
remain stable rather than everything.
>
>  Vague handwaving: lockdep doesn't know anything about any of this.
>  Whereas if we were more conventional in using separate locks and
>  suitable lock types for each application, we would retain full lockdep
>  coverage.

That's a good point - I'd not thought about lockdep. That's a good
argument in favour of not having the locking done in the framework.

Stepping back a bit, the idea is definitely that where appropriate
subsystems will use their own fine-grained locking. E.g. the
res_counter abstraction does this already with a spinlock in each
res_counter, and cpusets has the global callback_mutex that just
synchronizes cpuset operations. But there are some cases where they
need a bit of help from cgroups, such as when doing operations that
require stable hierarchies, task membership of cgroups, etc.

Right now the default behaviour is to call cgroup_lock(), which I'd
like to get away from. Having the framework do the locking results in
less need for cleanup code in the subsystem handlers themselves, but
that's not an unassailable argument for doing it that way.

This is one of those times that I really long for C++ scope-based
destructors, to automatically release locks when you exit a scope.

>  > +     ssize_t max_bytes = sizeof(static_buffer) - 1;
>  > +     if (!cft->write && !cft->trigger) {
>  > +             if (!nbytes)
>  > +                     return -EINVAL;
>  > +             if (nbytes >= max_bytes)
>  > +                     return -E2BIG;
>  > +             if (nbytes >= sizeof(static_buffer)) {
>
>  afaict this can't happen - we would have already returned -E2BIG?

You're right, with this patch it can't. The code that makes it
necessary to allocate a dynamic buffer gets added in the write_string
patch, so I'll move it there. (These two were originally one patch and
I guess I did a poor job of splitting them).

>
>
>  > +                     /* +1 for nul-terminator */
>  > +                     buffer = kmalloc(nbytes + 1, GFP_KERNEL);
>  > +                     if (buffer == NULL)
>  > +                             return -ENOMEM;
>  > +             }
>  > +             if (copy_from_user(buffer, userbuf, nbytes)) {
>  > +                     retval = -EFAULT;
>  > +                     goto out_free;
>  > +             }
>  > +             buffer[nbytes] = 0;     /* nul-terminate */
>  > +             strstrip(buffer);       /* strip -just- trailing whitespace */
>  >       }
>  > -     return -EINVAL;
>  > -}
>
>  I'm trying to work out what protects static_buffer?
>
>  Why does it need to be static anyway?  64 bytes on-stack is OK.
>

As Matt observed, this is just a poorly-named variable. How about
"small_buffer"?

Paul
