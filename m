Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZLOX1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZLOX1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZLOX1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:27:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZLOX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:27:32 -0500
Message-ID: <4B281BA4.8090806@gmail.com>
Date: Wed, 16 Dec 2009 00:28:36 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arjan van de Ven <arjan@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org> <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com> <20091214112656.GB1959@elf.ucw.cz> <20091214080049.19930729@infradead.org> <20091214212526.GB9213@elf.ucw.cz> <20091214141757.73606259@infradead.org> <4B26BF14.3040709@gmail.com> <20091215181403.GB24406@elf.ucw.cz>
In-Reply-To: <20091215181403.GB24406@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> Arjan van de Ven wrote:
>>> On Mon, 14 Dec 2009 22:25:26 +0100
>>> Pavel Machek <pavel@ucw.cz> wrote:
>>>
>>>> On Mon 2009-12-14 08:00:49, Arjan van de Ven wrote:
>>>>> On Mon, 14 Dec 2009 12:26:56 +0100
>>>>> Pavel Machek <pavel@ucw.cz> wrote:
>>>> I certainly object "constify ops... as much as possible". If it
>>>> uglifies the code, it should not be done. If it is as simple as adding
>>>> const to few lines, its probably ok.
>>>>
>>>> But .... the patch contained huge load of 
>>>>
>>>> -	int (* resume)()
>>>> +	int (* const resume)()
>>>>
>>>> What is that?
>>> the ops stuct instantiation itself should be const.
>>> the members not so much; that makes no sense.
>> Consitfying the structure fields prevents direct modifications of runtime
>> allocated ops structures therefore it gives a strong signal to the programmer
>> that he's trying to do something undesired (this approach is in fact already
>> used in the kernel, see: iwl_ops).
> 
> One const in structure declaration seems to be just enough, see:
> 
> const struct a {
> 	void (* f)(void);
> 	void (* const g)(void);
> } s;
> 
> void h(void)
> {
> 	struct a *p = &s;
> 	s.f = 0;
> 	s.g = 0;
> 	p->f = 0;
> 	p->g = 0;
> }
> 
> 
> delme.c: In function 'h':
> delme.c:8: warning: initialization discards qualifiers from pointer target type
> delme.c:9: error: assignment of read-only variable 's'
> delme.c:10: error: assignment of read-only variable 's'
> delme.c:12: error: assignment of read-only member 'g'
> 
> You get clean-enough warnings.
									Pave

Notice how you got an error for line 12 (p->g assignment) but no warning or error
at all for line 11 (p->f assignment). This example illustrates what I was explaining
so far:

if you dynamically allocate an ops structure (the result of which is a pointer type like
p in the above example) then with a non-const structure field you get no indication
from the compiler that you are doing something undesired, whereas with a const
structure field you get an error immediately. This is what helps a future developer
as it gives him a hint that he is doing something wrong and if he still insists on his
way of dynamic allocation, he will have to come up with ugly code
(e.g., void *(**)(void))(&p->g) = 0) that will not pass human review. You can teach gcc,
sparse, checkpatch, etc to recognize some of this ugliness but you cannot
programmatically detect all possible ways of evasion.
And if the compiler can help the developers, why not make use of it?

Note also that a const structure field helps the statically allocated non-const
variable case as well as the compiler will error out on such field modifications
(s.g assignment in my example) so the developer will again get a hint that he is
doing something undesired and will have to use direct initialisation (or write
the same ugly code as above that will not pass human review)
--
Emese

