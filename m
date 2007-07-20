Return-Path: <linux-kernel-owner+w=401wt.eu-S935727AbXGTUay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935727AbXGTUay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764841AbXGTUar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:30:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764244AbXGTUaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:30:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=L3qzFCkJxgfWM0gXZhVdg0HhxKE4FsfkNO/4fxiNHMo++FxZPItd6S0Fpag+Nr5Kh
	PkU7WnIfRSb+h4MevYYAQ==
Message-ID: <6599ad830707201330t419458f2tba2d7a31d3b9701e@mail.gmail.com>
Date: Fri, 20 Jul 2007 13:30:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm PATCH 2/8] Memory controller containers setup (v3)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Linux MM Mailing List" <linux-mm@kvack.org>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Eric W Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070720082416.20752.92946.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop>
	 <20070720082416.20752.92946.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> +config CONTAINER_MEM_CONT
> +       bool "Memory controller for containers"
> +       select CONTAINERS

Andrew asked me to not use "select" in Kconfig files due to some
unspecified problems seen in the past, so my latest patchset makes the
subsystems depend on containers rather than selecting them; I prefer
the select approach over the dependency approach, but if select does
have problems then we should be consistent.

> +static struct cftype mem_container_usage = {
> +       .name = "mem_usage",
> +       .private = RES_USAGE,

For V11, the .name field should just be called something like 'usage';
the subsystem name is automatically prefixed.

> +
> +static int mem_container_create(struct container_subsys *ss,
> +                               struct container *cont)
> +{
> +       struct mem_container *mem;
> +
> +       mem = kzalloc(sizeof(struct mem_container), GFP_KERNEL);
> +       if (!mem)
> +               return -ENOMEM;
> +
> +       res_counter_init(&mem->res);
> +       cont->subsys[mem_container_subsys_id] = &mem->css;
> +       mem->css.container = cont;
> +       return 0;

For the V11 patchset, you'll want to replace these three lines with just

  return &mem->css;

> +static int mem_container_populate(struct container_subsys *ss,
> +                               struct container *cont)
> +{
> +       int rc = 0;
> +
> +       rc = container_add_file(cont, &mem_container_usage);
> +       if (rc < 0)
> +               goto err;
> +
> +       rc = container_add_file(cont, &mem_container_limit);
> +       if (rc < 0)
> +               goto err;
> +
> +       rc = container_add_file(cont, &mem_container_failcnt);
> +       if (rc < 0)
> +               goto err;

There's a container_add_files() API in V10 and above that lets you
register an array of files in one go.

> +
> +err:
> +       return rc;
> +}
> +
> +struct container_subsys mem_container_subsys = {
> +       .name = "mem_container",

Maybe just "memory" or "pages" for the container name?

Paul
