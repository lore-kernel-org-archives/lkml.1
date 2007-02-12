Return-Path: <linux-kernel-owner+w=401wt.eu-S965331AbXBLT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331AbXBLT0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965332AbXBLT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:26:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:22850 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbXBLT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:26:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=dMCPvn52KGyujtI1mMZ450I4Boo6M3nXKz/na+ic4TdnYkU2js+NMWzu5z8D0uNN8
	gaVCiqQ5xH+My2yMAAYfQ==
Message-ID: <6599ad830702121126o35fb0cb6x696a4a56079bce40@mail.gmail.com>
Date: Mon, 12 Feb 2007 11:26:34 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070212123309.GA7526@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.130746000@menage.corp.google.com>
	 <20070212123309.GA7526@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Mon, Feb 12, 2007 at 12:15:22AM -0800, menage@google.com wrote:
> > +void container_fork(struct task_struct *child)
> > +{
> > +     task_lock(current);
>
> Can't this be just rcu_read_lock()?
>

In this particular patch (which is an almost verbatim
extraction/renaming of the generic bits of the cpusets code into
container.c) it probably could - but the main patch that adds the
container_group support would lose it since we use kref to refcount
container_group objects, and hence they're freed when their refcount
reaches zero. RCU is still fine for reading the container_group
pointers, but it's no good for updating them, since by the time you
update it it may no longer be your container_group structure, and may
instead be about to be deleted as soon as the other thread's
rcu_synchronize() completes.

Paul
