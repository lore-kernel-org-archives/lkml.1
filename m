Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZEXOSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZEXOSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZEXOR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:17:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46612 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZEXOR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:17:56 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1243109591-21611-5-git-send-email-ebiederm@xmission.com>
	<ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com>
	<1243169978.3502.7.camel@poy>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 24 May 2009 07:17:47 -0700
In-Reply-To: <1243169978.3502.7.camel@poy> (Kay Sievers's message of "Sun\, 24 May 2009 14\:59\:38 +0200")
Message-ID: <m1bppid1pw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2480]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Sat, 2009-05-23 at 23:27 +0200, Kay Sievers wrote:
>> On Sat, May 23, 2009 at 22:13, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > From: Eric W. Biederman <ebiederm@xmission.com>
>> >
>> > I have looked and I have not found a single legitimate case today where
>> > we remove sysfs directories with anything in them.  The only case I have
>> > found to date was a bug.  It was a problem of ownership.  The files in
>> > the directory where not owned by the directory itself.   Leaving open
>> > the potential for double deletion of the directory contents.
>> >
>> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> 
>> Sounds good to me. We should try that, and see if there was any valid
>> use case we didn't think of, and if not, it's good to do what this
>> patch does.
>
> I get a bunch of warnings here. The question is if the users should be
> fixed, the warning removed, and/or the auto-deletion added back?

Thanks for finding these.  I was afraid I hadn't look far enough.
To see if non-empty directories were a problem.

Most of these look like attributes, for which the non-empty directory
removal was correct.  Although I am puzzled by why we missed them.

host4/target4:0:0 worries me.  I don't have my head wrapped around
what that is yet.  But is looks like is a directory (which we currently
do not handle correctly), and even more it looks like that is quite
possibly two kobjects in a parent/child situation where the child
was not removed when the child was.

It definitely warrants more investigation.

....

Let's make the plan to investigate these, and see how hard it would be
to actually remove these with the current device/sysfs infrastructure.

Fixing the users and adding back auto-deletion are the only two real options.

I expect we have uncovered at least one more real bug.  So I am inclined
to make the policy that we fix the users.

> I've added:
>   -       WARN(dir_sd->s_dir.children,
>   -               KERN_WARNING "sysfs: removing non-empty dir: %s\n",
>   -               dir_sd->s_name);
>   +       if (dir_sd->s_dir.children) {
>   +               struct sysfs_dirent *sd;
>   +
>   +               WARN(dir_sd->s_dir.children,
>   +                       KERN_WARNING "sysfs: removing non-empty dir: %s\n",
>   +                       dir_sd->s_name);
>   +               sd = dir_sd->s_dir.children;
>   +               while (sd) {
>   +                       printk(KERN_WARNING "%s/%s\n", dir_sd->s_name, sd->s_name);
>   +                       sd = sd->s_sibling;
>   +               }
>   +       }
>
> And get non-empty directories from CPU, SCSI, firmware_class, sound, block:
>   sysfs: removing non-empty dir: state0
>   state0/name
>   state0/desc
>   state0/latency
>   state0/power
>   state0/usage
>   state0/time
>
>   sysfs: removing non-empty dir: 0000:03:00.0
>   0000:03:00.0/data
>   0000:03:00.0/loading
>
>   sysfs: removing non-empty dir: iosched
>   iosched/quantum
>   iosched/fifo_expire_sync
>   iosched/fifo_expire_async
>   iosched/back_seek_max
>   iosched/back_seek_penalty
>   iosched/slice_sync
>   iosched/slice_async
>   iosched/slice_async_rq
>   iosched/slice_idle
>
>   sysfs: removing non-empty dir: queue
>   queue/nr_requests
>   queue/read_ahead_kb
>   queue/max_hw_sectors_kb
>   queue/max_sectors_kb
>   queue/scheduler
>   queue/hw_sector_size
>   queue/rotational
>   queue/nomerges
>   queue/rq_affinity
>   queue/iostats
>
>   sysfs: removing non-empty dir: 4:0:0:0
>   4:0:0:0/queue_depth
>   4:0:0:0/queue_type
>   4:0:0:0/max_sectors
>
>   sysfs: removing non-empty dir: host4
>   host4/target4:0:0
>
>   sysfs: removing non-empty dir: pcmC1D0c
>   pcmC1D0c/pcm_class
>
>   sysfs: removing non-empty dir: card1
>   card1/id
>   card1/number

Eric
