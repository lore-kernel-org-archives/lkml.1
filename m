Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbZLNWjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbZLNWjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZLNWjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:39:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZLNWjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:39:45 -0500
Message-ID: <4B26BF14.3040709@gmail.com>
Date: Mon, 14 Dec 2009 23:41:24 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Pavel Machek <pavel@ucw.cz>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com>	<20091214003836.GD7812@parisc-linux.org>	<4B2595E7.701@gmail.com>	<20091214021916.GB12196@linux-sh.org>	<4B25E47C.1010803@gmail.com>	<20091214112656.GB1959@elf.ucw.cz>	<20091214080049.19930729@infradead.org>	<20091214212526.GB9213@elf.ucw.cz> <20091214141757.73606259@infradead.org>
In-Reply-To: <20091214141757.73606259@infradead.org>
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

Arjan van de Ven wrote:
> On Mon, 14 Dec 2009 22:25:26 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
>> On Mon 2009-12-14 08:00:49, Arjan van de Ven wrote:
>>> On Mon, 14 Dec 2009 12:26:56 +0100
>>> Pavel Machek <pavel@ucw.cz> wrote:
>> I certainly object "constify ops... as much as possible". If it
>> uglifies the code, it should not be done. If it is as simple as adding
>> const to few lines, its probably ok.
>>
>> But .... the patch contained huge load of 
>>
>> -	int (* resume)()
>> +	int (* const resume)()
>>
>> What is that?
> 
> the ops stuct instantiation itself should be const.
> the members not so much; that makes no sense.

Consitfying the structure fields prevents direct modifications of runtime
allocated ops structures therefore it gives a strong signal to the programmer
that he's trying to do something undesired (this approach is in fact already
used in the kernel, see: iwl_ops).

There is another benefit in that static but non-const ops structures cannot be
directly modified either, therefore it will be easier to make them const later.

Example:

 1 struct a {                                                                                                                                                 
 2  void (* f)(void);
 3  void (* const g)(void);
 4 } s;
 5 
 6 void h(void)
 7 {
 8  struct a *p = &s;
 9  s.f = 0;
10  s.g = 0;
11  p->f = 0;
12  p->g = 0;
13 }

gcc -c a.c
a.c: In function 'h':
a.c:10: error: assignment of read-only member 'g'
a.c:12: error: assignment of read-only member 'g'

--
Emese
