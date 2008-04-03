Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYDCSXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYDCSXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYDCSWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:22:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYDCSWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:22:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=g6kcaNc6SKy/gVXXZbipxqW88SEFMWmyWj4dq/s8pGvrBVTyONaUZB7Q6Ei1dYUye
	/N+lrw7HJkOGXD863yFGg==
Message-ID: <6599ad830804031122y3f6946fbp97dc18073bf02609@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:22:36 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F51DE7.7010204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain>
	 <6599ad830804031058l1e2a7ad9p56cff47dca738d79@mail.gmail.com>
	 <47F51DE7.7010204@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 11:11 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  >
>  > Hmm, is this new check for delay_group_leader() safe? Won't we have
>  > called exit_cgroup() by this point, and hence be reassigned to the
>  > root cgroup? And so mm->owner->cgroups won't point to the right place?
>  >
>
>  cgroup_exit() comes in much later after exit_mm(). Moreover delay_group_leader()
>  is a function that checks to see if

Sorry, I was unclear.

Yes, the call to cgroup_exit() comes much later than exit_mm() - but
it probably does come before the other users of the mm have finished
using the mm. So can't we end up with a situation like this?

A (group leader) exits; at this point, A->mm->owner == A
A calls exit_mm(), sees delay_group_leader(), doesn't change A->mm->owner
A calls cgroup_exit(), A->cgroups is set to init_css_set.
B (another thread) does something with B->mm->owner->cgroups (e.g. VM
accounting) and accesses the wrong group

Paul
