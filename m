Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXFGMAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXFGMAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXFGMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:00:07 -0400
Received: from smtpout.mac.com ([17.250.248.183]:49384 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbXFGMAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:00:05 -0400
In-Reply-To: <20070607110432.73be7960@the-village.bc.nu>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Date: Thu, 7 Jun 2007 07:59:47 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 07, 2007, at 06:04:32, Alan Cox wrote:
>> continuous allocation are part of the API.  It's required by POSIX  
>> and provided by Unix since the early days.  There are entire code  
>> bases out there which depend on this assumption.  Linking with  
>> code like this, before or after the new version controlled symbol  
>> is introduced, will break it.
>
> If your linker is doing its job then you won't be able to link them  
> together because they have incompatible assumptions. Not exactly  
> rocket science even if it is done a little differently to the usual  
> symbol compatibility tests.

No, there is a fundamental problem with "solving" this via linking.   
Many programs need the continuous FD allocation space, but then have  
tendancies to do things like:

   int i;
   for (i = 0; i < 1024; i++)
           if (i != comm_sock && i != server_sock)
                   close(i);

Yes I have seen many such programs, it seems to be a pretty standard  
idiom.

On the other hand, that makes it completely impossible for libraries  
to reliably use FDs behind the application's back; they might get  
closed on you at any time without warning.  One such library is  
glibc; it would really like to be able to use file-descriptors behind  
the back of the rest of userspace to implement certain functionality:
   http://www.mail-archive.com/linux-kernel@vger.kernel.org/ 
msg163522.html

Likewise there are a massive group of other libraries (especially  
user-interface and server related ones) that would really like to  
have support for creating file-descriptors without the top-level  
application closing them randomly (like several shells seem to).

Cheers,
Kyle Moffett

