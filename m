Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXDGRaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXDGRaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXDGRaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:30:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbXDGRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:30:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DAZ7WiSbXdnQpd259zKedKqv06oM1ETd1fqN20kXnRowHaoQz4EHNJXUqb+Ny7LmD
	uR7daaxB9U7uiwsW32Blw==
Message-ID: <6599ad830704071030s3887ded2r5597e19507cb556f@mail.gmail.com>
Date: Sat, 7 Apr 2007 10:30:27 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
In-Reply-To: <20070407041851.GA15007@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406233221.989528000@menage.corp.google.com>
	 <20070407001324.271959000@menage.corp.google.com>
	 <20070407041851.GA15007@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Fri, Apr 06, 2007 at 04:32:24PM -0700, menage@google.com wrote:
> > +static int attach_task(struct container *cont, struct task_struct *tsk)
> >  {
>
> [snip]
>
> > +     task_lock(tsk);
>
> You need to check here if task state is PF_EXITING and fail with
> -ESRCH if so? Otherwise we risk breaking refcount on
> init_container_group.
>

Yes, I think you're right; I've now changed it to this in my tree:

        task_lock(tsk);
        if (tsk->flags & PF_EXITING) {
                task_unlock(tsk);
                put_container_group(newcg);
                return -ESRCH;
        }
        rcu_assign_pointer(tsk->containers, newcg);
        task_unlock(tsk);

Thanks,

Paul
