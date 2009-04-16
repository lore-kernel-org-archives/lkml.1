Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZDPFWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZDPFWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDPFWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:22:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47363 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZDPFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:22:15 -0400
Date: Thu, 16 Apr 2009 06:15:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: arjan@linux.intel.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       viro@ZenIV.linux.org.uk, jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
In-Reply-To: <200904160046.n3G0ki9o028612@www262.sakura.ne.jp>
Message-ID: <Pine.LNX.4.64.0904160551080.28048@blonde.anvils>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
 <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk>
 <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
 <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk>
 <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
 <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
 <200904160046.n3G0ki9o028612@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009, Tetsuo Handa wrote:
> Indeed, we can't use "argv" put on stack memory if we use "no wait" mode.
> We need to ensure that memory region pointed by "argv" is valid until
> do_execve() finishes. However,
> | 
> | exit:
> | 	kfree(devpath);
> | 	kfree(env);
> | 	return retval;
> | }
> "env" can be overwritten as well as "argv".
> We need to ensure that memory region pointed by "env" is valid until
> do_execve() finishes, don't we?
> 
> I think we need to use UMH_WAIT_EXEC instead of UMH_NO_WAIT.

Yes, of course you're right, silly me.

It could be worked around using call_usermodehelper_setcleanup()
to arrange for the freeing there instead of here in this case;
but if CONFIG_UEVENT_HELPER_PATH="" is the better answer anyway,
let's not waste any more time on this, just revert the broken patch
(which is what simply changing UMH_NO_WAIT to UMH_WAIT_EXEC does).

I'd hoped to get confirmation that the mmap.c part of the patch
was all the extra needed; but never mind, that's clearly good.

Thanks a lot: I'll send in a revert request,
and the acct_stack_growth patch, later today.

Hugh
