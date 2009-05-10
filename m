Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZEJJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZEJJgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 05:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbZEJJgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 05:36:22 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:56440 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbZEJJgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 05:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Mn5kNvj8Bo1k+P4xxxHacdzQmGdhQAu00I6DphAzPtNJawNiDTQdSiUin7b9sDeLmJ
         yBVzJrvxP3pLgk8tvMVKblW44s91P+PhZSVu80glAQPhRqdBoB6lZxdPreGds4QVT+nW
         x0elR4PxGpz2h9nLXiEQpRuRMQ36BlzScEXrA=
MIME-Version: 1.0
In-Reply-To: <1241946446.6317.42.camel@laptop>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost>
	 <20090507151039.GA2413@cmpxchg.org>
	 <20090507134410.0618b308.akpm@linux-foundation.org>
	 <20090508081608.GA25117@localhost>
	 <20090508125859.210a2a25.akpm@linux-foundation.org>
	 <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <1241946446.6317.42.camel@laptop>
Date: Sun, 10 May 2009 18:36:19 +0900
X-Google-Sender-Auth: a78d85e703672d0b
Message-ID: <2f11576a0905100236u15d45f7fm32d470776659cfec@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       linux-mm@kvack.org, elladan@eskimo.com, npiggin@suse.de,
       cl@linux-foundation.org, minchan.kim@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How about this?
>> if priority < DEF_PRIORITY-2, aggressive lumpy reclaim in
>> shrink_inactive_list() already
>> reclaim the active page forcely.
>> then, this patch don't change kernel reclaim policy.
>>
>> anyway, user process non-changable preventing "nice my process up
>> hack" seems makes sense to me.
>>
>> test result:
>>
>> echo 100 > /proc/sys/vm/dirty_ratio
>> echo 100 > /proc/sys/vm/dirty_background_ratio
>> run modified qsbench (use mmap(PROT_EXEC) instead malloc)
>>
>>            active2active vs active2inactive ratio
>> before    5:5
>> after       1:9
>>
>> please don't ask performance number. I haven't reproduce Wu's patch
>> improvemnt ;)
>>
>> Wu, What do you think?
>
> I don't think this is desirable, like Andrew already said, there's tons
> of ways to defeat any of this and we've so far always priorized mappings
> over !mappings. Limiting this to only PROT_EXEC mappings is already less
> than it used to be.

I don't oppose this policy. PROT_EXEC seems good viewpoint.
The problem is PROT_EXEC'ed page isn't gurantee rarely.

if all pages claim "Hey, I'm higher priority page, please don't
reclaim me", end-user get
suck result easily.

before 2.6.27 kernel have similar problems. many mapped page cause bad latency
easily. I don't want reproduce this.
