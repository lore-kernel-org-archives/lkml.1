Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZLJDqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZLJDqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbZLJDqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759502AbZLJDqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:46:31 -0500
Date: Wed, 9 Dec 2009 22:44:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com
Subject: Re: Block IO Controller V4
Message-ID: <20091210034427.GA4325@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com> <20091130160024.GD11670@redhat.com> <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com> <1259618433.2701.31.camel@cail> <20091130225640.GO11670@redhat.com> <1260285468.6686.12.camel@cail> <20091208163259.GD28615@redhat.com> <1260295541.6686.37.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260295541.6686.37.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 01:05:41PM -0500, Alan D. Brunelle wrote:

[..]
> > Thanks Alan. Whenever you run your tests again, it would be better to run
> > it against Jens's for-2.6.33 branch as Jens has merged block IO controller
> > patches.
> 
> Will do another set of runs w/ the straight branch.
> 
> > 
> > > I did both synchronous and asynchronous runs, direct I/Os in both case,
> > > random and sequential, with reads, writes and 80%/20% read/write cases.
> > > The results are in throughput (as reported by fio). The first table
> > > shows overall test results, the other tables show breakdowns per cgroup
> > > (disk).
> > 
> > What is asynchronous direct sequential read? Reads done through libaio?
> 
> Yep - An asynchronous run would have fio job files like:
> 
> [global]
> size=8g
> overwrite=0

Alan, can you try to run with overwrite=1. IIUC, overwrite=1, will first
layout the files on disk for write operations and then start IO. This
should give us much better results with ext3 as interference/seriliazation
introduced by kjournald comes down.

> runtime=120
> ioengine=libaio
> iodepth=128
> iodepth_low=128
> iodepth_batch=128
> iodepth_batch_complete=32
> direct=1
> bs=4k
> readwrite=randread
> [/mnt/sda/data.0]
> filename=/mnt/sda/data.0

I am also migrating my scripts to latest fio. Will also do some async
testing using libaio and report the results.

> 
> The equivalent synchronous run would be:
> 
> [global]
> size=8g
> overwrite=0
> runtime=120
> ioengine=sync
> direct=1
> bs=4k
> readwrite=randread
> [/mnt/sda/data.0]
> filename=/mnt/sda/data.0
> 
> ~                         
> > 
> > Few thoughts/questions inline.
> > 
> > > 
> > > Regards,
> > > Alan
> > > 
> > 
> > I am assuming that purpose of following table is to see what is the
> > overhead of IO controller patches. If yes, this looks more or less
> > good except there is slight dip in as seq rd case.
> > 
> > > ---- ---- - --------- --------- --------- --------- --------- ---------
> > > Mode RdWr N  as,base  as,i1,s8  as,i1,s0   sy,base  sy,i1,s8  sy,i1,s0
> > > ---- ---- - --------- --------- --------- --------- --------- ---------
> > > rnd  rd   2      39.7      39.1      43.7      20.5      20.5      20.4
> > > rnd  rd   4      33.9      33.3      41.2      28.5      28.5      28.5
> > > rnd  rd   8      23.7      25.0      36.7      34.4      34.5      34.6
> > > 
> > 
> > slice_idle=0 improves throughput for "as" case. That's interesting.
> > Especially in case of 8 random readers running. Well that should be a
> > general CFQ property and not effect of group IO control.
> > 
> > I am not sure, why did you not capture base with slice_idle=0 mode so that
> > apple vs apple comaprison could be done.
> 
> Could add that...will add that...

I think at this point of time slice_idle=0 results are not very interesting.
You can ignore it both for with ioc patches and without ioc patches.

[..]
> > > ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> > > Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
> > > ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
> > > as,i1,s8    rnd  rd   2  12.7  26.3
> > > as,i1,s8    rnd  rd   4   1.2   3.7  12.2  16.3
> > > as,i1,s8    rnd  rd   8   0.5   0.8   1.2   1.7   2.1   3.5   6.7   8.4
> > > 
> > 
> > This looks more or less good except the fact that last two groups seem to
> > have got much more share of disk. In general it would be nice to also
> > capture the disk time also apart from BW.
> 
> What specifically are you looking for? Any other fields from the fio
> output? I have all that data & could reprocess it easily enough. 

I want disk time also and that is in cgroup dir. Read blkio.time file
after the test has run for all the cgroups. 

[..]
> > In summary, async results look little bit off and need investigation. Can
> > you please send me one sample async fio script.
> 
> The fio file I included above should help, right? If not, let me know,
> I'll send you all the command files...

I think this is good enough. I will do testing with your fio command file.

Thanks
Vivek
