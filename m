Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYDDIuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYDDIuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYDDIum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:50:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6969 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYDDIul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:50:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Kw8sH9UIyeNhp5qXCCyWuIYDfQzO/l0tHanLiQuMu0IN20r8PLfXWYNlQgLhqjcVC
	BgQmGNn6UZAgvtbmCd5NA==
Message-ID: <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com>
Date: Fri, 4 Apr 2008 01:50:15 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F5E69C.9@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
	 <6599ad830804040112q3dd5333aodf6a170c78e61dc8@mail.gmail.com>
	 <47F5E69C.9@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 1:28 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  It won't uncharge for the memory controller from the root cgroup since each page
>   has the mem_cgroup information associated with it.

Right, I realise that the memory controller is OK because of the ref counts.

>  For other controllers,
>  they'll need to monitor exit() callbacks to know when the leader is dead :( (sigh).

That sounds like a nightmare ...

>
>  Not having the group leader optimization can introduce big overheads (consider
>  thousands of tasks, with the group leader being the first one to exit).

Can you test the overhead?

As long as we find someone to pass the mm to quickly, it shouldn't be
too bad - I think we're already optimized for that case. Generally the
group leader's first child will be the new owner, and any subsequent
times the owner exits, they're unlikely to have any children so
they'll go straight to the sibling check and pass the mm to the
parent's first child.

Unless they all exit in strict sibling order and hence pass the mm
along the chain one by one, we should be fine. And if that exit
ordering does turn out to be common, then simply walking the child and
sibling lists in reverse order to find a victim will minimize the
amount of passing.

One other thing occurred to me - what lock protects the child and
sibling links? I don't see any documentation anywhere, but from the
code it looks as though it's tasklist_lock rather than RCU - so maybe
we should be holding that with a read_lock(), at least for the first
two parts of the search? (The full thread search is RCU-safe).

Paul
