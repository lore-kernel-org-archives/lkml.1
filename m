Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYEXS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYEXS7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYEXS7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:59:15 -0400
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:50748 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbYEXS7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:59:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQBACMCOEicIsYN/2dsb2JhbAAIiw6hSA
Message-ID: <48386581.70502@gmail.com>
Date: Sat, 24 May 2008 15:59:13 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC] x86: Switch apm to unlocked_kernel
References: <20080522212204.177410b8@core> <d1af83620805230436w28274e82tc98261b69ecd1330@mail.gmail.com>
In-Reply-To: <d1af83620805230436w28274e82tc98261b69ecd1330@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> On Thu, May 22, 2008 at 5:22 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This pushes the lock a fair way down and the final kill looks like it
>> should be an easy project for someone who wants to have a shot at it.
>>
> 
> I would like to have a shot at this if no one else if currently
> working on it.  This would be my first attempt to graduate from
> testing (and a few simple patches) to an actual functional change.  I
> would expect that the steps involved are:
> 
> - See what data is affected under the BKL
> - See where else that data may be affected (including possible
> parallel calls to the same path)
> - Decide what locking is necessary
> - Implement it (the easy part)
> 
> If this is about right (and I'm not missing anything major) - I will
> give it a try and see where I get.
> 
> If, however, I have just proved that I do not have a full grasp of the
> problem, or if someone else is already working on this particular path
> - please let me know.
> 

(Added Stephen to cc as he is the maintainer here)

After looking at this for a while to figure out the necessary locking, I 
discovered drivers/char/apm_emulation.c, which has very similar 
structures to arch/x86/kernel/apm_32.c, and has much more locking (e.g. 
A state_lock mutex, a user_list_lock rwsem) and it uses a list_head for 
the apm_user_list instead of an open coded doubly linked list.

This brought up the following question:

- Should I just copy the locking from apm_emulation to apm?  Another 
patch from Alan moved the BKL down into the apm_emulation ioctl method, 
but it seems pretty well locked as it is - so that BKL can probably just 
be removed there.

Also - as far as I can tell, the two files both do the exact same thing 
from the point of view of the kapmd thread and /dev/apm_bios file, but 
the real apm makes actual bios calls to perform the suspend/standby 
operations, and apm_emulation just uses pm methods like pm_suspend().

- Thus, shouldn't the two files share code from a common third file?

If so, I could take on the task of that refactoring, if I were given an 
idea of where I should put the new file (where does an x86 and 
drivers/char common file go?).

Possible reasons this may not be worth it include:

- The APM code is possibly fragile, and not often used anymore.  If this 
is the case, then perhaps just adding the same locking from the 
emulation file to the true apm file would be a good idea.
- There are subtle differences I am not seeing that requires the code to 
be quite separate.  If so, please let me know.


Thank you for any comments,

-- 
Kevin Winchester
