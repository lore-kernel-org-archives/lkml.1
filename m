Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZIHNbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZIHNbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZIHNbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:31:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47763 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZIHNbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:31:10 -0400
Message-ID: <4AA65CFE.50402@us.ibm.com>
Date: Tue, 08 Sep 2009 09:32:46 -0400
From: Beth Kon <eak@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: rostedt@goodmis.org, avi@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM
 not in kernel
References: <3850.1252332427@turing-police.cc.vt.edu>
In-Reply-To: <3850.1252332427@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> Symptoms: Dell Latitude D820 either hangs at very early boot (before
> any output, not even penguins), or (apparently) triple-faults into an
> immediate reboot.  linux-2.6.31-rc7-mmotm0827 works fine, so whatever the
> real issue is, it hit linux-next between then and when Andrew pulled for
> -0902.  Since I was feeling lazy, I told 'git bisect' that 2.6.31-rc7 was
> good and HEAD was bad.
>
> 'git bisect' against a linux-next pulled Friday evening finds this:
>
> % git bisect good
> 92e1f62fb1f5d614ca9ad2d5f99f7b41da53d13b is first bad commit
> commit 92e1f62fb1f5d614ca9ad2d5f99f7b41da53d13b
> Author: Beth Kon <eak@us.ibm.com>
> Date:   Tue Jul 7 11:50:38 2009 -0400
>
>     KVM: PIT support for HPET legacy mode
>     
>     When kvm is in hpet_legacy_mode, the hpet is providing the timer
>     interrupt and the pit should not be. So in legacy mode, the pit timer
>     is destroyed, but the *state* of the pit is maintained. So if kvm or
>     the guest tries to modify the state of the pit, this modification is
>     accepted, *except* that the timer isn't actually started. When we exit
>     hpet_legacy_mode, the current state of the pit (which is up to date
>     since we've been accepting modifications) is used to restart the pit
>     timer.
>     
>     The saved_mode code in kvm_pit_load_count temporarily changes mode to
>     0xff in order to destroy the timer, but then restores the actual
>     value, again maintaining "current" state of the pit for possible later
>     reenablement.
>     
>     [avi: add some reserved storage in the ioctl; make SET_PIT2 IOW]
>     
>     Signed-off-by: Beth Kon <eak@us.ibm.com>
>     Signed-off-by: Avi Kivity <avi@redhat.com>
>
> :040000 040000 9771592c8df5806f5da4e3fc5def70e6b046b0b7 1e71e65dad0e013cb434391f1aea3213ddc89617 M      arch
> :040000 040000 58b808be039743c69f34eba373b078b84beada13 b681e2afecd12a2c75cd32d9d56fc3297d11f0e2 M      include
>
> % git bisect log
> git bisect start
> ## good: [422bef879e84104fee6dc68ded0e371dbeb5f88e] Linux 2.6.31-rc7
> git bisect good 422bef879e84104fee6dc68ded0e371dbeb5f88e
> ## bad: [b174f87b707ffa866de88a3d96e702a48f834930] Add linux-next specific files for 20090904
> git bisect bad b174f87b707ffa866de88a3d96e702a48f834930
> ## bad: [7b0f9406ef7770bf37aacf98ba59dcccd12deae7] Merge commit 'dlm/next'
> git bisect bad 7b0f9406ef7770bf37aacf98ba59dcccd12deae7
> ## bad: [2d55d81d9d2ead8e1ba97a3e000efa3796193805] KVM: MMU: shadow support for 1gb pages
> git bisect bad 2d55d81d9d2ead8e1ba97a3e000efa3796193805
> ## good: [c3071eae069e407d067a98c22ab2d1973b68785b] KVM: MMU: unify slots_lock usage
> git bisect good c3071eae069e407d067a98c22ab2d1973b68785b
> ## good: [93bde9fd0d39f18d1bdb0f0b7dbea763277fc83a] KVM: s390: Fix memory leak of vcpu->run
> git bisect good 93bde9fd0d39f18d1bdb0f0b7dbea763277fc83a
> ## good: [ed13abffa3568d222fda9fc4b1ddebccbafadd2e] KVM: Replace kvmclock open-coded get_cpu_var() with the real thing
> git bisect good ed13abffa3568d222fda9fc4b1ddebccbafadd2e
> ## good: [e85dd2c90b6f523f6c014959313b4a8b7bf09ba4] KVM: Use pointer to vcpu instead of vcpu_id in timer code.
> git bisect good e85dd2c90b6f523f6c014959313b4a8b7bf09ba4
> ## good: [a2e3bb114b6afc79b2e8771ede074e9aabbe11ee] KVM: document locking for kvm_io_device_ops
> git bisect good a2e3bb114b6afc79b2e8771ede074e9aabbe11ee
> ## good: [be5ef0d26ae68aa6825630cdfc2d0f93a36e3ac1] KVM: No need to kick cpu if not in a guest mode.
> git bisect good be5ef0d26ae68aa6825630cdfc2d0f93a36e3ac1
> ## bad: [398eea630db0dd3f1e97294b74538521800a6ba8] KVM: x86: use get_desc_base() and get_desc_limit()
> git bisect bad 398eea630db0dd3f1e97294b74538521800a6ba8
> ## bad: [988bdebfe40ab15a38a788ef9fda0b68a698121b] KVM: Move kvm_cpu_get_interrupt() declaration to x86 code
> git bisect bad 988bdebfe40ab15a38a788ef9fda0b68a698121b
> ## bad: [f7bc646cae299e60c982cb4646915f9763fcea09] KVM: make io_bus interface more robust
> git bisect bad f7bc646cae299e60c982cb4646915f9763fcea09
> ## bad: [92e1f62fb1f5d614ca9ad2d5f99f7b41da53d13b] KVM: PIT support for HPET legacy mode
> git bisect bad 92e1f62fb1f5d614ca9ad2d5f99f7b41da53d13b
> ## good: [ce0c990165e183d07cde7c8ed726c37c4f94ae5c] KVM: Always report x2apic as supported feature
> git bisect good ce0c990165e183d07cde7c8ed726c37c4f94ae5c
>
> Why this is weird (the first two are just my lack of git-foo):
>
> 1) During the bisect, the kernel version was jumping all over the place - as
> far back as 2.6.28-rc<mumble> even though I gave 31-rc7 as the start - right
> now, at the end of the bisect, it's sitting at 31-rc2.  Where does git get
> these versions from?
>
> 2) Probably related - git reports this patch as being done 2009-07-07, but
> it apparently got to linux-next between 08/27 and 09/03.  Is there any way
> to get git to tell when a revision went tree-to-tree?
>
> The truly weird:
>
> 3) no KVM in this kernel:
> % grep KVM .config
> CONFIG_HAVE_KVM=y
> ## CONFIG_KVM is not set
>   
Hi Vladis. I'm at a loss regarding my patch being the problem if it is 
really the case that CONFIG_KVM is not set.  Are you sure that is the 
config being used? My only other thought (assuming somehow CONFIG_KVM 
*is* set) is to be sure your repository also has 
b4eba884776b5ab77fef1febbd3203e54a66d0bd.
> 4) During the kernel build for the last few bisects, the *only* thing rebuilt
> besides things like version.o was kernel/trace/trace.o - there *is* tracing
> in this kernel.
>
> My best guess is that the flagged commit does something to a .h file that
> gives trace.c indigestion at system boot, but looking at the patch, damned
> if I know what it was...
>
> .config at the end of bisecting attached.
>   

