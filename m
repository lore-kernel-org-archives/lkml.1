Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZIIBWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZIIBWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZIIBWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:22:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63118 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIIBWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:22:38 -0400
Message-ID: <4AA70315.7010600@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 09:21:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/filters: use strcmp() instead of strncmp()
References: <4A1F9FAC.6020506@cn.fujitsu.com>	 <c62985530905290651id2435bfx7f57ec561fe366e3@mail.gmail.com>	 <4A20F71F.6030703@cn.fujitsu.com> <20090530135236.GB5969@nowhere>	 <4A223F7E.3090203@cn.fujitsu.com> <20090531132853.GA6013@nowhere>	 <4A236B0B.3000604@cn.fujitsu.com> <20090601130928.GA6000@nowhere>	 <4A247875.9010507@cn.fujitsu.com> <1252379033.21261.2060.camel@gandalf.stny.rr.com>
In-Reply-To: <1252379033.21261.2060.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not sure this is an issue. I may be a little out of context here, but
> isn't addr coming from the event? The event is made in the kernel and
> should be fine?
> 
> What ever the case, the bug you originally mentioned is still there (I
> just tried it out on the latest tip). That is, name == et will match
> "eth0".
> 

Strange. I fixed it with this commit:

========
commit 7d536cb3fb9993bdcd5a2fbaa6b0670ded4e101c
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Thu Jul 16 10:54:02 2009 +0800

    tracing/events: record the size of dynamic arrays

    When a dynamic array is defined, we add __data_loc_foo in
    trace_entry to record the offset of the array, but the
    size of the array is not recorded, which causes 2 problems:

    - the event filter just compares the first 2 chars of the strings. <-- note here!!

    - parsers can't parse dynamic arrays.

    So we encode the size of each dynamic array in the higher 16 bits
    of __data_loc_foo, while the offset is in lower 16 bits.
========

And I just double checked it to confirm that the bug has been fixed.

