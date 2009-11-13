Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZKMPhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZKMPhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZKMPhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:37:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZKMPhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:37:46 -0500
Date: Fri, 13 Nov 2009 10:37:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 14/16] blkio: Idle on a group for some time on
	rotational media
Message-ID: <20091113153701.GE17076@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com> <1258068756-10766-15-git-send-email-vgoyal@redhat.com> <4e5e476b0911130258v7b81902dlfcc298c72f2de63a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911130258v7b81902dlfcc298c72f2de63a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 11:58:53AM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o If a group is not continuously backlogged, then it will be deleted from
> >  service tree and loose it share. For example, if a single random seeky
> >  reader or a single sequential reader is running in group.
> >
> Without groups, a single sequential reader would already have its 10ms
> idle slice, and a single random reader on the noidle service tree
> would have its 2ms idle, before switching to a new workload. Were
> those removed in the previous patches (and this patches re-enable
> them), or this introduces an additional idle between groups?
> 

Previous patches were based on 2.6.32-rc5 did not have the concept of idling
on no-idle group.

Group idling can be thought of an additional idling if group is empty and
and for some reason CFQ did not decide to idle on the queue (because slice
has expired). Even if cfqq slice has expired, we want to wait a bit to
make sure that this group gets backlogged and does not get deleted from
service tree so that it continues to get its fair share.

It helps in following circumstances. I have got a NCQ enabled rotational
disk which roughly does 90MB/s for buffered reads. If I launch two
sequential readers in two group of weight 400 and 200 and first group
should get double the disk time of second group. But after every slice
expiry the group gets deleted and looses share. Hence this extra idle on
group helps (if we already did not decide to idle on queue).

Having said that, I understand that idling can hurt in total throughput
if there is a NCQ enabled fast storage array. But it does not necessarily
hurt if there is a single NCQ enabled rotational disk. So as we move along
we need to figure out a way when to idle to achieve fairness and where we
let the fairness go becuase it hurts too much.
 
That's the reason I introduced the "group_idle" tunable so that one can
disable group_idle manually. This will also help us analyze when exactly
does it make sense to wait for slow groups to catch up or when it does
not.

So in summary, group_idling is an extra idle period we wait on group if
it is empty and we did not decide to idle on the cfqq. This is an effort
to make the group backlogged again so that it does not get deleted from
service tree and does not loose its share. This idling is disabled on
NCQ SSDs. Now only case left is fast storage arrays with rotational disk
and we need to figure out when to idle and when not to. Currently CFQ
seems to be idling on even fast storage array for sequential tasks and
this hurts if that sequential task is doing direct IO and not utilizing
the full capacity of the array.  

Thanks
Vivek

> > o One solution is to let group loose it share if it is not backlogged and
> >  other solution is to wait a bit for the slow group so that it can get its
> >  time slice. This patch implements waiting for a group to wait a bit.
> >
> > o This waiting is disabled for NCQ SSDs.
> >
> > o This patch also intorduces the tunable "group_idle" which can enable/disable
> >  group idling manually.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Thanks,
> Corrado
