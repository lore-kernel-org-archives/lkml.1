Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZGCJky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZGCJky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZGCJkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:40:25 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:48689 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbZGCJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bRf0sEEuipeXm75p5HdExDKmZdTHhgBkFLu4OB68SAL5WZldq3lwlkReZpcxhikpjX
         7dKHMMcfImfjqRNfMKSBCuiSBNQhTxcxMM+dLxSXovmsPK9A6Z6SWMxY9Hs7ek2brOjd
         ERBpETZ6X5cIXWDE3L1NM7tGF1r0x2viK4Q74=
Date: Fri, 3 Jul 2009 17:42:29 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090703094229.GI5880@cr0.nay.redhat.com>
References: <20090703015554.GB5880@cr0.nay.redhat.com> <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com> <20090703030008.GD5880@cr0.nay.redhat.com> <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com> <20090703051917.GE5880@cr0.nay.redhat.com> <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com> <20090703071504.GG5880@cr0.nay.redhat.com> <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com> <20090703081655.GH5880@cr0.nay.redhat.com> <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 04:27:29PM +0800, Changli Gao wrote:
>On Fri, Jul 3, 2009 at 4:16 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>> On Fri, Jul 03, 2009 at 03:40:34PM +0800, Changli Gao wrote:
>>>On Fri, Jul 3, 2009 at 3:15 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>>>
>>>> If saving one fd really helps here, probably you want to
>>>> save more, you will need a syscall like:
>>>>
>>>>  int splice_without_new_fd(int infd, int outfd);
>>>Do you know sendfile()? Its current implementation is buggy, and will
>>>be blocked on outfd. Anyway, the above code is just a use case, there
>>>are other cases sendfile can't cover.
>>
>> So what? So you should fix it intead of inventing a new pipe() and use
>> splice(2)...
>I said: It just a special case. Fixing sendfile() won't fix everything.

What do you want? Just saving an fd, isn't it?

sendfile() does this but you said it's buggy, if you fix it, what is the
rest problem?

>
>>
>> Wait... if splice(2) doesn't block, what is your point for saving
>> an fd in your code? You can do:
>>
>> int splice_two_fd(int fd1, int fd2)
>> {
>>        int fds[2];
>>        pipe(fds);
>>        splice(fd1, fds[0]);//not block
>>        splice(fds[1], fd2);//not block
>>        close(fds[0]); //can be closed soon
>>        close(fds[1]); //ditto
>> }
>>
>> Outside this function no new fd's are used.
>>
>In fact, sendfile(2) is implemented via splice(2) infrastructure. The
>logic is the same, and much clever than yours. Dive into its code, you
>will find the reason why it must be blocked on outfd.


Sure, this is done in user-space, definitely....

>
>>>
>>>>
>>>> But splice(2) is designed to be as it is. You need to increase
>>>> your fd limit, instead of saving one by pipe().
>>>>
>>>I don't agree with you. We should save resource as much as we can, and
>>>not work around it.
>>
>> You are saying splice(2) is wrong? Because it is splice(2) who
>> needs 3 fd's finally.
>>
>It isn't splice(2)'s fault. In fact, I can also work around this issue
>by named pipe.

And increase the max fd number...
