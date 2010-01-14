Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336Ab0ANLJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0ANLJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169Ab0ANLJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:09:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab0ANLJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:09:35 -0500
Date: Thu, 14 Jan 2010 06:09:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
	pending
Message-ID: <20100114110902.GA15559@redhat.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com> <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com> <20100113082322.GA24345@sli10-desk.sh.intel.com> <20100113111341.GB3087@redhat.com> <20100114034150.GA3922@sli10-desk.sh.intel.com> <4B4EAB39.1070301@cn.fujitsu.com> <20100114061731.GA23590@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114061731.GA23590@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 02:17:31PM +0800, Shaohua Li wrote:
> On Thu, Jan 14, 2010 at 01:27:21PM +0800, Gui Jianfeng wrote:
> > Shaohua Li wrote:
> > > On Wed, Jan 13, 2010 at 07:13:41PM +0800, Vivek Goyal wrote:
> > >> On Wed, Jan 13, 2010 at 04:23:22PM +0800, Shaohua Li wrote:
> > >>> On Wed, Jan 13, 2010 at 04:18:47PM +0800, Corrado Zoccolo wrote:
> > >>>> On Wed, Jan 13, 2010 at 8:44 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > >>>>> My SSD speed of direct write is about 80m/s, while I test page writeback,
> > >>>>> the speed can only go to 68m/s. Below patch fixes this.
> > >>>>> It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
> > >>>>> means a queue should idle because it's seekless sync queue or it's the last queue,
> > >>>>> which is to maintain service tree time slice. So it doesn't mean the
> > >>>>> last queue is always a sync queue. If the last queue is asyn queue,
> > >>>>> we definitely shouldn't stop dispatch requests because of pending async
> > >>>>> requests.
> > >>>> An other option is that cfq_should_idle returns false for async
> > >>>> queues, since cfq will never idle on them.
> > >>> I'm considering this option too, but it appears we need make async queue
> > >>> idle to maintain domain time slice.
> > >> IMHO, we don't have to wait on async write service tree. Generally aysnc
> > >> write queus contain many requests and they are not like reads where next
> > >> request is expected. So idling on aysnc write service tree is waste of
> > >> time and will lead to reduced throughput.
> > > I fully agree async queue doesn't need wait. I thought the purpose we add the last
> > > queue check in cfq_should_idle is we want a service tree or a group has dedicated
> > > slice, because before the service tree/group slice is expired, new queue can jump
> > > in and if we don't idle, the new queue can only run at next slice. Not sure if I
> > > understand the code correctly.
> > 
> > Hi Shaohua,
> > 
> > If a cfq queue is the last one in the io group, if we expire this cfqq immediately,
> > io group will be removed from service tree. When io group gets backlogged again, it
> > will be put at the end of service tree, so it loses its previous share. so we add
> > the last check here from the fairness point of view.
> ya, this is what I'm understanding. So we can't return false for async queue
> in cfq_should_idle if the queue is the last one of service tree.
> 

Yes cfq_should_idle() can check for async queue and return false.

Regarding group loosing fair share, currently all async queues are in root
group and not in individual groups, so this particular change should not
affect a lot. We will continue to idle on sync-idle and sync-noidle
service tree. Only async service tree is the exception.

Once we introduce per group async queue in future, we shall have to come
up with something else, if need be.

So keep this as a separate patch. I think in the presence of mixed
workload, (readers and buffered writers), it might give little performance
boost. We need to test it though.

Thanks
Vivek
