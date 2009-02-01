Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZBABn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZBABn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBABnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:43:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:63841 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZBABnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:43:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=QaWss75Ay00zQJ6kwy49+Q076JRkGripOqamCSaD37nuNA5aiqSlHGK9EOWyRegg3c
         SKt0xioGT30NlbyMnK+LuripwI4VymDjNeE2wTsW5EjmYCnCQYclsju6Krw5sFaGeSqD
         5o6D3gY4+etpdF80xsnJ+yfXh7qSc2439rhAE=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0901311728220.18888@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
	 <20090129005716.6dd51929.akpm@linux-foundation.org>
	 <cfd18e0f0901290203r139cb5bfgc02a0dcb1347aba8@mail.gmail.com>
	 <alpine.DEB.1.10.0901291053580.15448@alien.or.mcafeemobile.com>
	 <cfd18e0f0901311726n439d3034qa87f3ab31acd4858@mail.gmail.com>
	 <alpine.DEB.1.10.0901311728220.18888@alien.or.mcafeemobile.com>
Date: Sun, 1 Feb 2009 14:43:50 +1300
Message-ID: <cfd18e0f0901311743o48e192eftfbc37bf8136fe54@mail.gmail.com>
Subject: Re: [patch] drop epoll max_user_instances and rely only on 
	max_user_watches
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
       Bron Gondwana <brong@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Sun, Feb 1, 2009 at 2:30 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Sun, 1 Feb 2009, Michael Kerrisk wrote:
>
>> Hi Davide,
>>
>> On Fri, Jan 30, 2009 at 7:54 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
>> > On Thu, 29 Jan 2009, Michael Kerrisk wrote:
>> >
>> >> Since max_user_instances was added in 2.6.28, and this is an ABI
>> >> change, I suggest this should go into .29-rc, so that
>> >> max_user_instances spends as little time in the wild as possible.
>> >
>> > Agreed, like I already told Andrew. Sorry Michael for the double change to
>> > the man page :/
>>
>> So is the right change to the epoll(7) page (see
>> http://www.kernel.org/doc/man-pages/online/pages/man7/epoll.7.html )
>> to simply remive the text on max_user_instances:
>>
>>        /proc/sys/fs/epoll/max_user_instances (since Linux 2.6.28)
>>               This  specifies  an  upper  limit on the number of epoll
>>               instances that can be created per real user ID.
>>
>> Or are other changes also required?
>
> Yes. Plus, max_user_watches, instead of being 1/32 of lowmem, it's 4%.
> Just a detail.

Would you please review the following patch, which comments out the
text for max_user_instances, and updates the numbers for
max_user-watches.

Cheers,

Michael

diff --git a/man7/epoll.7 b/man7/epoll.7
index 7c67e13..6ee686e 100644
--- a/man7/epoll.7
+++ b/man7/epoll.7
@@ -172,10 +172,11 @@ with
 .SS /proc interfaces
 The following interfaces can be used to limit the amount of
 kernel memory consumed by epoll:
-.TP
-.IR /proc/sys/fs/epoll/max_user_instances " (since Linux 2.6.28)"
-This specifies an upper limit on the number of epoll instances
-that can be created per real user ID.
+.\" Following was added in 2.6.28, but them removed in 2.6.29
+.\" .TP
+.\" .IR /proc/sys/fs/epoll/max_user_instances " (since Linux 2.6.28)"
+.\" This specifies an upper limit on the number of epoll instances
+.\" that can be created per real user ID.
 .TP
 .IR /proc/sys/fs/epoll/max_user_watches " (since Linux 2.6.28)"
 This specifies a limit on the total number of
@@ -185,10 +186,10 @@ The limit is per real user ID.
 Each registered file descriptor costs roughly 90 bytes on a 32-bit kernel,
 and roughly 160 bytes on a 64-bit kernel.
 Currently,
-.\" 2.6.28
+.\" 2.6.29 (in 2.6.28, the default was 1/32 of lowmem)
 the default value for
 .I max_user_watches
-is 1/32 of the available low memory,
+is 1/25 (4%) of the available low memory,
 divided by the registration cost in bytes.
 .SS Example for Suggested Usage
 While the usage of
