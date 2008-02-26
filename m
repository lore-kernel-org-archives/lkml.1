Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbYBZPPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbYBZPPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761977AbYBZPOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:14:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:51180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYBZPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=HMH+mx3N6LIh1ZohIDdzohmm1CaNmqbsOkdqTOCyUlcJTeKUS/sJgzqWWVM7b98/xYaT3x5Q5dRVpCjKCeF67vWF5vOunwchu2UzvWzylD0QmHpoaortNtArteF22Y2Cbf3f77lfrCHJ9UiQU32jL7aZ4HNeWJok2c1f7mixS14=
Message-ID: <47C42CA7.4030607@gmail.com>
Date: Tue, 26 Feb 2008 16:13:43 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: David Schwartz <davids@webmaster.com>, dada1@cosmosbay.com,
       "Chris \"?\" Heath" <chris@heathens.co.nz>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: Re: epoll design problems with common fork/exec patterns
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com> <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Davide Libenzi wrote:
> On Sun, 28 Oct 2007, David Schwartz wrote:
> 
>> Eric Dumazet wrote:
>>
>>> Events are not necessarly reported "by descriptors". epoll uses an opaque
>>> field provided by the user.
>>>
>>> It's up to the user to properly chose a tag that will makes sense
>>> if the user
>>> app is playing dup()/close() games for example.
>> Great. So the only issue then is that the documentation is confusing. It
>> frequently uses the term "fd" where it means file. For example, it says:
>>
>>               Q1     What  happens  if  you  add  the  same fd to an
>> epoll_set
>>                      twice?
>>
>>               A1     You will probably get EEXIST.  However,  it  is
>> possible
>>                      that  two  threads  may  add the same fd twice. This is
>> a
>>                      harmless condition.
>>
>> This gives no reason to think there's anything wrong with adding the same
>> file twice so long as you do so through different descriptors. (One can
>> imagine an application that does this to segregate read and write operations
>> to avoid a race where the descriptor is closed from under a writer due to
>> handling a fatal read error.) Obviously, that won't work.
> 
> I agree, that is confusing. However, you can safely add two different file 
> descriptors pointing to the same file*, with different event masks, and 
> that will work as expected.

So can I summarize what I understand:

a) Adding the same file descriptor twice to an epoll set will cause an
error (EEXIST).

b) In a separate message to linux-man, Chris Heath says that two threads
*can't* add the same fd twice to an epoll set, despite what the existing
man page text says.  I haven't tested that, but it sounds to me as though
it is likely to be true.  Can you comment please Davide?

c) It is possible to add duplicated file descriptors referring to the same
underlying open file description ("file *").  As you note, this can be a
useful filtering technique, if the two file descriptors specify different
masks.

Assuming that is all correct, for man-pages-2.79, I've reworked the text
for Q1/A1 as follows:

       Q1     What  happens  if you add the same file descriptor
              to an epoll set twice?

       A1     You will probably get EEXIST.  However, it is pos-
              sible   to   add  a  duplicate  (dup(2),  dup2(2),
              fcntl(2) F_DUPFD, fork(2)) descriptor to the  same
              epoll  set.   This  can  be a useful technique for
              filtering events, if the duplicate  file  descrip-
              tors are registered with different events masks.

Seem okay Davide?

Cheers,

Michael

PS I've trimmed the part of this thread about Q6/A6, since I dealt with
that in another thread ("epoll and shared fd's").

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html

