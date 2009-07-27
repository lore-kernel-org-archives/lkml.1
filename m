Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZG0Xss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZG0Xss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZG0Xsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:48:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZG0Xsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:48:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NS0gckb0yaR/dXjEh63k52qCgEsMRyKyqXD88IyhTuT7yaycoU6Nj2P9W+g6H2Ke0
	3qzq5N5N1cxLRMJbAG+jg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com>
Date: Mon, 27 Jul 2009 16:48:41 -0700
Message-ID: <6599ad830907271648v41b006c0j727fc09665f4f47e@mail.gmail.com>
Subject: Re: [patch -mmotm] mm: introduce oom_adj_child
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 2:50 PM, David Rientjes<rientjes@google.com> wrote:
> +If oom_adj_child is set to equal oom_adj, then it will mirror oom_adj whenever
> +it changes.  This avoids having to set both values when simply tuning oom_adj
> +and that value should be inherited by all children.

Maybe have a distinct value for oom_adj_child (the default) that means
"default to mm->oom_adj" ?

Shouldn't oom_adj_child be per-task? Otherwise you're theoretically
allowing races between different threads that try to fork children
with different oom_adj values at the same time. Not a particularly
likely problem, but it seems bad to bake the change of races into the
API.

Also, I'm not sure that the requirement that oom_adj_child be >=
oom_adj is a good restriction. Sure, if a task gives its child a lower
oom_adj than itself it's potentially playing with fire, but it may
well be that the new child is expected todaemonize itself in the very
near future and hence no longer be the child of the current process. I
don't think that restricting the values that the sysadmin or root
processes can apply on the grounds that they might not do what they
want is the right approach.

It would also maybe be nicer to use a prctl() rather than introducing
yet another file in /proc/<pid> - but I guess that's a style argument
rather than a strict technical issue.

Paul
