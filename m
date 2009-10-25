Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZJYMXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZJYMXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 08:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZJYMXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 08:23:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbZJYMXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 08:23:21 -0400
Message-ID: <4AE44335.8010804@redhat.com>
Date: Sun, 25 Oct 2009 14:23:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] User return notifiers / just-in-time MSR switching
 for KVM
References: <1253105134-8862-1-git-send-email-avi@redhat.com>
In-Reply-To: <1253105134-8862-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2009 03:45 PM, Avi Kivity wrote:
> The various x86 syscall related MSRs (MSR_LSTAR and friends, EFER when SCE
> needs to be updated) are fairly expensive to read or write.  Since different
> operating systems can set different values for these MSRs, KVM needs to reload
> them when switching to a different guest or to the host.
>
> Switching on every guest entry/exit is too expensive, so KVM reloads on
> guest preemption, which is a lot rarer.  Even so, preemption based reload
> is suboptimal:
>
> - if we're switching to a kernel thread and back, there's no need to reload
>    the MSRs.  Examples of kernel threads we're likely to switch to are:
>
>    - the idle task
>    - a threaded interrupt handler
>    - a kernel-mode virtio server (vhost-net)
>
> - if we're switching to a guest running the same OS, the MSRs will have the
>    same values and there's no need to reload them
>
> - if the guest and host run the same OS, again the MSRs need not be reloaded.
>
> This patchset implements just-in-time reloads to defer them to the last
> possible instant.  When we do reload, we check whether the values have in
> fact changed and reload conditionally.
>
> For the just-in-time reloads the first patch implements "user return
> notifiers", a callback invoked just before return to userspace.  This has
> been written so that there is no code impact if KVM is not configured, and
> no runtime impact if KVM is not running.
>
> The patchset improves guest/idle/guest switches by about 2000 cycles.
>
>    

I've applied this to kvm.git master.

-- 
error compiling committee.c: too many arguments to function

