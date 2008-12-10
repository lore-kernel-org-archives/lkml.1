Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYLJSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYLJSgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbYLJSfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:35:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:18948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbYLJSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:35:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=pW1cTTN0MmGyiYl44TvRZuPvVPB04fuiPKuyq+/qNPo5NYxEG15pcZ8GBL0evPsll
	1PQtziUEQI5xNDbgmQ3vQ==
MIME-Version: 1.0
In-Reply-To: <29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	 <29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
Date: Wed, 10 Dec 2008 10:35:34 -0800
Message-ID: <6599ad830812101035v33dbc6cfh57aa5510f6d65d54@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 3:29 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> (BTW, I don't like hierarchy-walk-by-small-locks approarch now because
>  I'd like to implement scan-and-stop-continue routine.
>  See how readdir() aginst /proc scans PID. It's very roboust against
>  very temporal PIDs.)

So you mean that you want to be able to sleep, and then contine
approximately where you left off, without keeping any kind of
reference count on the last cgroup that you touched? OK, so in that
case I agree that you would need some kind of hierarch

> I tried similar patch and made it to use only one shared refcnt.
> (my previous patch...)

A crucial difference is that your css_tryget() fails if the cgroups
framework is trying to remove the cgroup but might abort due to
another subsystem holding a reference, whereas mine spins and if the
rmdir is aborted it will return a refcount.

>
> We need rolling update of refcnts and rollback. Such code tends to make
> a hole (This was what my first patch did...).

Can you clarify what you mean by "rolling update of refcnts"?

>
> 1. pre_destroy() is called by rmdir(), in synchronized manner.
>   This means that all refs in memcg will be removed at rmdir().
>   If we drop refs at destroy(), it happens when dput()'s refcnt finally
>   goes down to 0. This asynchronous manner is not good for users.

OK, fair enough.

Paul
