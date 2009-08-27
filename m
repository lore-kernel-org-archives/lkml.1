Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZH0Cut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZH0Cut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZH0Cut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:50:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZH0Cus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:50:48 -0400
Message-ID: <4A95F444.9040705@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 10:49:40 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +static void update_min_vdisktime(struct io_service_tree *st)
> +{
> +	u64 vdisktime;
> +
> +	if (st->active_entity)
> +		vdisktime = st->active_entity->vdisktime;
> +
> +	if (st->rb_leftmost) {
> +		struct io_entity *entity = rb_entry(st->rb_leftmost,
> +						struct io_entity, rb_node);
> +
> +		if (!st->active_entity)
> +			vdisktime = entity->vdisktime;
> +		else
> +			vdisktime = min_vdisktime(vdisktime, entity->vdisktime);
> +	}
> +
> +	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
> +}

block/elevator-fq.c: In function ‘elv_ioq_slice_expired’:
block/elevator-fq.c:132: warning: ‘vdisktime’ may be used uninitialized in this function
LD      block/built-in.o

We'd better initialize vdisktime at first.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d04e925..a4161c2 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -131,6 +131,8 @@ static void update_min_vdisktime(struct io_service_tree *st)
 {
 	u64 vdisktime;
 
+	vdisktime = st->min_vdisktime;
+
 	if (st->active_entity)
 		vdisktime = st->active_entity->vdisktime;
 
-- 
1.5.4.rc3

