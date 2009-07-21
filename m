Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZGUQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZGUQG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZGUQG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:06:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40102 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbZGUQG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:06:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=h/FpW8Jx2bXDY2nnriGoO3D+6fvg+zZuoafNjqnLIfptOJo8WnizwbKEsaEFyNd/f
	JOA56cFAPLpzZiehDPB/Q==
MIME-Version: 1.0
In-Reply-To: <20090721161319.2ABD.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
	 <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
	 <20090721161319.2ABD.A69D9226@jp.fujitsu.com>
Date: Tue, 21 Jul 2009 09:06:20 -0700
Message-ID: <6599ad830907210906tf81842ds897012bbf0e5606d@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mel@csn.ul.ie,
       npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:19 AM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Paul, I'd like to clarily this duscussion. Doesn't Rik's patch fix your vfork issue or
> you worry about generic ABI breaking issue?
>

No, Rik's patch just fixes the lack of inheritability that David
introduced originally. It doesn't address the problem that the
intention of the patches is to disallow separate processes sharing the
same VM from having different oom_adj scores, which breaks the
previous ability to vfork() or clone(CLONE_VM) a child and set its
oom_adj to a non-disabled value prior to execve().

I think that in the case of our job scheduler, we can probably change
it to do a full fork() rather than clone(), at a little extra cost
(copying the entire mm rather than just cloning a thread). Our job
scheduler is generally a small process, so this shouldn't be too
expensive. But for large processes, the overhead of a full mm copy is
bigger.

Paul
