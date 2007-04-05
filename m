Return-Path: <linux-kernel-owner+w=401wt.eu-S1767003AbXDEONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767003AbXDEONz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766999AbXDEONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:13:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17222 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767003AbXDEONx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:13:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XBtfgL6LZ6sZ+4rbYLOwzBdICzk2W3JvO6Otx+qmyqAp7ipdawTwnH5aPo18ZDqgY
	vkeF+UcnJWmo0U3W1f2IA==
Message-ID: <6599ad830704050713h34752b1cted9dbe1ff7ab8bec@mail.gmail.com>
Date: Thu, 5 Apr 2007 07:13:37 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
In-Reply-To: <20070405124325.GA13822@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070404030756.GA9008@in.ibm.com>
	 <20070404051526.GA16562@in.ibm.com>
	 <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com>
	 <20070404172643.GA28328@in.ibm.com>
	 <6599ad830704041957y7b81c4ecrd21f4c08b9d7c72d@mail.gmail.com>
	 <20070405063950.GA3435@in.ibm.com>
	 <6599ad830704042348q5675c01ep92679fb3275bafac@mail.gmail.com>
	 <20070405084920.GB20356@in.ibm.com>
	 <6599ad830704050229q1d4d1ef9ved0e58b93aef31ff@mail.gmail.com>
	 <20070405124325.GA13822@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> > If the container directory were to have no refcount on the nsproxy, so
> > the initial refcount was 0,
>
> No it should be 1.
>
>         mkdir H1/foo
>                 rcfs_create()
>                    ns = dup_namespaces(parent);
>
>                     ....
>                    dentry->d_fsdata = ns;
>
> ns should have a refcount of 1 to begin with.

Right - that's my point, you're effectively passing the initial
refcount of the nsproxy to the container directory's d_fsdata
reference.

>
>         - refcount of a nsproxy attached to a directory dentry can never
>           fall to zero because of tasks coming in and out. The only
>           way for the refcount of such nsproxies to fall to zero and
>           hence trigger their destruction is thr' the rmdir i/f.
>
>         - New nsproxies derived from the base directory nsproxy
>           can have their's refcount go to zero as tasks exit or move
>           around and hence they will be destroyed.
>
> Does that sound like correct behavior?

Sounds good.

>
> > Possibly - there are two choices:
> >
> > 1) expose a refcount to them directly, and just interrogate the
> > refcount from the generic code to see if it's safe to delete the
> > directory
> >
> > 2) have a can_destroy() callback with well defined semantics about
> > when it's safe to take refcounts again - it's quite possible that one
> > subsystem can return true from can_destroy() but others don't, in
> > which case the subsystem can become active again.
>
> Lets go back to the f_bc example here for a moment. Lets say T1 was in C1 and
> opened file f1. f1->f_bc points to C1->beancounter.
>
> T1 moves from C1 -> C2, but f1 is not migrated.
> C1->beancounter.count stays at 1 (to account for f1->f_bc).
>
> File f1 is closed. C1->beancounter.count becomes zero.
>
> Now user issues rmdir C1. If rmdir finds (after taking manage_mutex that
> is)
>
>         - zero tasks in C1
>         - zero refcount in C1->beancounter
>
> why is it not safe to assume that C1->beancounter.count will continue to
> stay zero?
>
> Basically I am struggling to answer "How can a zero refcount (beancounter)
> object go non-zero when zero tasks are attached to it" ..

In that case, I think you're fine. Your last posted patches didn't
provide a way to check for that, though, as far as I could see.

Paul
