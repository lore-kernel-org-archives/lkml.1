Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYIERio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYIERio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYIERig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:38:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:10126 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYIERif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=r/6n3msFJjKLV/LEZyaJISMeZpBkk+I2RLePESbVWSsquwh75mEojtqzW0C1ZniaoN
         7Fksmvdxcjyp8L82CPwJ6LAQ5I+zhXmRhTZunTa6Rptk5+2vKEIzm6xI0WJBOWmWso+j
         0y8N0vVvZpz+m0YCJ++5moI0aOKowRY1ql4Ps=
Message-ID: <48C16E92.5000402@gmail.com>
Date: Fri, 05 Sep 2008 19:38:26 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, akpm@linux-foundation.org, agk@sourceware.org,
       subrata@linux.vnet.ibm.com, axboe@kernel.dk,
       Marco Innocenti <m.innocenti@cineca.it>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com, dradford@bluehost.com, ryov@valinux.co.jp
Subject: Re: [RFC][PATCH -mm 0/5] cgroup: block device i/o controller (v9)
References: <1219853257-11052-1-git-send-email-righi.andrea@gmail.com> <20080902180620.GE15847@redhat.com> <48BDA704.9040000@gmail.com> <20080902214146.GA3382@redhat.com> <20080905155944.GF13742@redhat.com>
In-Reply-To: <20080905155944.GF13742@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Ok, to be more specific, I was thinking of following.
> 
> Currently, all the requests for a block device go into request queue in
> a linked list and then associated elevator selects the best request for
> dispatch based on various policies as dictated by elevator.
> 
> Can we maintan an rb-tree per request queue and all the requests being
> queued on that request queue first will go in this rb-tree. Then based on
> cgroup grouping and control policy (max bandwidth capping, proportional
> bandwidth etc), one can pass the requests to elevator associated with the
> queue (which will do the actual job of merging and other things).

Could a workqueue like kblockd move requests from rb-tree to the equivalent
request queue?

> 
> So effectively first we provide control at cgroup level and then let
> elevator take the best decisions with in that.

I think I've to figure better all the implementation details, but yes,
sounds good. This seems to be the right approach to provide any kind of
IO controlling: bandwidth throttling, proportional bandwidth,
ionice-like approach, etc.

> This should not require creation of any dm-ioband devices to control the
> devices. Each block device will contain one rb-tree (cgroups hanging) as
> long has somebody has put a controlling policy on that devices. (We can
> probably use your interfaces to create policies on devices through cgroup
> files).
> 
> This should not require elevator modifications and should work well with
> stacked devices. 
> 
> I will try to write some prototype patches and see if all the above
> gibber makes any sense and is workable or not.

That would be great!

> 
> One limitation in this scheme is that we are providing grouping capability
> based on cgroups only and it is not as generic what dm-ioband is providing.
> Do we really require other ways of creating grouping. Creating another device
> for each device you want to control sounds odd to me.

In any case libcgroup could help here to define any grouping policy
(uid, gid, pid, ...). So, IMHO the grouping capability provided by
cgroups is in perspective generic as well as what dm-ioband provides.

Thanks,
-Andrea
