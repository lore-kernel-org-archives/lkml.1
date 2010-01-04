Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371Ab0ADKPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0ADKPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353Ab0ADKPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:15:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:18447 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0ADKPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:15:05 -0500
MIME-Version: 1.0
In-Reply-To: <20100104003612.GF16187@balbir.in.ibm.com>
References: <cover.1262186097.git.kirill@shutemov.name>
	 <20100104003612.GF16187@balbir.in.ibm.com>
Date: Mon, 4 Jan 2010 12:15:02 +0200
Message-ID: <cc557aab1001040215r1bdaaed0n2fe461e5ff396cdb@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] cgroup notifications API and memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: balbir@linux.vnet.ibm.com
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 2:36 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Kirill A. Shutemov <kirill@shutemov.name> [2009-12-30 17:57:55]:
>
>> This patchset introduces eventfd-based API for notifications in cgroups and
>> implements memory notifications on top of it.
>>
>> It uses statistics in memory controler to track memory usage.
>>
>> Output of time(1) on building kernel on tmpfs:
>>
>> Root cgroup before changes:
>>       make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
>> Non-root cgroup before changes:
>>       make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
>> Root cgroup after changes (0 thresholds):
>>       make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
>> Non-root cgroup after changes (0 thresholds):
>>       make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
>> Root cgroup after changes (1 thresholds, never crossed):
>>       make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
>> Non-root cgroup after changes (1 thresholds, never crossed):
>>       make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total
>>
>> Any comments?
>
> Hi,
>
> I just saw that the notification work for me using the tool you
> supplied. One strange thing was that I got notified even though
> the amount of data I was using was reducing, so I hit the notification
> two ways
>
>        +------------+-----------
>                    1G
>                ----> (got notified on increase)
>                <---- (got notified on decrease)
>
> I am not against the behaviour, but it can be confusing unless
> clarified with the event.

IIUC, you've got two events. One on crossing the threshold up and
one on crossing it down. It's Ok.

By design, notification means that the threshold probably crossed
(it can be crossed twice -- up and down) or the cgroup was removed.
To understand what really happen you need to check if the cgroup
exists and read current usage of the resource.
