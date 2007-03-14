Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbXCNDvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbXCNDvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 23:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXCNDvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 23:51:45 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:29130 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752703AbXCNDvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 23:51:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=a9/ZvuB/7YOpQyEgt3KbKTD9GYaAGdwmpUJN9KHrzTM7cqQRK/HCyrYiqyLMQJVWvBXLhIrYPZMpMUbHmEgOd0wQNlKv1mo+tMYf1eMHtSzSAetumDY3PWAa5eRZ1zppIV3R3ljn7ZfOkcb0tzO54tETssdazGe1oou8Y9nITgU=  ;
X-YMail-OSG: JVa7zOwVM1m9mj2bmF9.2Pzd6AhxozciFWa6YELQNt4Qbax5ukGT9TSE_Ol8NhrGcSNvf1HCbv8r4RkB9QHjhGc7Nc5XTvfSZYUx2.ruyO1DlX0daYnIZBE6qYGo31yetZXKKak4caLlxxo_aVlT1CqWKg--
Message-ID: <45F77149.7040604@yahoo.com.au>
Date: Wed, 14 Mar 2007 14:51:37 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>	<1173718208.11945.54.camel@localhost.localdomain>	<20070312235452.GB11578@MAIL.13thfloor.at>	<m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>	<45F67C2D.7020303@yahoo.com.au> <m1odmxrv2l.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1odmxrv2l.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> 
>>Eric W. Biederman wrote:
>>
>>>First touch page ownership does not guarantee give me anything useful
>>>for knowing if I can run my application or not.  Because of page
>>>sharing my application might run inside the rss limit only because
>>>I got lucky and happened to share a lot of pages with another running
>>>application.  If the next I run and it isn't running my application
>>>will fail.  That is ridiculous.
>>
>>Let's be practical here, what you're asking is basically impossible.
>>
>>Unless by deterministic you mean that it never enters the a non
>>trivial syscall, in which case, you just want to know about maximum
>>RSS of the process, which we already account).
> 
> 
> Not per process I want this on a group of processes, and yes that
> is all I want just.  I just want accounting of the maximum RSS of
> a group of processes and then the mechanism to limit that maximum rss.

Well don't you just sum up the maximum for each process?

Or do you want to only count shared pages inside a container once,
or something difficult like that?


>>>I don't want sharing between vservers/VE/containers to affect how many
>>>pages I can have mapped into my processes at once.
>>
>>You seem to want total isolation. You could use virtualization?
> 
> 
> No.  I don't want the meaning of my rss limit to be affected by what
> other processes are doing.  We have constraints of how many resources
> the box actually has.  But I don't want accounting so sloppy that
> processes outside my group of processes can artificially
> lower my rss value, which magically raises my rss limit.

So what are you going to do about all the shared caches and slabs
inside the kernel?


>>It is basically handwaving anyway. The only approach I've seen with
>>a sane (not perfect, but good) way of accounting memory use is this
>>one. If you care to define "proper", then we could discuss that.
> 
> 
> I will agree that this patchset is probably in the right general ballpark.
> But the fact that pages are assigned exactly one owner is pure non-sense.
> We can do better.  That is all I am asking for someone to at least attempt
> to actually account for the rss of a group of processes and get the numbers
> right when we have shared pages, between different groups of
> processes.  We have the data structures to support this with rmap.

Well rmap only supports mapped, userspace pages.


> Let me describe the situation where I think the accounting in the
> patchset goes totally wonky. 
> 
> 
> Gcc as I recall maps the pages it is compiling with mmap.
> If in a single kernel tree I do:
> make -jN O=../compile1 &
> make -jN O=../compile2 &
> 
> But set it up so that the two compiles are in different rss groups.
> If I run the concurrently they will use the same files at the same
> time and most likely because of the first touch rss limit rule even
> if I have a draconian rss limit the compiles will both be able to
> complete and finish.   However if I run either of them alone if I
> use the most draconian rss limit I can that allows both compiles to
> finish I won't be able to compile a single kernel tree.

Yeah it is not perfect. Fortunately, there is no perfect solution,
so we don't have to be too upset about that.

And strangely, this example does not go outside the parameters of
what you asked for AFAIKS. In the worst case of one container getting
_all_ the shared pages, they will still remain inside their maximum
rss limit.

So they might get penalised a bit on reclaim, but maximum rss limits
will work fine, and you can (almost) guarantee X amount of memory for
a given container, and it will _work_.

But I also take back my comments about this being the only design I
have seen that gets everything, because the node-per-container idea
is a really good one on the surface. And it could mean even less impact
on the core VM than this patch. That is also a first-touch scheme.


> However the messed up accounting that doesn't handle sharing between
> groups of processes properly really bugs me.  Especially when we have
> the infrastructure to do it right.
> 
> Does that make more sense?

I think it is simplistic.

Sure you could probably use some of the rmap stuff to account shared
mapped _user_ pages once for each container that touches them. And
this patchset isn't preventing that.

But how do you account kernel allocations? How do you account unmapped
pagecache?

What's the big deal so many accounting people have with just RSS? I'm
not a container person, this is an honest question. Because from my
POV if you conveniently ignore everything else... you may as well just
not do any accounting at all.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
