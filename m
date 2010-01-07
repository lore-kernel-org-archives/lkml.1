Return-Path: <linux-kernel-owner+w=401wt.eu-S932878Ab0AGBBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0AGBBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469Ab0AGBBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:01:36 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0AGBBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:01:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=MngZCrPf3mV9lUPk3gd1zzA/YjhnoO8yo/3x/AceIE+OcY3EWV4dEwwCQP/PxCfqB
	ESwS4I8K+M6C7IpebZgQA==
MIME-Version: 1.0
In-Reply-To: <9411cbdd545e1232c916bfef03a60cf95510016d.1262186098.git.kirill@shutemov.name>
References: <cover.1262186097.git.kirill@shutemov.name>
	 <9411cbdd545e1232c916bfef03a60cf95510016d.1262186098.git.kirill@shutemov.name>
Date: Wed, 6 Jan 2010 17:01:21 -0800
Message-ID: <6599ad831001061701x72098dacn7a5d916418396e33@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] cgroup: implement eventfd-based generic API for 
	notifications
From: Paul Menage <menage@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 7:57 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> This patch introduces write-only file "cgroup.event_control" in every
> cgroup.

This looks like a nice generic API for doing event notifications - thanks!

Sorry I hadn't had a chance to review it before now, due to travelling
and day-job pressures.


> +}
> +
> +static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
> +               int sync, void *key)

Maybe some comments here indicating how/when it gets called? (And more
comments for each function generally?)

> +       if (flags & POLLHUP) {
> +               spin_lock(&cgrp->event_list_lock);
> +               list_del(&event->list);
> +               spin_unlock(&cgrp->event_list_lock);
> +               schedule_work(&event->remove);

Comment saying why we can't do the remove immediately in this context?

> +
> +fail:
> +       if (!IS_ERR(cfile))
> +               fput(cfile);

cfile is either valid or NULL - it never contains an error value.

> +
> +       if (!IS_ERR(efile))
> +               fput(efile);

While this is OK currently, it's a bit fragile. efile starts as NULL,
and IS_ERR(NULL) is false. So if we jump to fail: before trying to do
the eventfd_fget() then we'll try to fput(NULL), which will oops. This
works because we don't currently jump to fail: until after
eventfd_fget(), but someone could add an extra setup step between the
kzalloc() and the eventfd_fget() which could fail.

Paul
