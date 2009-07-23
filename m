Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZGWX3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZGWX3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZGWX3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:29:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZGWX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:29:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Vm7CmtDzqrhhwGp+a5d4thg0YIxc1mVYmXrUthfw3WXXPo9V6BS6ufyKRiv107Paw
	ztGa/wQSGdVDmdjlevvOQ==
Date: Thu, 23 Jul 2009 16:29:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Paul Menage <menage@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mel@csn.ul.ie,
       npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <20090722233347.776E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907231624480.3476@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907211258500.10356@chino.kir.corp.google.com> <6599ad830907211303m25141938kcb75065a74a40ee2@mail.gmail.com> <20090722233347.776E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, KOSAKI Motohiro wrote:

> > It's the API that's existed for years with no complaints, AFAICS.
> 
> I think thead and vfork() should be separeted on this discussion.
> I agree vfork() regression should be fixed. but I don't think anyone
> hope per-thread oom score. 
> 
> Of cource, if simple reverting is best way, I don't oppose this.... ;-)
> 

Simply reverting it isn't an option unless you fix the underlying livelock 
problem that my patches originally addressed and no viable alternative has 
been proposed.

On the other hand, I think adding /proc/pid/oom_adj_child would solve the 
userspace issue.  oom_adj_child would be the oom_adj value that is used by 
the newly initialized mm_struct; this would allow the vfork'd child to 
share the same oom_score with the parent and then be replaced with an 
alternate score on execve().

oom_adj_child would only be allowed to be greater (i.e. the more preferred 
victim) than oom_adj for any given thread since the oom killer tries to 
kill a child of the selected task first if it doesn't share memory.
