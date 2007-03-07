Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXCGQNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXCGQNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932346AbXCGQNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:13:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24636 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbXCGQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:13:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ulok5OS/Cr7AWFMnGx61eMZwmjs9bFwgq/Gn/IAPI1ib6nKGPeFsK5vlBIuK5Ouvj
	lZ9umxy3THzgF0VfxIj4A==
Message-ID: <6599ad830703070812p6071487ay841c0985fd734159@mail.gmail.com>
Date: Wed, 7 Mar 2007 08:12:20 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 2/7] containers (V7): Cpusets hooked into containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070307145257.GD32105@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.290909000@menage.corp.google.com>
	 <20070307145257.GD32105@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Mon, Feb 12, 2007 at 12:15:23AM -0800, menage@google.com wrote:
> > -     mutex_lock(&callback_mutex);
> > -     list_add(&cs->sibling, &cs->parent->children);
> > +     cont->cpuset = cs;
> > +     cs->container = cont;
> >       number_of_cpusets++;
> > -     mutex_unlock(&callback_mutex);
>
> What's the rule to read/write number_of_cpusets? The earlier cpuset code was
> incrementing/decrementing under callback_mutex, but now we aren't. How safe is
> that?

We're still inside manage_mutex, so we guarantee that no-one else is
changing it.

>
> The earlier cpuset code also was reading number_of_cpusets w/o the
> callback_mutex held (atleast in cpuset_zone_allowed_softwall). Is that safe?

Yes, I think so. Unless every memory allocator was to hold a lock for
the duration of alloc_pages(), number_of_cpusets can theoretically be
out of date by the time you're using it. But since the process could
have allocated just before you created the first cpuset and moved it
into that cpuset anywa, it's not really a race (and the consequences
are inconsequential).

Paul
