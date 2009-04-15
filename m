Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZDOUWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZDOUWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZDOUWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:22:13 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:58106 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbZDOUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:22:12 -0400
Message-ID: <49E641D4.2000604@oracle.com>
Date: Wed, 15 Apr 2009 13:21:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, henrix@sapo.pt
Subject: Re: Trouble with make-install from a NFS mount
References: <49E500F6.8060401@novell.com> <49E501D4.6000605@oracle.com> <49E627AA.5080105@novell.com>
In-Reply-To: <49E627AA.5080105@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49E641B0.0283:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Randy Dunlap wrote:
>> Gregory Haskins wrote:
>>   
>>> Hi All,
>>>   I've been struggling trying to find the cause of a regression in
>>> 30-rc1 (compared to 2.6.29) where I am no longer able to make-install a
>>> kernel via an NFS mounted home directory.
>>>
>>> Historically I do all of my kernel development/building on one machine
>>> and then I have a bunch of test machines that are NIS/NFS clients of
>>> that machine that have the same /home mounted.  When I am ready to
>>> deploy a kernel, I log into that machine and su to root to simply "make
>>> modules_install && make install" the kernel.  This has always worked
>>> until recently.  I started getting this message:
>>>
>>>   INSTALL sound/usb/caiaq/snd-usb-caiaq.ko
>>>   INSTALL sound/usb/snd-usb-audio.ko
>>>   INSTALL sound/usb/snd-usb-lib.ko
>>>   INSTALL sound/usb/usx2y/snd-usb-usx2y.ko
>>>   DEPMOD  2.6.30-rc1-vbus
>>> rm: cannot remove `include/config/kernel.release': Permission denied
>>> make: *** [include/config/kernel.release] Error 1
>>>
>>> I understand what is going on w.r.t. the root shell having permisssion
>>> problems modifying data on an NFS mount.  However, this _used_ to work
>>> so I started investigating for what I thought would be a minor change to
>>> kbuild that I could patch.  At first I simply just hacked the makefile
>>> to make the kernel.release stuff use the "-" to ignore the error.  This
>>> did manage to get me past the initial problem, but then I immediately
>>> ran into more problems related to the generation of version.h and
>>> version.h.tmp as well. 
>>>
>>> Looking into this, I couldnt track down where the "filechk" magic was
>>> coming from (any hints from the kbuild gurus?).  So I thought that I

filechk is defined in scripts/Kbuild.include .

>>> would try to bisect the issue.  However, that failed to produce a bad
>>> commit for reasons that I do not quite understand either.  Here is the
>>> git-bisect log:
>>>
>>> git bisect start
>>> # good: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
>>> git bisect good 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
>>> # bad: [b21597d0268983f8f9e8b563494f75490403e948] Merge branch
>>> 'for-linus' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
>>> git bisect bad b21597d0268983f8f9e8b563494f75490403e948
>>> # good: [7f6adeaf2d8800b66c5dd6c2cf2622dfdd68bd31] V4L/DVB (10730):
>>> v4l-dvb: cleanup obsolete references to v4l1 headers.
>>> git bisect good 7f6adeaf2d8800b66c5dd6c2cf2622dfdd68bd31
>>> # good: [18222f98223a00537bcf29ba74c8d5fdb3ae1fb8] Staging: comedi: add
>>> ssv_dnp driver
>>> git bisect good 18222f98223a00537bcf29ba74c8d5fdb3ae1fb8
>>> # bad: [32fb6c17566ec66de87324a834c7776f40e35e78] Merge branch 'release'
>>> of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
>>> git bisect bad 32fb6c17566ec66de87324a834c7776f40e35e78
>>> # bad: [714f83d5d9f7c785f622259dad1f4fad12d64664] Merge branch
>>> 'tracing-for-linus' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>>> git bisect bad 714f83d5d9f7c785f622259dad1f4fad12d64664
>>> # good: [6404434525bb9f8f2239998f30fd7c93f2efa5b3] tracing/syscalls:
>>> various cleanups
>>> git bisect good 6404434525bb9f8f2239998f30fd7c93f2efa5b3
>>> # bad: [0a053e8c71d666daf30da2d407147b1293923d8b] Merge branch
>>> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc
>>> git bisect bad 0a053e8c71d666daf30da2d407147b1293923d8b
>>> # bad: [811158b147a503fbdf9773224004ffd32002d1fe] Merge branch
>>> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
>>> git bisect bad 811158b147a503fbdf9773224004ffd32002d1fe
>>> # bad: [b983471794e568fd71fa767da77a62ba517c3e63] Merge
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
>>> git bisect bad b983471794e568fd71fa767da77a62ba517c3e63
>>> # bad: [9140db04ef185f934acf2b1b15b3dd5e6a6bfc22] ocfs2: recover orphans
>>> in offline slots during recovery and mount
>>> git bisect bad 9140db04ef185f934acf2b1b15b3dd5e6a6bfc22
>>> # bad: [feb473a6e8bd19297d0f3bb377b25055c0228c0a] ocfs2: Optimize inode
>>> group allocation by recording last used group.
>>> git bisect bad feb473a6e8bd19297d0f3bb377b25055c0228c0a
>>> # bad: [e7c17e43090afe558c40bfb66637744c27bd2aeb] ocfs2: Introduce dir
>>> free space list
>>> git bisect bad e7c17e43090afe558c40bfb66637744c27bd2aeb
>>> # bad: [59b526a30722f29e5dba6210a6e0fc34e3149b94] ocfs2: Remove debugfs
>>> file local_alloc_stats
>>> git bisect bad 59b526a30722f29e5dba6210a6e0fc34e3149b94
>>> # bad: [96a6c64b5354b804b3ccfd1b31306565a01ebcb1] ocfs2: Move struct
>>> recovery_map to a header file
>>> git bisect bad 96a6c64b5354b804b3ccfd1b31306565a01ebcb1
>>> # bad: [87d3d3f3931f3e0fca44fbb5c06ad45fc4dca9bc] ocfs2/hb: Expose the
>>> list of heartbeating nodes via debugfs
>>> git bisect bad 87d3d3f3931f3e0fca44fbb5c06ad45fc4dca9bc
>>>
>>> What I dont really understand is that this (I thought) was supposed to
>>> look for where the behavior first appeared between v2.6.29..HEAD, but
>>> some points along the way were actually before v2.6.29 was cut.  I don't
>>> really know what went wrong, but if it matters I am running git 1.6.2.
>>>
>>> At this point, I am stuck.  Perhaps there is a better methodology to
>>> deploying the kernels that I should employ, but I am not sure which to
>>> use yet.  Any help appreciated!
>>>     
>>
>> See this patch, already applied/merged:
>>
>> Gitweb:     http://git.kernel.org/linus/556b0f58bbcdc96ba8ed67001b4e57c50198da89
>> Commit:     556b0f58bbcdc96ba8ed67001b4e57c50198da89
>> Parent:     8e320d02718d2872d52ef88a69a493e420494269
>> Author:     David Woodhouse <David.Woodhouse@intel.com>
>> AuthorDate: Sat Jan 10 14:53:15 2009 +0000
>> Committer:  David Woodhouse <David.Woodhouse@intel.com>
>> CommitDate: Mon Apr 6 14:27:17 2009 -0700
>>
>>     Revert "fix modules_install via NFS"
>>     
>>     This reverts commit 8b249b6856f16f09b0e5b79ce5f4d435e439b9d6.
>>     
>>     This 'fix' is not necessary; we just need to undo the damage caused
>>     accidentally by Igor/Mauro in 4b29631db33292d416dc395c56122ea865e7635c
>>     ("V4L/DVB (9533): cx88: Add support for TurboSight TBS8910 DVB-S PCI card")
>>     
>>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>>
>>
>>   
> Thanks Randy.  I was running on 0882e8dd3aad33eca41696d463bb896e6c8817eb
> so I had these patches all applied.  I think you were trying to tell me
> that perhaps a similar fix could be found among these patches, but I was
> unfortunately not able to find any and this is still broken for me.

No, I wasn't trying to say that.  Your very first paragraph said
"regression in 30-rc1" and David's patch fixes that problem.

So is there still some other problem in linus-current?

> As a work-around, I wrote the following script to push my kernels out
> over ssh, instead of pulling them in by nfs.  FWIW, i'll post it here as
> others have privately told me they are having this same bug in
> make-install affect them as well.
> 
> #!/bin/bash
> 
> #
> # deploykernel - push a kernel to a remote ssh machine
> #
> # Author: Gregory Haskins <ghaskins@novell.com>
> #
> 
> set -e
> 
> if [ -z $1 ]; then
>     echo "usage: $0 <remote>"
>     exit -1
> fi
> 
> tmp=$(mktemp -d)
> rel=$(cat include/config/kernel.release)
> 
> echo "Generating module image"
> make modules_install INSTALL_MOD_PATH=$tmp
> 
> echo "Transferring modules"
> (cd $tmp; tar -c *) | ssh root@$1 'cd /; tar -xv'
> 
> rm -rf $tmp
> 
> echo "Transferring kernel"
> tmp=$(ssh root@$1 'mktemp -d')
> 
> scp ./arch/x86/boot/bzImage root@$1:$tmp
> scp ./System.map root@$1:$tmp
> 
> echo "Installing kernel"
> ssh root@$1 "cd $tmp; /sbin/installkernel $rel bzImage System.map; rm
> -rf $tmp"


-- 
~Randy
