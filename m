Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXIYOEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXIYOEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXIYOD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:03:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51928 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbXIYOD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:03:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Remove broken netfilter binary sysctls from bridging code
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070921020554.GE31759@nineveh.local>
	<m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>
	<46F7EC0A.9030506@trash.net>
Date: Tue, 25 Sep 2007 08:03:08 -0600
In-Reply-To: <46F7EC0A.9030506@trash.net> (Patrick McHardy's message of "Mon,
	24 Sep 2007 18:55:38 +0200")
Message-ID: <m1641ydeqr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

>> Hmm.  This is an interesting case.  The proc method is forcing
>> the integer to be either 0 or 1 in a racy fashion.  But none of the
>> users appear to depend upon that.
>> 
>> So this is the least broken set of binary sysctls I have seen caught
>> by my check.
>> 
>> A really good fix would be to remove the binary side and then to
>> modify brnf_sysctl_call_tables to allocate a temporary ctl_table and
>> integer on the stack and only set ctl->data after we have normalized
>> the written value.  But since in practice nothing cares about
>> the race a better fix probably isn't worth it.
>
>
> I seem to be missing something, the entire brnf_sysctl_call_tables
> thing looks purely cosmetic to me, wouldn't it be better to simply
> remove it?

Well it is cosmetic in a user space visible way.  Which means I don't
have a clue which if any user space programs or scripts care if we change
the behavior. 

I just looked in the git history and brnf_sysctl_call_tables has been
that way since sysctl support was added to the bridge netfilter code.

The only comment I can found about the addition is:

    2003/12/24 19:32:34-08:00 bdschuym
    [BRIDGE]: Add 4 sysctl entries for bridge netfilter behavioral control:
    bridge-nf-call-arptables - pass or don't pass bridged ARP traffic to
    arptables' FORWARD chain.
    bridge-nf-call-iptables - pass or don't pass bridged IPv4 traffic to
    iptables' chains.
    bridge-nf-filter-vlan-tagged - pass or don't pass bridged vlan-tagged
    ARP/IP traffic to arptables/iptables.

So since forcing the values to 0 or 1 doesn't seem hard to maintain
I am uncomfortable with removing that check.

Eric

