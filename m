Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbYIWMue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbYIWMue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYIWMu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:50:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:1323 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYIWMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gZ7Zs5nJkcpsb8Kp7w6bWZo07kR9F2rDuSvEypYKVc+a/xcdpbNoDolL5xnmOnWYC/
         j6jQuzI8Wolu9gXzaJBWxENLbO4f7GXuAn7yCz9lBB48si9EK96VeNcprt5/tf8os1bA
         WXA7t/23vddfSvuQf+Xpjnbrb/4Cw8+WShnkQ=
Message-ID: <48D8E60A.20003@gmail.com>
Date: Tue, 23 Sep 2008 14:50:18 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Michael Rubin <mrubin@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       dave@linux.vnet.ibm.com, chlunde@ping.uio.no, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, agk@sourceware.org,
       m.innocenti@cineca.it, s-uchida@ap.jp.nec.com, ryov@valinux.co.jp,
       matt@bluehost.com, dradford@bluehost.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com>	 <20080912131816.e0cfac7a.akpm@linux-foundation.org> <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
In-Reply-To: <532480950809221641y3471267esff82a14be8056586@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Rubin wrote:
> On Fri, Sep 12, 2008 at 1:18 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> One thing to think about please: Michael Rubin is hitting problems with
>> the existing /proc/sys/vm/dirty-ratio.  Its present granularity of 1%
>> is just too coarse for really large machines, and as
>> memory-size/disk-speed ratios continue to increase, this will just get
>> worse.
> 
> Re-sending since I top-posted before. Never again. Also adding more
> thoughts on a byte based interface.
> 
> Currently the problem we are hitting is that we cannot specify pdflush
> to have background limits less than 1% of memory. I am currently
> finishing up a patch right now that adds a dirty_ratio_millis
> interface.  I hope to submit the patch to LKML by the end of the week.
> 
> The idea is that we don't want to break backwards compatibility and we
> also don't want to have two conflicting knobs in the sysctl or
> /proc/sys/vm/ space. I thought adding a new knob for those who want to
> specify finer grained functionality was a compromise. So the patch has
> a vm_dirty_ratio and a vm_dirty_ratio_millis interface. The first to
> specify 0-100% and the second to specify .0 to .999%.
> 
> So to represent 0.125% of RAM we set
> vm_dirty_ratio = 0
> vm_dirty_ratio_millis = 125
> 
> The same for the background_ratio.
> 
> I would also prefer using a bytes interface but I am not sure how to
> offer that without  either removing the legacy interface of the ratios
> or by offering a concurrent interface that might be confusing such as
> when users are looking at the old one and not aware of a new one.
> 
> Any feedback?
> 
> mrubin

I think using millis is ok today, but it may not scale well to systems
with 1TB of memory (in this case the min granularity would be 10MB).

A bytes/pages interface would resolve such problem also for tomorrow
machines.

Moreover, wouldn't it be safer to set them mutually exclusive? I mean,
writing a value != 0 to vm_dirty_millis automatically sets
vm_dirty_ratio to 0 (disabled) and vice versa (this could be implemented
using an appropriate .proc_handler for example).

OK, I would like to set percentages like 12.456%, but if we don't do so
a simple "sysctl -p" could create unexpected behaviours, reconfiguring
the vm_dirty_ratio and not vm_dirty_ratio_millis for example.

The same should be valid also for a bytes/pages interface, so setting
vm_dirty_bytes != 0 (or vm_dirty_pages) should "disable" vm_dirty_ratio
and vice versa.

Thanks,
-Andrea
