Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZGNV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZGNV0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZGNV0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:26:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:42431 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZGNV0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:26:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LAIneFroTlHbAlIiCVkC51AxdP5qIN3DEmSzEan/EGLPTlh7a0sDD1wYhJkq3lpRo
	mFz410qEb+D2czflwm6+g==
MIME-Version: 1.0
In-Reply-To: <1247596470.13426.16088.camel@nimitz>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
	 <1247596470.13426.16088.camel@nimitz>
Date: Tue, 14 Jul 2009 14:26:16 -0700
Message-ID: <2f86c2480907141426r16f8ccf3o9770e25cc8d2e509@mail.gmail.com>
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Benjamin Blum <bblum@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 11:34 AM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
> On Fri, 2009-07-10 at 16:01 -0700, Ben Blum wrote:
>> +struct cgroup_pidlist {
>> +       /* protects the other fields */
>> +       struct rw_semaphore mutex;
>> +       /* array of xids */
>> +       pid_t *list;
>> +       /* how many elements the above list has */
>> +       int length;
>> +       /* how many files are using the current array */
>> +       int use_count;
>> +};
>
> I think a slightly nicer way of doing this would be to use a structure
> like this:
>
> #define NR_PIDS (PAGE_SIZE-sizeof(struct list_head))
> struct pid_list {
>        struct list_head list;
>        pid_t pids[NR_PIDS];
> };
>
> That way, you can always kmalloc(sizeof(pid_list)), it fits nicely in
> PAGE_SIZE, and you can chain them together.
>
> Or, you could always just use one of the other flexible structures in
> the kernel like a radix_tree.
>
> -- Dave

This method looks to be a compromise between Andrew's proposed
generalized solution ( http://lkml.org/lkml/2009/7/2/518 ) and the
current quick-fix. The problem with it is that it'll require a layer
between whoever's using the array and managing the list structs (for
the case where we need to chain multiple blocks together), and if
we're going to put forth enough effort for that, we may as well go
ahead and write up a generalized kernel-wide library to fix this size
problem globally.
