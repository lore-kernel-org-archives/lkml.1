Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab0BVMEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:04:37 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44693 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0BVMEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:04:36 -0500
Date: Mon, 22 Feb 2010 07:04:30 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: hang in call_usermodehelper_exec()
Message-ID: <20100222120430.GA10789@hmsreliant.think-freely.org>
References: <20100217202234.GD5256@x200>
 <2375c9f91002212219g1ba5a0c0vab121b6a47527285@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91002212219g1ba5a0c0vab121b6a47527285@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 02:19:28PM +0800, Américo Wang wrote:
> On Thu, Feb 18, 2010 at 4:22 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > I was stress-testing netns stuff in presence of removing modules.
> >
> > Kernel is 2.6.33-rc8-next-20100217+:
> >
> 
> I don't know if this kernel has Andi's patchset, which is:
> 
> http://lkml.org/lkml/2010/1/4/506
> 
> If yes, then please try Neil's patch:
> 
> http://lkml.org/lkml/2010/2/12/181
> 
> Thanks.
No, both Andi's and my usermodehelper changes aren't going in until .34 IIRC,
but that shouldn't matter, they weren't meant to fix hangs (not that they dont
:) ).

Looking at this, my guess is that your hang is in userspace, and that you have
an old version of module-utils.  I fixed this with iptables awhile back.  What
happens is that process 3737, the modprobe is removing modules, while the setkey
utility is requesting kernel services that require those modules, so you are in
fact trying to load and unload the same module(s) in parallel.  While thats not
a huge deal, it results in the setkey utility forking another copy of modprobe
(using callusermode_helper).  The two copies of modprobe actually take file
locks on the module they are workign with, serializing them in user space.  If
the setkey path and the modprobe path serialize at all in kernel space (by
taking the module_mutex for instance), you get deadlock.

I fixed this by making modprobe be non-blocking in user space (which is the
default for insmod as well), and it fixed the problem.  The gory details are
here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=16fcec35e7d7c4faaa4709f6434a4a25b06d25e3

My guess is that if you get the latest module-utils you can make this go away.

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
