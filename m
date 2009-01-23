Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZAWQ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZAWQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZAWQ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:59:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:42411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZAWQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:59:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=FeZ4M8sqiRTjx8wkwQXFyYG8UzOYMt8Hu0w2AW88eBtprW9lA2sOCGVwM7uR7WGVK
	tsJE02pJ2/Jgsqjj1g1Qg==
MIME-Version: 1.0
In-Reply-To: <20090123102253.GF15188@elte.hu>
References: <20090123004703.25103.29754.stgit@menage.corp.google.com>
	 <20090123102253.GF15188@elte.hu>
Date: Fri, 23 Jan 2009 08:59:10 -0800
Message-ID: <6599ad830901230859p5453b166tfb384caad210f84b@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Fix root_count when mount fails due to busy 
	subsystem
From: Paul Menage <menage@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.143
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 2:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1115,8 +1115,10 @@ static void cgroup_kill_sb(struct super_block *sb) {
>>       }
>>       write_unlock(&css_set_lock);
>>
>> -     list_del(&root->root_list);
>> -     root_count--;
>> +     if (!list_empty(&root->root_list)) {
>> +             list_del(&root->root_list);
>> +             root_count--;
>> +     }
>
> That's ugly. It is _much_ cleaner to always keep the link head consistent
> - i.e. initialize it with INIT_LIST_HEAD()

It is initialized with INIT_LIST_HEAD().

> and then remove from it via
> list_del_init().

There's not much point doing list_del_init() rather than list_del()
here since we're about to delete the root.

>
> That way the error path will do the right thing automatically, and there's
> no need for that ugly "if !list_empty" construct either.

The important part here is avoiding decrementing root_count.

So the code could equally be:

if (!list_empty(&root->root_list)) {
  root_count--;
}
list_del(&root->root_list);

but what I have in this patch seems more straightforward. It's
actually how the code used to be before it was removed as a
"redundant" check by a patch that I unfortunately didn't get a chance
to read properly (or Ack) because I was too snowed under with other
work.

Paul
