Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZKMKqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZKMKqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZKMKqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:46:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38657 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbZKMKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uUPMbhrkd2mY2zXCX0plgPyo3ItHHkMutDnCXAVZD5iWFeEU6dms6ZoMRE8mWABDxg
         YBEAseaL3fjaJXz7w6WPtK+K6bNLo/GH6v8ogoS6LVqscXVTKQF23dnwHPOdwpHCXaGR
         OP5IDoxcyVgfRG/Cujokk4pnCSJgx8x2Zh4qk=
MIME-Version: 1.0
In-Reply-To: <1258068756-10766-6-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
	 <1258068756-10766-6-git-send-email-vgoyal@redhat.com>
Date: Fri, 13 Nov 2009 11:46:49 +0100
Message-ID: <4e5e476b0911130246m372eb8e8x7b98f13278515a95@mail.gmail.com>
Subject: Re: [PATCH 05/16] blkio: Implement per cfq group latency target and 
	busy queue avg
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nADAl216003344

On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:>  static inline void> @@ -441,10 +445,13 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)>        if (cfqd->cfq_latency) {>                /* interested queues (we consider only the ones with the same>                 * priority class) */This comment needs to be updated> -               unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));> +               unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,> +                                               cfq_class_rt(cfqq));>                unsigned sync_slice = cfqd->cfq_slice[1];>                unsigned expect_latency = sync_slice * iq;> -               if (expect_latency > cfq_target_latency) {> +               unsigned group_target_lat = cfq_target_latency/cfqd->nr_groups;
I'm not sure that we should divide the target latency evenly among groups.Groups with different weights will have different percentage of timein each 300ms round, so probably we should consider it here.
> +> +               if (expect_latency > group_target_lat) {>                        unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;>                        /* scale low_slice according to IO priority>                         * and sync vs async */> @@ -452,7 +459,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)>                                min(slice, base_low_slice * slice / sync_slice);>                        /* the adapted slice value is scaled to fit all iqs>                         * into the target latency */> -                       slice = max(slice * cfq_target_latency / expect_latency,> +                       slice = max(slice * group_target_lat / expect_latency,>                                    low_slice);>                }>        }
Thanks,Corrado���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
