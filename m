Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYKVBvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYKVBvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbYKVBu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:50:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:46021 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbYKVBuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:50:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yE53EaIYQ+kKBZsq5r1636bXdxRBmfVPxUVKYNhjfMJrk2DB3XWRtg0CwZqlX/Nfxy
         0ry/wB3O+urCf6qxnynUyL0Dep07CAaZEUDAFsCx6BrkOtandgyZ3DMk2kN2q4N4ssJr
         1yA81gWFZznZVxwimTMd0NhklVOhNb06jzGao=
Message-ID: <19f34abd0811211750l7edc8037ue813341779917b0@mail.gmail.com>
Date: Sat, 22 Nov 2008 02:50:54 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Brian Phelps" <lm317t@gmail.com>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Julia Lawall" <julia@diku.dk>
Subject: Re: kernel BUG at mm/slab.c:601
Cc: linux-kernel@vger.kernel.org, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Alexander Shaduri" <ashaduri@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <19f34abd0811211726h143c83f6obdfcb97e71fa595f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
	 <19f34abd0811191419x3f6981ady7de5bf40f9ae2983@mail.gmail.com>
	 <ea3b75ed0811200901p1bd9e746q5b3757dd6114f3bd@mail.gmail.com>
	 <19f34abd0811211710q65d6200bt3a145971cd1bc911@mail.gmail.com>
	 <19f34abd0811211725s169dc42ao195c61b6dac3e975@mail.gmail.com>
	 <19f34abd0811211726h143c83f6obdfcb97e71fa595f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 2:26 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> [Resend with (I hope) working e-mail address for Mauro]
>
> On Sat, Nov 22, 2008 at 2:25 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Sat, Nov 22, 2008 at 2:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>>> [  527.562373]  ffffffff8043b157 0000000000200200 ffffffffa02810d4
>>>> ffff88001e13c600
>>>
>>> LIST_POISON2 on the stack:
>>>
>>> include/linux/poison.h:#define LIST_POISON2  ((void *) 0x00200200)
>>
>> So looking at bttv source code, I wonder what the codes like these are
>> trying to do:
>>
>>                        if (set->top->vb.queue.next)
>>                                list_del(&set->top->vb.queue);
>>
>> Code is ancient, I'll ask Mauro.

A semantic patch that finds such invalid list constructs (it is
invalid, isn't it?) would look like this:

@@
expression E;
statement S;
@@

(
* if (E.next) S
|
* if (!E.next) S
|
* if (E.prev) S
|
* if (!E.prev) S
)

I am guessing that the original code wanted to check whether the
object was the last in a list? (The invalid assumption is that NULL
ends the list. Or NULL means that the node is not on a list? But if
so, why take it off the list? In either case, the NULL test looks
wrong because of the poison pointers which prevent intent of the code
-- to check if there is a valid next entry.)

But for this test we actually need to know the list head too. And I
don't know where to find it.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
