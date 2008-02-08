Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbYBHQEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbYBHQEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYBHQEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:04:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbYBHQEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:04:21 -0500
Date: Fri, 8 Feb 2008 11:04:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: why kexec insists on syncing with recent kernels?
Message-ID: <20080208160408.GB18782@redhat.com>
References: <47AB120A.1000600@wpkg.org> <20080207163752.GD11969@redhat.com> <47AB38E2.9050509@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB38E2.9050509@wpkg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 05:59:14PM +0100, Tomasz Chmielewski wrote:
> Vivek Goyal schrieb:
>> On Thu, Feb 07, 2008 at 03:13:30PM +0100, Tomasz Chmielewski wrote:
>>> According to kernel/kexec.c:
>>>
>>>  * kexec does not sync, or unmount filesystems so if you need
>>>  * that to happen you need to do that yourself.
>>>
>>>
>>
>> In latest kexec code I do see it syncing. But it does not unmount the
>> filesystems. So this comment looks like partially wrong.
>>
>>> I saw this was true with 2.6.18 kernel (i.e., it didn't sync), but kexec 
>>> syncs with recent kernels (I checked 2.6.23.14 and 2.6.24):
>>>
>>> # kexec -e
>>> md: stopping all md devices
>>> sd 2:0:0:0: [sdb] Synchronizing SCSI cache
>>
>> Which kexec-tools you are using? 
>
> # kexec -v
> kexec 1.101 released 15 February 2005
>
>
>> syncing is initiated by user space so changing kernel will not have
>> any effect (as long as user space is same). I think just that message
>> are spitted by kernel, so probably 2.6.18 did not spit any message and
>> 2.6.24 does.
>
> Yes and no.
> I just booted 2.6.24 on a diskless system (Mandriva) I normally use with 
> 2.6.18 kernel, did kexec -e... And it executed the kernel immediately, 
> without any syncing.
> On Debian, with the same 2.6.24 kernel, it does sync.
>
> So what user space part does the syncing (and how to prevent it)?

Syncing is initiated by kexec-tools. Following is the code in
kexec/kexec.c in kexec-tools-testing.tar.gz


        if ((result == 0) && do_sync) {
                sync();

I think this problem has nothing to do with syncing. There seems to be
some dependency on not shutting down network here. You might want to 
debug, exactly where does it get stuck.

- Specify earlyprintk= parameter for second kernel and see if control
  is reaching to second kernel.

- Otherwise specify --console-serial parameter on "kexec -l" commandline
  and it should display a message "I am in purgatory" on serial console.
  This will just mean that control has reached at least till purgatory.

Right now  there does not seem to be any option to prevent syncing and 
I don't know why would one like to have one.

> (...)
>
>
>>> The way kexec works now makes rebooting unreliable again:
>>> - network interfaces are brought down,
>>> - kernel tries to sync - it never will, as we're booted off network, 
>>> which is down
>>>
>>
>> Kexec has got an option -x --no-ifdown, which will not bring the network
>> down. Try that. "kexec- -e -x"
>
> It does seem to help, thanks.
>
> Why it has to be the last option specified?
>

I have no idea. This might be an stale comment. Try putting -x before -e.

> I tried -f option before (don't call shutdown), but it didn't help.
>

Even if you did -f, it must have shutdown the network. I think somehow
in latest kernels there is some dependency on network and that's why
not shutting down network in this case is helping you.

Thanks
Vivek
