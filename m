Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZJ1AZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZJ1AZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZJ1AZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:25:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7208 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbZJ1AZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:25:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=OOFjL+vD1+EI5ABGOhm/hCFuOs+ttuS9eUT/YYT5oLje1UIO0qd8J9dzFCFgwd21T
	9fgkphFrpDQrlpYA2LPCA==
Date: Tue, 27 Oct 2009 17:25:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <4AE78B8F.9050201@gmail.com>
Message-ID: <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.0910271723231.17615@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Vedran Fura wrote:

> But it is wrong at counting allocated memory!
> Come on, it kills /usr/lib/icedove/run-mozilla.sh. Parent, a shell
> script, instead of its child(s) which allocated memory. Look, "test"
> allocates some (0.1GB) memory, and you have:
> 
> % cat test.sh
> 
> #!/bin/sh
> ./test&
> ./test&
> ./test&
> ./test
> 
> % perl check_badness.pl|sort -n|g test
> 
> 26511   7884    test
> 26511   7885    test
> 26511   7886    test
> 26511   7887    test
> 53994   7883    test.sh
> 
> // great, so test.sh "is" the bad ass, ok, emulate OOMK:
> 
> % kill -9 7883
> 
> // did we kill "a rogue task"
> 
> % perl check_badness.pl|sort -n|g test
> 
> 26511   7884    test
> 26511   7885    test
> 26511   7886    test
> 26511   7887    test
> 
> // nooo, they are still alive and eating our memory!
> 

This is wrong; it doesn't "emulate oom" since oom_kill_process() always 
kills a child of the selected process instead if they do not share the 
same memory.  The chosen task in that case is untouched.
