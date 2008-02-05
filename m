Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbYBEWKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbYBEWKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbYBEWK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:10:27 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:40942 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409AbYBEWKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:10:25 -0500
Message-Id: <47A896FB.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 05 Feb 2008 15:03:55 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: <dwalker@mvista.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: CPU hotplug and IRQ affinity with 2.6.24-rt1
References: <47A7A131.8040800@qualcomm.com>
 <20080205025144.GA31774@dwalker1.mvista.com>
 <47A7A784.BA47.005A.0@novell.com>
 <20080205165936.GA18613@dwalker1.mvista.com>
 <47A863BE.BA47.005A.0@novell.com>
 <20080205215805.GD18613@dwalker1.mvista.com>
In-Reply-To: <20080205215805.GD18613@dwalker1.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Feb 5, 2008 at  4:58 PM, in message
<20080205215805.GD18613@dwalker1.mvista.com>, Daniel Walker
<dwalker@dwalker1.mvista.com> wrote: 
> On Tue, Feb 05, 2008 at 11:25:18AM -0700, Gregory Haskins wrote:
>> @@ -6241,7 +6242,7 @@ static void rq_attach_root(struct rq *rq, struct 
> root_domain *rd)
>>                 cpu_clear(rq->cpu, old_rd->online);
>> 
>>                 if (atomic_dec_and_test(&old_rd->refcount))
>> -                       kfree(old_rd);
>> +                       reap = old_rd;
> 
> Unrelated to the in atomic issue, I was wondering if this if statement
> isn't true can the old_rd memory get leaked, or is it cleaned up
> someplace else?

Each RQ always has a reference to one root-domain and is thus represented by the rd->refcount.  When the last RQ drops its reference to a particular instance, we free the structure.  So this is the only place where we clean up, but it should also be the only place we need to (unless I am misunderstanding you?)

Note that there is one exception: the default root-domain is never freed, which is why we initialize it with a refcount = 1.  So it is theoretically possible to have this particular root-domain dangling with no RQs associated with it, but that is by design. 

Regards,
-Greg

