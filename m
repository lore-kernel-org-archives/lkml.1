Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbYDOC3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbYDOC3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbYDOC2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:28:48 -0400
Received: from rv-out-0708.google.com ([209.85.198.245]:41297 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763632AbYDOC2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kQQsPYFogplgrieU9/+O2TereCH9MdURSRvrAcvyqq6xqGIQSX/ucTpU1m5Kon1EMut/Uw95o0wez8KQG9YYya6uOX8WuCEBdlW1xWSv/dXEdgx9Pwev9v9QmIVnIoMXwB1mQ9qNqYCxZs6CfDEMSbZnOHDgPznnNlIzO1PjxZg=
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation. v2
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, menage@google.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080414192042.c50d8d58.akpm@linux-foundation.org>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>
	 <48040E19.2090007@cn.fujitsu.com>
	 <20080414192042.c50d8d58.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 19:28:48 -0700
Message-Id: <1208226528.11920.55.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 19:20 -0700, Andrew Morton wrote:
> On Tue, 15 Apr 2008 10:08:25 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > > @@ -992,8 +993,10 @@ mem_cgroup_create(struct cgroup_subsys *
> > >  	if (unlikely((cont->parent) == NULL)) {
> > >  		mem = &init_mem_cgroup;
> > >  		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
> > > -	} else
> > > -		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
> > > +	} else {
> > > +		mem = vmalloc(sizeof(struct mem_cgroup));
> > > +		memset(mem, 0, sizeof(*mem));
> > 
> > what if mem == NULL. ;)
> > 
> > > +	}
> > >  
> > >  	if (mem == NULL)
> > >  		return ERR_PTR(-ENOMEM);
> > 
> > So we can move this NULL check to the above else branch, in the if brach,
> > mem won't be NULL.
> 
> err, yes.
> 
> So I have:
> 
> 	if (unlikely((cont->parent) == NULL)) {

	if (unlikely(cont->parent == NULL)) {

> 		mem = &init_mem_cgroup;
> 		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
> 	} else {
> 		mem = vmalloc(sizeof(struct mem_cgroup));
> 		if (mem == NULL)

		if (!mem)

> 			return ERR_PTR(-ENOMEM);
> 		memset(mem, 0, sizeof(*mem));
> 	}
> 

Cheers,

Harvey


