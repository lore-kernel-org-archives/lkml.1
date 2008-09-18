Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYIRQ1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYIRQ1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYIRQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:26:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:13346 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYIRQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RjOgS9+2HT/coksWCX7GEfHXAuAgxY7TyLCdbPAoBKcWEcKyP0enGGTEDhdiFpvvay
         AfkYosHgfNqKlcGuUbpJU25N4dARn+5MZBSqws2xvbnO2I8QVp0sH1BEuNbNkyRuvnOY
         aJxX1YBMbFG46dj6vebKnb/xqhq71GFGq4qgU=
Message-ID: <48D2814B.7030909@gmail.com>
Date: Thu, 18 Sep 2008 18:26:51 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, akpm@linux-foundation.org, agk@sourceware.org,
       subrata@linux.vnet.ibm.com, axboe@kernel.dk,
       Marco Innocenti <m.innocenti@cineca.it>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [RFC][PATCH -mm 1/5] i/o controller documentation
References: <1219853257-11052-2-git-send-email-righi.andrea@gmail.com> <20080918140416.GF20640@redhat.com> <48D26DDF.9080402@gmail.com> <20080918153310.GI20640@redhat.com>
In-Reply-To: <20080918153310.GI20640@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Sep 18, 2008 at 05:03:59PM +0200, Andrea Righi wrote:
>> Vivek Goyal wrote:
>>> On Wed, Aug 27, 2008 at 06:07:33PM +0200, Andrea Righi wrote:
>>>> Documentation of the block device I/O controller: description, usage,
>>>> advantages and design.
>>>>
>>>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
>>>> ---
>>>>  Documentation/controllers/io-throttle.txt |  377 +++++++++++++++++++++++++++++
>>>>  1 files changed, 377 insertions(+), 0 deletions(-)
>>>>  create mode 100644 Documentation/controllers/io-throttle.txt
>>>>
>>>> diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
>>>> new file mode 100644
>>>> index 0000000..09df0af
>>>> --- /dev/null
>>>> +++ b/Documentation/controllers/io-throttle.txt
>>>> @@ -0,0 +1,377 @@
>>>> +
>>>> +               Block device I/O bandwidth controller
>>>> +
>>>> +----------------------------------------------------------------------
>>>> +1. DESCRIPTION
>>>> +
>>>> +This controller allows to limit the I/O bandwidth of specific block devices for
>>>> +specific process containers (cgroups) imposing additional delays on I/O
>>>> +requests for those processes that exceed the limits defined in the control
>>>> +group filesystem.
>>>> +
>>>> +Bandwidth limiting rules offer better control over QoS with respect to priority
>>>> +or weight-based solutions that only give information about applications'
>>>> +relative performance requirements. Nevertheless, priority based solutions are
>>>> +affected by performance bursts, when only low-priority requests are submitted
>>>> +to a general purpose resource dispatcher.
>>>> +
>>>> +The goal of the I/O bandwidth controller is to improve performance
>>>> +predictability from the applications' point of view and provide performance
>>>> +isolation of different control groups sharing the same block devices.
>>>> +
>>>> +NOTE #1: If you're looking for a way to improve the overall throughput of the
>>>> +system probably you should use a different solution.
>>>> +
>>>> +NOTE #2: The current implementation does not guarantee minimum bandwidth
>>>> +levels, the QoS is implemented only slowing down I/O "traffic" that exceeds the
>>>> +limits specified by the user; minimum I/O rate thresholds are supposed to be
>>>> +guaranteed if the user configures a proper I/O bandwidth partitioning of the
>>>> +block devices shared among the different cgroups (theoretically if the sum of
>>>> +all the single limits defined for a block device doesn't exceed the total I/O
>>>> +bandwidth of that device).
>>>> +
>>> Hi Andrea,
>>>
>>> Had a query. What's your use case for capping max bandwidth? I was
>>> wondering will proportional bandwidth not cover it. So if we allocate
>>> weight/share to every cgroup and limit the bandwidth based on shares
>>> only in case of contention. Otherwise applications get to unlimited
>>> bandwidth. Much like what cpu controller does or for that matter dm-ioband
>>> seems to be doing the same thing. Will you not get same kind of QoS here when
>>> comapred to max-bandwidth. The only thing probably missing is what we call
>>> hard limit. When BW is available but you don't want a user to use that
>>> BW, until and unless user has paid for that.
>> At the beginning my use case was to guarantee a certain level
>> performance _predictability_. That means no more and no less than the
>> specified threshold (should I say this would be useful for the real-time
>> apps? maybe yes).
>>
> 
> Is "no more" harmful for real-time env? Which RT application hates more
> bandwidth than what one asked for? I could understand "no-less" but you
> mentioned in the past that implementing minimum gurantees is lot harder.

RT doesn't mean as fast as possible, the objective of RT is to meet the
individual timing requirement. So, the most important property for RT should
be predicatbility. If you know that an application would require exactly
T seconds to read a block from a device (no more, no less) well... in this
case you're not introducing uncertainness in your RT task.

And I agree for the "no-less" part. It's difficult, but there's surely
space for improvements.

> I was thinking that what if we continue to stick to the current policy
> of letting RT requests go first and try to let them use disk bw first.
> cfq first dispatches requests of RT class (based on their priority).
> So in simple implementation, IO controller will simply let all the RT class
> requests to go directly to elevator and then let elevator dispatch these
> requests based on their RT prio. IO-controller will only buffer and control
> requests of non-RT class. This will make sure that we don't break the case of
> existing working RT applications and still be able to divide remaining disk
> BW among other non-RT tasks.
> 
> IMHO, once above simple scheme is working, we can probably extend it to
> provide additional level of controls.
>  
> Thanks
> Vivek

Sounds reasonable, since we want to give more guarantees to respect minimum bw
requirements for RT tasks.

-Andrea
