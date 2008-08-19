Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYHSQHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYHSQHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYHSQHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:07:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:38811 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYHSQHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:07:40 -0400
Date: Tue, 19 Aug 2008 09:07:01 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: tvrtko.ursulin@sophos.com
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
 a linux interface for on access scanning
In-Reply-To: <20080819083240.E5E532FE82F@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808190845000.12859@asgard.lang.hm>
References: <20080819083240.E5E532FE82F@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, tvrtko.ursulin@sophos.com wrote:

> david@lang.hm wrote on 18/08/2008 18:02:57:
>
>> On Mon, 18 Aug 2008, tvrtko.ursulin@sophos.com wrote:
>>
>>> david@lang.hm wrote on 18/08/2008 13:07:47:
>>>
>>>>>> 3. have a kernel mechanism to say "set this namespace tag if this
>>> other
>>>>>> namespace tag is set" (this allows a scanner to set a 'scanning'
> tag
>>>>> when it
>>>>>> starts and only set the 'blessed' tag if the file was not dirtied
>>>>>> while it was
>>>>>> being scanned. without this there is a race condition that could
>>> cause a
>>>>> file
>>>>>> to be marked as good incorrectly, the initial threat model ruled
>>>>> outworrying
>>>>>> about race conditions, but this seems like a fairly easy one to
> close
>>>>>
>>>>> I don't think you can use xattrs as some atomic barriers, I suspect
>>> they
>>>>> are suspectible to same race conditions as open-write-read.
>>>>
>>>> this is why it would require kernel support to turn them into atomic
>>>> barriers (and the reason for this item). without kernel support there
> is
>>> a
>>>> race (it's debatable if that race i significant enough to require the
>>>> implementation of kernel support to close it, but that's why I listed
>>>> this)
>>>
>>> Maybe not since there are races with database updates anyway. What
> would
>>> be necessary is a method of clearing the whole xattr namespace on
> fresh
>>> mount to avoid trusting stale data. That I so far don't see how it can
> be
>>> done from userspace safely.
>>
>> you don't need to clear the xattr space, you can get the same effect by
>> having scanners that care increment their generation ID.
>
> Not the most efficient way since generation ID is global while we are
> talking about a single mount/filesystem. So incrementing the generation ID
> causes all filsystems to be rescanned. Also you need additional hooking in
> mount, plus you have a race condition unless you block in mount while you
> do your stuff. And you need to take care about deadlocks.

if this is important enough the generation id could be made per-filesystem 
one if this was important enough. yes you would need hooks in mount 
(including blocking) to be 100% protected

I don't see the deadlock though


>> but this would require some way for them to learn of mounts.
>>
>>> Also problem with read-only mounts comes to mind. Ups, yes, this is a
> big
>>> problem with this scheme in general. We cannot trust xattr namespace
> when
>>> we mount something fresh because it has been potentialy mounted on a
>>> different system, but if it gets mounted read-only we cannot purge
> that
>>> data and we cannot store our scan results. Only option is not to do
> any
>>> scanning.
>>>
>>> This may not be a common usage scenario so it may not be a problem
> though.
>>
>> this is also a policy question, you may _want_ to trust the scanning
> done
>> by a different machine, so it's not always the case that you need to
>> invalidate the scan results when mounting things.
>
> Without additional filesystem/VFS support you won't be able to tell if
> wherever the filesystem was previously mounted had any scanning done. It
> may have been mounted on a kernel which does not support the whole scheme
> so it didn't clear the namespace for modified files.

if the scan results are stored in xattrs all you have to do is to look for 
them. if they are there then scanning was done.

and no, you can't ever be 100% sure that the scanning tags were implmented 
correctly on another machine, so some people will choose to not trust 
them, but other people will choose to trust them. this is a policy 
decision, not somthing that should be baked into the design.

>>>> I don't think this tool should require the use of other tools to
> exempt
>>>> programs from it, and going that way lies madness (there are too many
>>>> combinations of different tools, trying to define all of the possible
>>>> interactions can't work, and saying that you must use SELinux with
> this
>>>> and not any of the other options is going to be a sure way to get a
> lot
>>> of
>>>> people to not use your tools)
>>>
>>> Then there is still a question of who allows some binary to declare
> itself
>>> exempt. If that decision was a mistake, or it gets compromised
> security
>>> will be off. A very powerful mechanism which must not be easily
>>> accessible.  With a good cache your worries go away even without a
> scheme
>>> like this.
>>
>> I disagree. I think the number of binaries on the system that don't need
>
>> the scanning is surprisingly large, many programs just treat files they
>> access as blobs of data and don't try to interpret them. it's only when
>> the file is interpreted or handed to another system that it needs to be
>> scanned.
>
> In a way this is a slighlty different way of moving protection from core
> to the border which means you must enumerate all possible entry/exit
> points and you must not get it wrong.

