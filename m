Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZANTuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZANTuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZANTuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:50:46 -0500
Received: from relay1.sgi.com ([192.48.179.29]:34169 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752436AbZANTup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:50:45 -0500
Message-ID: <496E4211.6040503@sgi.com>
Date: Wed, 14 Jan 2009 11:50:41 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com> <20090114111949.GO2913@elte.hu>
In-Reply-To: <20090114111949.GO2913@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Yinghai Lu wrote:
>>> Impact: save RAM with large NR_CPUS, get smaller nr_irqs
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Built and tested on an 8-core intel system.  Great reduction
>> in NR_IRQS:
>>
>> 	[    0.000000] NR_IRQS:33024 nr_irqs:320
>>
>> Thanks Yinghai!
>>
>> Ingo - shall I push this one as well?  (If not, then you
>> can add my:
>>
>> 	Acked-by: Mike Travis <travis@sgi.com>
> 
> yes, please pick it up and i can pull it from you. Please also add a 
> longer changelog about the precise effects and perhaps some estimations 
> about what the before and after situation is, and perhaps also some bits 
> about how it affects normal Linux users as well.
> 
> 	Ingo

Hi Ingo,

Just so I don't screw this thing up, exactly what am I to 'pull' to fix
this error (listed at the end of this command sequence)?

Thanks,
Mike

    mkdir linux-2.6-cpus4096-for-ingo
    cd linux-2.6-cpus4096-for-ingo
    git-init-db
    git-remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    git-remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
    git-remote add my-cpus4096 git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git
    git-remote add push-cpus4096 ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git
    git-config --add remote.push-cpus4096.skipDefaultUpdate true
    git-remote update

    git-checkout -b edit-commits my-cpus4096/master
    git-log             # insure the commit is the last one
    git commit --amend

<edit changelog>

    git-push push-cpus4096 edit-commits:master

travis@master.kernel.org's password:
To ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git
 ! [rejected]        edit-commits -> master (non-fast forward)
error: failed to push some refs to 'ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git'

    git-push -f push-cpus4096 edit-commits:master

travis@master.kernel.org's password:
Counting objects: 31, done.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (16/16), 1.97 KiB, done.
Total 16 (delta 14), reused 12 (delta 11)
error: denying non-fast forward refs/heads/master (you should pull first)
To ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git
 ! [remote rejected] edit-commits -> master (non-fast forward)
error: failed to push some refs to 'ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git'

=============================================================
Here is the altered commit message:

commit 939a9fc9e5f6fda4f797dea209fa881ce1368e37
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Mon Jan 12 17:39:24 2009 -0800

    x86: arch_probe_nr_irqs

    Impact: save RAM with large NR_CPUS, get smaller nr_irqs

    Estimating NR_IRQS based on NR_CPUS results in excessive memory used for
    items like arrays sized by NR_IRQS.  This patch adds an arch specific
    'probe' or discovery routine to calculate the minimum number of slots
    required to handle the number of irqs on the running system.  The result
    is placed in the 'nr_irqs' variable.

    As an example, a system configured with NR_CPUS=4096 that has in fact
    8 cpu cores, results in a reduction from 33024 to 320 for the number of
    irqs required.  This is shown in a system log message:

        NR_IRQS:33024 nr_irqs:320

    Of course, this requires that other code dynamically allocate their irq
    arrays using nr_irqs instead of NR_IRQS.  An example is in early_irq_init()
    when CONFIG_SPARSE_IRQ is true.

    Currently, the only arch that has this probe function is x86.  A default
    weak arch_probe_nr_irqs function is placed in kernel/softirq.c, to avoid
    a problem with some gcc's that do not handle weak functions correctly,
    if they are in the same file as the reference.

    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Mike Travis <travis@sgi.com>




