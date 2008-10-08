Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYJHFKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYJHFKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 01:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYJHFKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 01:10:37 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:44722 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751028AbYJHFKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 01:10:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ikvSPjyZm6KEmueRAR4Cg7zx3ieT5rR87WeDqoG7g6zmJyCplcrLcx54HI5aJXUe7BJtuYsFA6aSiFy94J8s1j18rA9qcAG4sADXnZedrgjsNvFc8V5ToDGtaQnhIFOxJ+WMz2QqYKLc8WMC6SLBYlMR9aVkKBTFiR/AVhrC8e0=  ;
X-YMail-OSG: ILPAEdkVM1nJqPwNs7y9BUNmiw26MET0GKqPZuavIjrobL8vKjrCFEdjm.6C9WkRlSTFn3j6ImzUoLBooX53c97y6DbzspHFaWCSBe9fFU5CXqSSGF0trglmzJ9HkQIG5wv3DT2xWY0TUAeFg6JgrbIiEgeroxo5M_U.YSsu6A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 8 Oct 2008 16:10:26 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <200810081335.44576.nickpiggin@yahoo.com.au> <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081610.26768.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 15:48, Hisashi Hifumi wrote:
> At 11:35 08/10/08, Nick Piggin wrote:
> >On Wednesday 08 October 2008 05:59, Peter Zijlstra wrote:
> >> The whole point is that such usage is outside the specification and thus
> >> we don't strictly need to fix this.
> >>
> >> So the question Nick is asking is, do we want to slow down the kernel
> >> for a few broken user-space applications. Esp. since the race doesn't
> >> affect anybody else except the broken users of the file descriptor.
> >
> >Right you are. That's the fundamental question. The actual details of
> >the fix and how likely the race is don't really matter until we
> >answer the first question (except to say that the "fix" is never going
> >to be free).
>
> Simultaneous access by two or more writer can corrupt file content,
> so this case needs some locks(flock or fcntl) to preserve synchronization
> of file content. This is responsibility of user-space application.

Right.


> But file->f_pos race issue can occur even if multiple threads just read
> simultaneously. I think this is not responsibility of user-space
> application. To avoid this currently, an application needs some locks to
> protect file offset even if it just read a file. So I think f_pos race
> should be fixed.

What would they possibly hope to be reading, though? IOW. a read(2) still
*writes* to the fpos which userspace is very much aware of, and in exactly
the same way as write(2), so userspace should require the same obligations
to protect it in both cases I think. If you say they must protect file
content for writes, then it is valid to say that they must protect fd data
as well (ie. file offset).
