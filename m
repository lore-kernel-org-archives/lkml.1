Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXKJVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXKJVYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXKJVYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:24:24 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:40985 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754402AbXKJVYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:24:22 -0500
Message-ID: <4736219E.50207@crispincowan.com>
Date: Sat, 10 Nov 2007 13:24:46 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com> <p73tzntzuak.fsf@bingen.suse.de>
In-Reply-To: <p73tzntzuak.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Crispin Cowan <crispin@crispincowan.com> writes:
>
> The document should be a good base for a merge.
>
>   
>>     * A confined process can operate on a file descriptor passed to it
>>       by an unconfined process, even if it manipulates a file not in the
>>       confined process's profile. To block this attack, confine the
>>       process that passed the file descriptor.
>>     
>
> That is the only thing that tripped me up a bit while reading the document.
> Can you expand a bit on the reasons why the fd is not rechecked in
> the context of the target process? Best do it in a new version of the
> document.
>   
The reason is a disgusting implementation problem, so instead of going
into lots of detail, I just disclaimed it.

The excuse :) is that UNIX/Linux already has an object-capability
orientation with respect to passing file descriptors around; you can
pass an FD to a process that doesn't have access to the file, and DAC
(user ownership & such) won't check it either.

This aspect of the semantics is not my favorite, but it is at least
consistent with the AppArmor view that unconfined processes can do
absolutely anything and AppArmor won't try to stop them.

The actual reason: FDs that are passed from some other *confined*
process actually are checked, because the FD has data structures on it
that we can use to hook for checking. The problem is that an FD from a
completely unconfined process has no such data structures. To fix this,
we would have to check access on every single read and write, and that
would make performance suck.

If there is a clean way to close this issue, I would be interested.

On the other hand, there is a fairly passionate community of Object
Capability fans who really want access rights to be delegable, and the
other way to go is to remove all checking on passed FDs.

There are advantages to going both ways, and I don't believe that
AppArmor is locked in stone, so either one could be chosen in the
future. See this interesting thread on LSM
http://marc.info/?t=119464929300003&r=1&w=2

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