again, a policy decision. some people will choose to pay the scanning cost 
for all binaries, others will choose to take the risk of getting it wrong 
to avoid paying the scanning cost when it doesn't help them.

>>>>> I think you overcomplicated it both in design and in presentation of
>>> this
>>>>> text. I was not able to follow and absorb all your postings so I am
>>> not
>>>>> sure what apart from single cache point and non-persistent cache you
>>>>> dislike in Eric's proposal?
>>>>
>>>> single cache point, non-persistant cache, inablility to support
> scanners
>>>
>>>> that don't involve enforcement, inability to do preemptive scanning
> of
>>>> changes, inability to have user policy define what priority to put on
>>>> checks, lack of thought of any use other then anti-virus functions.
>>>
>>> So you do have a whole new set of requirements which if agreed on
> someone
>>> will need to implement.
>
> You skipped this bit where I almost asked you if you are willing to get
> your hands dirty with implementing all this? :)

I am willing to help, but my ablity to help is limited. I'm much more of a 
user/tester then I am a kernel/library programmer.

I'm one of the people who would use this (or not use this) on the several 
hundred machines I manage. I see value in having the capability to do the 
scanning/indexing reliably even on machines that don't have windows 
anywhere near them, but an interface that didn't allow for multiple 
scanners and didn't allow for persistant tagging of scan results would be 
of very limited use to me. and if there is no way to have programs bypass 
the scan the performance hit would be crippling so I wouldn't use it on my 
machines.

>>>> yes this is more complicated than a single bit in memory as the flag,
>>> but
>>>> it's also far more flexible.
>>>
>>> True. It would be nice though if we could think of a solution which
> would
>>> not have a in-kernel tag parser. I am mostly worried about performance
>>> because tags would have to be checked on every open/read/whetever and
>>> compared against the policy set from userspace. If I understand
> correctly
>>> how you imagined it. Or if you wanted to go to userspace for all these
>>> decisions then add even more cost for context switching. In later case
> you
>>> would also have some kenrel code dealing with cleaning xattr tags
> which
>>> would not be mentioned anywhere else in the kernel and that sounds a
> bit
>>> like black magic.
>>
>> I don't have an in-kernel tag parser. I have a in-kernel tag clearer,
> but
>> the tag parser is in the userspace library. this also avoids all the
>> context switches that worry you as well.
>
> How is that? Context switches which worry me are the ones which happen
> when for each access to a file we need to go to userspace just to see if
> it has already been scanned. That is why I was more in favour completely
> of in-kernel caching scheme.

you are missing my point. you are saying that there is a context switch 
to go to userspace to check things. I am suggesting that you would never 
leave userspace to go to the kernel until after the check is done. the 
userspace open/read/mmap/etc call would do the checking and only if it 
passed would it make the context switch into the kernel.

>>>>>> are any of the features I list impossible to implement?
>>>>>
>>>>> Serialisation and race condition avoidance using extended attributes
> I
>>>>> think.
>>>>
>>>> why could the kernel not have a command that locked the inode for the
>>>> read, check, write cycle of changing extended attributes? I agree
> (and
>>>> document) that without such support there is a race condition.
>>>
>>> We could but I agree that we probably don't need to. Having this would
> be
>>> very bad for performance.
>>
>> why would this be bad for performance? the atomic version would be a
>> different function that would only be used when marking a file clean,
> and
>> as this locking would only be contended if multiple scanners needed to
>> mark a file clean at the same instance, it will be a very
> low-contention,
>> low-use lock.
>
> Maybe you would need to lock when checking if file is clean to avoid
> races? Don't know, I didn't give this that much thought.

I'm not sure if you need to do this or not, but if you do you can get the 
effect of locking by setting a "I'm working on it" xattr, if the file gets 
dirtied before you get done it will get cleared and when you are finished 
scanning you can check to see if it's still there before marking the file 
as clean.

if you want to be sure there are no race conditions at all in this there 
would be a need for an 'atomic' (as relates to userspace) way to set an 
xattr only if another one was set.

David Lang
