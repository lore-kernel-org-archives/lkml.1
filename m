Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXBNVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXBNVno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964777AbXBNVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:43:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35123 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964781AbXBNVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:43:42 -0500
Date: Wed, 14 Feb 2007 21:56:13 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070214215613.56d76257@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu>
	<Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
	<20070214210251.GA15025@elte.hu>
	<Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  - it assumes we are going to make these complex state machines (which I 
>    don't believe for a second that a real program will do)

They've not had the chance before and there are certain chains of them
which make huge amounts of sense because you don't want to keep taking
completion hits. Not so much looping ones but stuff like

	cork write sendfile uncork close

are very natural sequences.

There seem to be a lot of typical sequences it doesn't represent however
(consider the trivial copy case where you use the result one syscall into
the next)

>  - it assumes that we're going to make many async system calls that go 
>    together (which breaks the whole notion of having different libraries 
>    using this for their own internal reasons - they may not even *know* 
>    about other libraries that _also_ do async IO for *their* reasons)

They can each register their own async objects. They need to do this
anyway so that the libraries can use asynchronous I/O and hide it from
applications.

>    this "AIO atom" in the first place, WHICH WE KNOW IS INCORRECT, since 
>    current users use "aio_read()" that simply doesn't have that and 
>    doesn't build up any such data structures.

Do current users do this because that is all they have, because it is
hard, or because the current option is all that makes sense ?

The ability to avoid asynchronous completion waits and
complete/wake/despatch cycles is a good thing of itself. I don't know if
it justifies the rest but it has potential for excellent performance.

Alan
