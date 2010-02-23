Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab0BWGtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:49:53 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:55991 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0BWGtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x3uYHD8dO+zS9aDTrI/HbDfnec3xZhaEJJw6UVvqZWXy9waD/AYnWBXENLGK3dOGBj
         GaKCQuJsnUlFEfvG+cfWr1VWZGLnO1b96qZh2hRYccsRZOv2sjM0pbiTfhk5fWykEb89
         nup5JNtRvG6utzu7g3D/lmArrtmnUWCeVkI+4=
MIME-Version: 1.0
In-Reply-To: <20100222120430.GA10789@hmsreliant.think-freely.org>
References: <20100217202234.GD5256@x200>
	 <2375c9f91002212219g1ba5a0c0vab121b6a47527285@mail.gmail.com>
	 <20100222120430.GA10789@hmsreliant.think-freely.org>
Date: Tue, 23 Feb 2010 14:49:50 +0800
Message-ID: <2375c9f91002222249w55b2b06cq30b0236fa44b6cb@mail.gmail.com>
Subject: Re: hang in call_usermodehelper_exec()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 8:04 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Feb 22, 2010 at 02:19:28PM +0800, Américo Wang wrote:
>> On Thu, Feb 18, 2010 at 4:22 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> > I was stress-testing netns stuff in presence of removing modules.
>> >
>> > Kernel is 2.6.33-rc8-next-20100217+:
>> >
>>
>> I don't know if this kernel has Andi's patchset, which is:
>>
>> http://lkml.org/lkml/2010/1/4/506
>>
>> If yes, then please try Neil's patch:
>>
>> http://lkml.org/lkml/2010/2/12/181
>>
>> Thanks.
> No, both Andi's and my usermodehelper changes aren't going in until .34 IIRC,
> but that shouldn't matter, they weren't meant to fix hangs (not that they dont
> :) ).
>
> Looking at this, my guess is that your hang is in userspace, and that you have
> an old version of module-utils.  I fixed this with iptables awhile back.  What
> happens is that process 3737, the modprobe is removing modules, while the setkey
> utility is requesting kernel services that require those modules, so you are in
> fact trying to load and unload the same module(s) in parallel.  While thats not
> a huge deal, it results in the setkey utility forking another copy of modprobe
> (using callusermode_helper).  The two copies of modprobe actually take file
> locks on the module they are workign with, serializing them in user space.  If
> the setkey path and the modprobe path serialize at all in kernel space (by
> taking the module_mutex for instance), you get deadlock.
>
> I fixed this by making modprobe be non-blocking in user space (which is the
> default for insmod as well), and it fixed the problem.  The gory details are
> here:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=16fcec35e7d7c4faaa4709f6434a4a25b06d25e3
>
> My guess is that if you get the latest module-utils you can make this go away.

I see, excellent! Thank you!
