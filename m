Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZEXM7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZEXM7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZEXM7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:59:40 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:40938 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZEXM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:59:39 -0400
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
 directories.
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
In-Reply-To: <ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	 <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
	 <ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 24 May 2009 14:59:38 +0200
Message-Id: <1243169978.3502.7.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 23:27 +0200, Kay Sievers wrote:
> On Sat, May 23, 2009 at 22:13, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > From: Eric W. Biederman <ebiederm@xmission.com>
> >
> > I have looked and I have not found a single legitimate case today where
> > we remove sysfs directories with anything in them.  The only case I have
> > found to date was a bug.  It was a problem of ownership.  The files in
> > the directory where not owned by the directory itself.   Leaving open
> > the potential for double deletion of the directory contents.
> >
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> Sounds good to me. We should try that, and see if there was any valid
> use case we didn't think of, and if not, it's good to do what this
> patch does.

I get a bunch of warnings here. The question is if the users should be
fixed, the warning removed, and/or the auto-deletion added back?

I've added:
  -       WARN(dir_sd->s_dir.children,
  -               KERN_WARNING "sysfs: removing non-empty dir: %s\n",
  -               dir_sd->s_name);
  +       if (dir_sd->s_dir.children) {
  +               struct sysfs_dirent *sd;
  +
  +               WARN(dir_sd->s_dir.children,
  +                       KERN_WARNING "sysfs: removing non-empty dir: %s\n",
  +                       dir_sd->s_name);
  +               sd = dir_sd->s_dir.children;
  +               while (sd) {
  +                       printk(KERN_WARNING "%s/%s\n", dir_sd->s_name, sd->s_name);
  +                       sd = sd->s_sibling;
  +               }
  +       }

And get non-empty directories from CPU, SCSI, firmware_class, sound, block:
  sysfs: removing non-empty dir: state0
  state0/name
  state0/desc
  state0/latency
  state0/power
  state0/usage
  state0/time

  sysfs: removing non-empty dir: 0000:03:00.0
  0000:03:00.0/data
  0000:03:00.0/loading

  sysfs: removing non-empty dir: iosched
  iosched/quantum
  iosched/fifo_expire_sync
  iosched/fifo_expire_async
  iosched/back_seek_max
  iosched/back_seek_penalty
  iosched/slice_sync
  iosched/slice_async
  iosched/slice_async_rq
  iosched/slice_idle

  sysfs: removing non-empty dir: queue
  queue/nr_requests
  queue/read_ahead_kb
  queue/max_hw_sectors_kb
  queue/max_sectors_kb
  queue/scheduler
  queue/hw_sector_size
  queue/rotational
  queue/nomerges
  queue/rq_affinity
  queue/iostats

  sysfs: removing non-empty dir: 4:0:0:0
  4:0:0:0/queue_depth
  4:0:0:0/queue_type
  4:0:0:0/max_sectors

  sysfs: removing non-empty dir: host4
  host4/target4:0:0

  sysfs: removing non-empty dir: pcmC1D0c
  pcmC1D0c/pcm_class

  sysfs: removing non-empty dir: card1
  card1/id
  card1/number


Thanks,
Kay

