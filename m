Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXEaIzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXEaIzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXEaIzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:55:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25205 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbXEaIzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:55:38 -0400
Message-ID: <465E8E93.50609@openvz.org>
Date: Thu, 31 May 2007 13:00:03 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 4/8] RSS container core
References: <465D9739.8070209@openvz.org>	<465D98FE.8040609@openvz.org> <20070530144617.d844eb64.akpm@linux-foundation.org>
In-Reply-To: <20070530144617.d844eb64.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +#else
>> +static inline int container_rss_prepare(struct page *pg,
>> +		struct vm_area_struct *vma, struct page_container **pc)
>> +{
>> +	*pc = NULL; /* to make gcc happy */
> 
> eh?  What is gcc's problem here?

When this line is missed and CONFIG_RSS_COUNTER is n the following
warnings are produced:

  CC      mm/memory.o
mm/memory.c: In function ‘__do_fault’:
mm/memory.c:2472: warning: ‘pcont’ is used uninitialized in this function
mm/memory.c: In function ‘do_wp_page’:
mm/memory.c:1788: warning: ‘pcont’ is used uninitialized in this function
mm/memory.c: In function ‘__handle_mm_fault’:
mm/memory.c:2317: warning: ‘pcont’ is used uninitialized in this function
mm/memory.c:2253: warning: ‘pcont’ is used uninitialized in this function

>> +	return 0;
>> +}
>>
>> ...
>>
>> +static int rss_populate(struct container_subsys *ss,
>> +		struct container *cont)
>> +{
>> +	int rc;
>> +
>> +	if ((rc = container_add_file(cont, &rss_usage)) < 0)
>> +		return rc;
>> +	if ((rc = container_add_file(cont, &rss_failcnt)) < 0)
>> +		return rc;
>> +	if ((rc = container_add_file(cont, &rss_limit)) < 0)
>> +		return rc;
>> +	if ((rc = container_add_file(cont, &rss_reclaimed)) < 0)
>> +		return rc;
> 
> If we fail partway through here, do the thus-far-created fiels get cleaned up?

Yes. As far as I see from Paul's code when one of the files is failed to
be created the whole container is cleaned up.

>> +	return 0;
>> +}
>> +
>> +struct container_subsys rss_subsys = {
>> +	.name = "rss",
>> +	.subsys_id = rss_subsys_id,
>> +	.create = rss_create,
>> +	.destroy = rss_destroy,
>> +	.populate = rss_populate,
>> +	.attach = rss_move_task,
>> +	.early_init = 1,
>> +};
> 
> Did this need kernel-wide scope?

Yes. In include/linux/countainer_subsys.h we declared the SUBSYS(rss) 
that is expanded into "extern struct container_subsys rss_subsys;" in the
kernel/container.c file. Further the pointer to it is injected into the array
of subsystems (static struct container_subsys *subsys[]; at the top of the file).
