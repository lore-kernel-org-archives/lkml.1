Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZESDjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZESDjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 23:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZESDje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 23:39:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:29146 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbZESDjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 23:39:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,212,1241420400"; 
   d="scan'208";a="516776874"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Tue, 19 May 2009 11:38:26 +0800
Subject: RE: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Thread-Topic: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Thread-Index: AcnYLQhPPHP3gCHbSuu+Uk6FCmsAlAABFEZw
Message-ID: <4D05DB80B95B23498C72C700BD6C2E0B2EF6E29A@pdsmsx502.ccr.corp.intel.com>
References: <20090513120729.5885.A69D9226@jp.fujitsu.com>
 <20090518034907.GF5869@localhost>
 <20090519102634.4EB4.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090519102634.4EB4.A69D9226@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4J3dwlL023566

>>-----Original Message-----
>>From: KOSAKI Motohiro [mailto:kosaki.motohiro@jp.fujitsu.com]
>>Sent: 2009Äê5ÔÂ19ÈÕ 10:54
>>To: Wu, Fengguang
>>Cc: kosaki.motohiro@jp.fujitsu.com; LKML; linux-mm; Andrew Morton; Rik van
>>Riel; Christoph Lameter; Zhang, Yanmin
>>Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
>>
>>> On Wed, May 13, 2009 at 12:08:12PM +0900, KOSAKI Motohiro wrote:
>>> > Subject: [PATCH] zone_reclaim_mode is always 0 by default
>>> >
>>> > Current linux policy is, if the machine has large remote node distance,
>>> >  zone_reclaim_mode is enabled by default because we've be able to assume

>>
>>ok, I would explain zone reclaim design and performance tendency.
>>
>>Firstly, we can make classification of linux eco system, roughly.
>> - HPC
>> - high-end server
>> - volume server
>> - desktop
>> - embedded
>>
>>it is separated by typical workload mainly.
>>
>>Secondly, zone_reclaim mean "I strongly dislike remote node access than
>>disk access".
>>it is very fitting on HPC workload. it because
>>  - HPC workload typically make the number of the same as cpus of processess
>>(or thread).
>>    IOW, the workload typically use memory equally each node.
>>  - HPC workload is typically CPU bounded job. CPU migration is rare.
>>  - HPC workload is typically long lived. (possible >1 year)
>>    IOW, remote node allocation makes _very_ _very_ much remote node access.
>>
>>but zone_reclaim don't fit typical server workload.
>>  - server workload often make thread pool and some thread is sleeping until
>>    a request receved.
>>    IOW, when thread waking-up, the thread might move another cpu.
>>    node distance tendency don't make sense on weak cpu locality workload.
>>
>>Plus, disk-cache is the file-server's identity. we shouldn't think it's not
>>important.
>>Plus, DB software can consume almost system memory and (In general) RDB data
>>makes
>>harder to split equally as hpc.
>>
>>desktop workload is special. desktop peopole can run various workload beyond
>>our assumption. So, we shouldn't have any workload assumption to desktop
>>people.
>>However, AFAIK almost desktop software use memory as UMA.
>>
>>we don't need to care embedded. it is typically UMA.
>>
>>
>>IOW, the benefit of zone reclaim depend on "strong cpu locality" and
>>"workload is cpu bounded" and "thead is long lived".
>>but many workload don't fill above requirement. IOW, zone reclaim is
>>workload depended feature (as Wu said).
>>
>>
>>In general, the feature of workload depended don't fit default option.
>>we can't know end-user run what workload anyway.
>>
>>Fortunately (or Unfortunately), typical workload and machine size had
>>significant mutuality.
>>Thus, the current default setting calculation had worked well in past days.
[YM] Your analysis is clear and deep.

>>
>>Now, it was breaked. What should we do?
>>Yanmin, We know 99% linux people use intel cpu and you are one of
>>most hard repeated testing
[YM] It's very easy to reproduce them on my machines. :) Sometimes, because the 
issues only exist on machines with lots of cpu while other community developers
have no such environments. 

 guy in lkml and you have much test.
>>May I ask your tested machine and benchmark?
[YM] Usually I started lots of benchmark testing against the latest kernel, but 
as for this issue, it's reported by a customer firstly. The customer runs apache
on Nehalem machines to access lots of files. So the issue is an example of file 
server.

BTW, I found many test cases of fio have big drop after I upgraded BIOS of one 
Nehalem machine. By checking vmstat data, I found almost a half memory is always free. It's also related to zone_reclaim_mode because new BIOS changes the node
distance to a large value. I use numactl --interleave=all to walkaround the problem temporarily.

I have no HPC environment.

>>
>>if zone_reclaim=0 tendency workload is much than zone_reclaim=1 tendency
>>workload,
>> we can drop our afraid and we would prioritize your opinion, of cource.
So it seems only file servers have the issue currently.

Yanmin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
