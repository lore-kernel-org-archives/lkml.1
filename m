Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXFIOkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXFIOkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 10:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXFIOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 10:39:55 -0400
Received: from smtpout.mac.com ([17.250.248.178]:57999 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXFIOjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 10:39:54 -0400
In-Reply-To: <18026.15766.574693.200636@cargo.ozlabs.ibm.com>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com> <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com> <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com> <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com> <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu> <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <18026.15766.574693.200636@cargo.ozlabs.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <463C79D8-88CB-492A-96FD-10C10D16C4B6@mac.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Date: Sat, 9 Jun 2007 10:38:55 -0400
To: Paul Mackerras <paulus@samba.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 09, 2007, at 01:41:42, Paul Mackerras wrote:
> Davide Libenzi writes:
>
>> The only reason we use a floating base, is because Uli preferred  
>> to have non-exactly predictable fd allocations. There no reason of  
>> re-doing the same POSIX mistake all over again:
>
> Why must everything that makes things a bit simpler and more  
> predictable for application programmers be called a "mistake"?

1)  Linear FD allocation makes it IMPOSSIBLE for libraries to  
reliably use persistent FDs behind an application's back.  For  
example, this code sequence should almost always be OK: (except when  
calling into a library specifically to open a file or socket)

close(0);
some_library_function();
fd = open("some_file", O_RDWR);
/* fd == 0 here */

2)  Another common code example which causes problems:

int i;
for (i = 0; i < NR_OPEN; i++)
	if (!fd_is_special_to_us(i))
		close(i);

Note that this is conceptually buggy, but occurs in several major C  
programming books, most of the major shells, and a lot of other  
software to boot.

3) In order to allocate new FDs, the kernel has to scan over a  
(potentially very large) bitmap.  A process with 100,000 fds (not  
terribly uncommon) would have 12.5kbyte of FD bitmap and would trash  
the cache every time it tried to allocate an FD.

You can't even hope to use persistent library FDs with these  
problems, and they even cause problems with servers using lots of  
FDs.  Introducing another linear FD space will just make this sort of  
stuff happen ALL OVER AGAIN.

If you want to make things reproducible, you could have an option  
where the "random" algorithm is just pseudo-linearly allocated FDs  
(no bitmap search) XORed with a boot-time constant either randomly- 
generated or set in the boot args.  That way the people interested in  
maximum security or stress testing can use completely randomized  
numbers and the people who need reproducibility can get that too,  
*without* having the same linear FD allocation problems all over  
again.  The fundamental problem is that a series of numbers  
increasing linearly from X (especially where X == 0) are used as  
meaningful data by lazy programmers, instead of just as a cookie.  By  
nonlinearizing the data, even just a little, that becomes unlikely to  
occur.  It also forces programmers to use FDs correctly and prevents  
problems like this in the future.

Cheers,
Kyle Moffett
