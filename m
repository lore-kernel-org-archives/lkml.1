Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbYKNQDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbYKNQDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYKNQDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:03:30 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43755 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYKNQD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:03:29 -0500
Message-ID: <491DA131.1060209@cosmosbay.com>
Date: Fri, 14 Nov 2008 17:02:57 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com> <491D987F.1000301@cosmosbay.com> <20081114155904.GJ3810@one.firstfloor.org>
In-Reply-To: <20081114155904.GJ3810@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 14 Nov 2008 17:03:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> On Fri, Nov 14, 2008 at 04:25:51PM +0100, Eric Dumazet wrote:
>> Very strange results on my Intel E5450 CPU
>>
>> I found that I have to bias regs->ip by 16 bytes in order to have
>> correct profiling.
> 
> Can you expand a bit how you determined if the profile is right or wrong?
> 
> -Andi
> 
> 

opannotate -a vmlinux > FILE

And check results.

With the patch I get :

c041d270 <dst_release>: /* dst_release total:  16523  1.2978 */
   252  0.0198 :c041d270:       push   %ebp
   654  0.0514 :c041d271:       test   %eax,%eax
               :c041d273:       mov    %esp,%ebp
    47  0.0037 :c041d275:       mov    %eax,%edx
    42  0.0033 :c041d277:       je     c041d289 <dst_release+0x19>
               :c041d279:       mov    $0xffffffff,%eax
     3 2.4e-04 :c041d27e:       lock xadd %eax,0x80(%edx)
 14766  1.1598 :c041d286:       dec    %eax
     1 7.9e-05 :c041d287:       js     c041d28b <dst_release+0x1b>
    53  0.0042 :c041d289:       pop    %ebp
   705  0.0554 :c041d28a:       ret
               :c041d28b:       mov    $0x10e,%edx
               :c041d290:       mov    $0xc0561ed5,%eax
               :c041d295:       call   c022d1a0 <warn_on_slowpath>
               :c041d29a:       pop    %ebp
               :c041d29b:       ret
               :c041d29c:       lea    0x0(%esi),%esi

This results please me : The cost is right after the "lock xadd" as expected.

Without patch, all addresses were off by 16 bytes.

On dst_release() it was on the call on warn_on_slowpath(),
and I am pretty sure it is not possible at all this WARN_ON is hit



