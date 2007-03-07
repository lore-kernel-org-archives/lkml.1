Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXCGCA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXCGCA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161202AbXCGCA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:00:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:11245 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161199AbXCGCAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:00:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rmVG8agpKgYKkzUAke5k4Sq+Ew2x26IZLTex+OyZW1aOHbc124yC7yO4ArSHnH02L
	sY60KSuOC6bnEz+xs4bvQ==
Message-ID: <6599ad830703061800n38244a8fp68b29fa0290d18d7@mail.gmail.com>
Date: Tue, 6 Mar 2007 18:00:04 -0800
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [RFC][PATCH 6/7] Account for the number of tasks within container
Cc: "Andrew Morton" <akpm@osdl.org>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>, devel@openvz.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, "Kirill Korotaev" <dev@sw.ru>
In-Reply-To: <45ED831A.5030108@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru> <45ED831A.5030108@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 3/6/07, Pavel Emelianov <xemul@sw.ru> wrote:
> diff -upr linux-2.6.20.orig/include/linux/sched.h linux-2.6.20-0/include/linux/sched.h
> --- linux-2.6.20.orig/include/linux/sched.h     2007-03-06 13:33:28.000000000 +0300
> +++ linux-2.6.20-0/include/linux/sched.h        2007-03-06 13:33:28.000000000 +0300
> @@ -1052,6 +1055,9 @@ struct task_struct {
>  #ifdef CONFIG_FAULT_INJECTION
>         int make_it_fail;
>  #endif
> +#ifdef CONFIG_PROCESS_CONTAINER
> +       struct numproc_container *numproc_cnt;
> +#endif
>  };

Why do you need a pointer added to task_struct? One of the main points
of the generic containers is to avoid every different subsystem and
resource controller having to add new pointers there.

> +
> +       rcu_read_lock();
> +       np = numproc_from_cont(task_container(current, &numproc_subsys));
> +       css_get_current(&np->css);

There's no need to hold a reference here - by definition, the task's
container can't go away while the task is in it.

Also, shouldn't you have an attach() method to move the count from one
container to another when a task moves?

Paul
