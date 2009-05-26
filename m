Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZEZVjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZEZVjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZEZVjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:39:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1785 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbZEZVja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:39:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Vug2F3Xi8rpVZpp7gLgu8+gUav5IxTIl99T5daaFV5jqOa8SOvYIhdgKIUs0i6YdI
	8z8ruFn4ppD1rhCeN0/2w==
MIME-Version: 1.0
In-Reply-To: <20090526140408.6c829124.akpm@linux-foundation.org>
References: <20090526195840.8464.36548.stgit@menage.mtv.corp.google.com>
	 <20090526140408.6c829124.akpm@linux-foundation.org>
Date: Tue, 26 May 2009 14:39:27 -0700
Message-ID: <6599ad830905261439s63152c63s8b79f203600a2e5c@mail.gmail.com>
Subject: Re: [PATCH] cls_cgroup: read classid atomically in classifier
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lizf@cn.fujitsu.com, davem@davemloft.net, tgraf@suug.ch,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 2:04 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 26 May 2009 12:59:11 -0700
> Paul Menage <menage@google.com> wrote:
>
>> Avoid reading the unsynchronized value cs->classid multiple times,
>> since it could change concurrently from non-zero to zero; this would
>> result in the classifier returning a positive result with a bogus
>> (zero) classid.
>
> When this race occurs, what are the user-visible consequences?

My guess is very little - rather than returning -1 to indicate that
there's no classid associated with the flow, we're returning a
positive response that the classid is 0. I don't know the network
scheduling code well enough to predict what effect that would have,
but I'd guess it results in the subsequent classid->queue lookup
failing and the packet being shunted down some default queue (unless
the user happens to have set up a queue with id 0). But the race looks
to be against the intent of the code, which is to return -1 if the
classid is 0, or fill in the res struct if it's non-zero.

>
> People who need to decide to which kernels a patch should be applied
> like to know such things.
>

I don't think this is a -stable candidate.

Paul
